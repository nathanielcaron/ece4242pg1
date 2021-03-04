-- cache memory module (SSRAM)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity cache is
generic (
		CACHE_RAM_BUS_WIDTH	: 	natural := 32;
		DATA_WIDTH 			:	natural := 16;
		ADDR_WIDTH			:	natural := 10
);
port (
		rst              :     in std_logic;
	   clock_a          :     in std_logic;
      addr_a           :     in std_logic_vector(9 downto 0);
      data_in_a        :     in std_logic_vector(15 downto 0);
      data_in_b        :     in std_logic_vector(31 downto 0);
      we_a             :     in std_logic;
      re_a             :     in std_logic;
	   cache_ready      :     out std_logic := '1';
	   addr_b           :     out std_logic_vector(8 downto 0);
      we_b             :     out std_logic;
		re_b             :     out std_logic;
      data_out_a       :     out std_logic_vector(15 downto 0);
      data_out_b       :     out std_logic_vector(31 downto 0);
	   hit				  : 	  out std_logic
	 
);
end;

architecture behav of cache is
	-- Create array for cache data
	subtype word_type is std_logic_vector((DATA_WIDTH-1) downto 0);
	type cache_array is array (3 downto 0, 1 downto 0) of word_type;
	signal cache : cache_array := ((others=> (others=> "ZZZZZZZZZZZZZZZZ")));
	-- Create array for cache line tags
	type cache_line_tag_array is array (0 to 3) of std_logic_vector (6 DOWNTO 0);
	signal cache_line_tags : cache_line_tag_array;
	-- Create array for cache line dirty bits (1 means it is dirty)
	type cache_line_dirty_bit is array (0 to 3) of std_logic;
	signal cache_line_dirty_bits : cache_line_dirty_bit := (others => '0');
	-- Create signals for bit structure of address
	signal address_word 	: std_logic;
	signal address_line 	: std_logic_vector (1 downto 0);
	signal address_tag 	: std_logic_vector (6 downto 0);
	signal word_int 		: integer;
	signal line_int 		: integer;
	-- Create signals to trigger loads and write backs
	signal load_block			: std_logic := '0';
	signal write_back_block	:	std_logic := '0';
	--temp signal for the ram bus
	signal block_to_RAM : std_logic_vector(31 downto 0);
	--set delays for writback and load (CHECK COUNT FOR DELAY ONCE DONE!!!!!)
	signal WB_delay : integer := 12;
	signal LD_delay : integer := 12;
	
	--setting up state for case structure
	type state_type is (Init, Wr_miss, Wr_miss_writeback, Wr_miss_writeback_a, writeback_delay, Wr_miss_load, Wr_miss_load_a, Wr_miss_load_b, load_delay, 
	actually_writing, Rd_miss, Rd_miss_writeback, Rd_miss_writeback_a, writeback_delay_rd, Rd_miss_load, Rd_miss_load_a, Rd_miss_load_b, load_delay_rd,
	actually_reading);
	signal state: state_type;
	signal delaystate: state_type;
	signal current_State : state_type;
	signal rdy_signal : std_logic;
	signal hit_flag : std_logic;
begin
	process (clock_a, rst)
	variable writebackdelay: integer;
	variable loaddelay: integer;
	begin
		if rst='1' then
			state <= Init;
			
		elsif rising_edge(clock_a) then
			case state is
				--intitilizing state
				when Init =>
					-- set ready flag to one
					rdy_signal <= '1';
					-- Break down address into bit structure (tag = 6 bits, line = 2 bits, word = 1 bit)
					address_tag <= addr_a(9 downto 3);
					address_line <= addr_a(2 downto 1);
					address_word <= addr_a(0);
				
					-- Convert line and word to integers to index into cache array
					if address_word = '1' then
						word_int <= 1;
					else
						word_int <= 0;
					end if;
					
					line_int <= to_integer(unsigned(address_line));

					-- Determine whether there is a HIT or a MISS
					if address_tag = cache_line_tags(line_int) then
						hit_flag <= '1';
					else 
						hit_flag <= '0';
					end if;
					
					if we_a = '1' and re_a = '0' then
						if hit_flag = '1' then
							-- write to word at the correct line and word index
							cache(line_int, word_int) <= data_in_a;
							-- MUST MARK BIT AS DIRTY
							cache_line_dirty_bits(line_int) <= '1';
							--go wait for next address
							state <= Init;
						else
							state <= Wr_miss;
						end if;
					elsif we_a = '0' and re_a = '1' then
						if hit_flag = '1' then
							data_out_a <= cache(line_int, word_int);
							state <= Init;
						else
							data_out_a <= "ZZZZZZZZZZZZZZZZ";
							state <= Rd_miss;
						end if;
					end if;
			--Writing states						
				when Wr_miss =>
					rdy_signal <= '0';
					if cache_line_dirty_bits(line_int) = '1' then
						state <= Wr_miss_writeback;
					else
						state <= Wr_miss_load;
					end if;
					
				When Wr_miss_writeback =>
					block_to_RAM(31 downto 16) <= cache(line_int, 0);
					block_to_RAM(15 downto 0) <= cache(line_int, 1);
					addr_b <= addr_a(9 downto 1);
					state <= Wr_miss_writeback_a;
					
				When Wr_miss_writeback_a =>
					we_b <= '1';
					writebackdelay := WB_delay; 
					state <= writeback_delay;
					
				when writeback_delay =>
					writebackdelay := writebackdelay-1;
				   if writebackdelay = 0 then
						state <= Wr_miss_load;
					else
						state <= writeback_delay;
					end if;
					
				when Wr_miss_load =>
					we_b <= '0';
					addr_b <= addr_a(9 downto 1);
					state <= Wr_miss_load_a;
					
				when Wr_miss_load_a =>
					re_b <= '1';
					state <= Wr_miss_load_b;
										
				when Wr_miss_load_b =>
					cache(line_int, 0) <= data_in_b(31 downto 16);
					cache(line_int, 1) <= data_in_b(15 downto 0);
					loaddelay := LD_delay;
					state <= load_delay;
				
				when load_delay =>
					loaddelay := loaddelay-1;
					if loaddelay = 0 then
						state <= actually_writing;
					else
						state <= load_delay;
					end if;
				
				when actually_writing =>
					re_b <= '0';
					-- write to word at the correct line and word index
					cache(line_int, word_int) <= data_in_a;
					-- MUST MARK BIT AS DIRTY
					cache_line_dirty_bits(line_int) <= '1';
					--go wait for next address
					state <= Init;
					rdy_signal <= '1';
					
			--reading states
				when Rd_miss =>
					rdy_signal <= '0';
					if cache_line_dirty_bits(line_int) = '1' then
						state <= Rd_miss_writeback;
					else
						state <= Rd_miss_load;
					end if;
					
				When Rd_miss_writeback =>
					block_to_RAM(31 downto 16) <= cache(line_int, 0);
					block_to_RAM(15 downto 0) <= cache(line_int, 1);
					addr_b <= addr_a(9 downto 1);
					state <= Rd_miss_writeback_a;
					
				When Rd_miss_writeback_a =>
					we_b <= '1';
					writebackdelay := WB_delay; 
					state <= writeback_delay_rd;
					
				when writeback_delay_rd =>
					writebackdelay := writebackdelay-1;
				   if writebackdelay = 0 then
						state <= Wr_miss_load;
					else
						state <= writeback_delay_rd;
					end if;
					
				when Rd_miss_load =>
				   we_b <= '0';
					addr_b <= addr_a(9 downto 1);
					state <= Rd_miss_load_a;
					
				when Rd_miss_load_a =>
					re_b <= '1';
					state <= Rd_miss_load_b;
										
				when Rd_miss_load_b =>
				   cache_line_dirty_bits(line_int) <= '0';
					cache(line_int, 0) <= data_in_b(31 downto 16);
					cache(line_int, 1) <= data_in_b(15 downto 0);
					loaddelay := LD_delay;
					state <= load_delay_rd;
				
				when load_delay_rd =>
					loaddelay := loaddelay-1;
					if loaddelay = 0 then
						state <= actually_writing;
					else
						state <= load_delay_rd;
					end if;
				
				when actually_reading =>
					re_b <= '0';
					data_out_a <= cache(line_int, word_int);
					state <= Init;
					rdy_signal <= '1';	
												
			end case;	
		end if;
		cache_ready <= rdy_signal;
		hit <= hit_flag;
	end process;
end behav;