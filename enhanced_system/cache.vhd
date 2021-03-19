-- cache memory module (SSRAM)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity cache is
generic (
		CACHE_RAM_BUS_WIDTH	: 	integer range 0 to 32 := 32;
		DATA_WIDTH 			:	integer range 0 to 16 := 16;
		ADDR_WIDTH			:	integer range 0 to 10 := 10
);
--"A" signals are CPU facing, "B" signals are RAM facing
port (
		rst              :     in std_logic;
	   clock_a          :     in std_logic;
      addr_a           :     in std_logic_vector(9 downto 0);
      data_in_a        :     in std_logic_vector(15 downto 0);
      ram_input        :     out std_logic_vector(31 downto 0);
      we_a             :     in std_logic;
      re_a             :     in std_logic;
	   cache_ready      :     out std_logic := '1';
	   addr_b           :     out std_logic_vector(8 downto 0);
      we_b             :     out std_logic;
		re_b             :     out std_logic;
      data_out_a       :     out std_logic_vector(15 downto 0);
      ram_output       :     in std_logic_vector(31 downto 0);
	   hit				  : 	  out std_logic;
		cachew0_db       :     out std_logic_vector(15 downto 0);
		cachew1_db       :     out std_logic_vector(15 downto 0);
		cachew2_db       :     out std_logic_vector(15 downto 0);
		cachew3_db       :     out std_logic_vector(15 downto 0);
		cachew4_db       :     out std_logic_vector(15 downto 0);
		cachew5_db       :     out std_logic_vector(15 downto 0);
		cachew6_db       :     out std_logic_vector(15 downto 0);
		cachew7_db       :     out std_logic_vector(15 downto 0);
		init_count_db : out std_logic_vector(1 downto 0)
	 
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
	signal word_int 		: integer range 0 to 1;
	signal line_int 		: integer range 0 to 3;
	-- Create signals to trigger loads and write backs
	signal load_block			: std_logic := '0';
	signal write_back_block	:	std_logic := '0';
	--temp signal for the ram bus
	--signal block_to_RAM : std_logic_vector(31 downto 0);
	--set delays for writback and load (CHECK COUNT FOR DELAY ONCE DONE!!!!!)
	signal WB_delay : integer range 0 to 15 := 14;
	signal LD_delay : integer range 0 to 15 := 14;
	signal LD_delay_startup : integer range 0 to 15 := 14; --not 15 b/c startup_a takes a cycle
	
	--setting up state for case structure
	type state_type is (Init, Wr_miss, Wr_miss_writeback, Wr_miss_writeback_a, writeback_delay, Wr_miss_load, Wr_miss_load_a, load_delay, 
	actually_writing, Rd_miss, Rd_miss_writeback, Rd_miss_writeback_a, writeback_delay_rd, Rd_miss_load, Rd_miss_load_a, load_delay_rd,
	actually_reading, startup, startup_a, startup_b, startup_delay);
	signal state: state_type;
	signal delaystate: state_type;
	signal current_State : state_type;
	signal rdy_signal : std_logic;
	signal hit_flag : std_logic;
	signal init_count : integer range 0 to 3 := 0;
begin
	process (clock_a, rst)
	variable writebackdelay: integer range 0 to 15;
	variable loaddelay: integer range 0 to 15;

	begin
		--debug
		cachew0_db <= cache(0,0);
		cachew1_db <= cache(0,1);
		cachew2_db <= cache(1,0);
		cachew3_db <= cache(1,1);
		cachew4_db <= cache(2,0);
		cachew5_db <= cache(2,1);
		cachew6_db <= cache(3,0);
		cachew7_db <= cache(3,1);
		init_count_db <= std_logic_vector(to_unsigned(init_count, 2));
		
		if we_a = '1' xor re_a = '1' then
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
		else
			hit_flag <= 'Z';
--			address_tag <= "ZZZZZZZ";
--			address_line <= "ZZ";
--			address_word <= 'Z';
		end if;
		if rst='1' then
			state <= startup;
			rdy_signal <= '0';
			we_b <= '0';
			re_b <= '0';
			
		elsif rising_edge(clock_a) then
			case state is
				--initializing cache
				when startup =>
					addr_b <= std_logic_vector(to_unsigned(init_count, 9));
					re_b <= '1';
					state <= startup_a;

				when startup_a =>
					loaddelay := LD_delay_startup;
					state <= startup_delay;
					
				when startup_delay =>
					if loaddelay = 0 then
						state <= startup_b;
						loaddelay := LD_delay_startup;
						cache(init_count, 0) <= ram_output(15 downto 0);
						cache(init_count, 1) <= ram_output(31 downto 16);
					else
						state <= startup_delay;
						loaddelay := loaddelay-1;
					end if;
					
				when startup_b =>
					if init_count = 3 then
						state <= Init;
						init_count <= 0;
						re_b <= '0';
					else
						state <= startup;
						init_count <= init_count + 1;
					end if;

				--intitilizing state
				when Init =>
					-- set ready flag to one
					rdy_signal <= '1';
				
					
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
							rdy_signal <= '0';
						end if;
					elsif we_a = '0' and re_a = '1' then
						if hit_flag = '1' then
							data_out_a <= cache(line_int, word_int);
							state <= Init;
						else
							data_out_a <= "ZZZZZZZZZZZZZZZZ";
							state <= Rd_miss;
							rdy_signal <= '0';
						end if;
					end if;
			--Writing states
				when Wr_miss => 
					if cache_line_dirty_bits(line_int) = '1' then --could check in previous state if line_int is safe
						state <= Wr_miss_writeback;
					else
						state <= Wr_miss_load;
					end if;

				When Wr_miss_writeback =>
					ram_input(31 downto 16) <= cache(line_int, 1);
					ram_input(15 downto 0) <= cache(line_int, 0);
					addr_b(8 downto 2) <= cache_line_tags(line_int);
					addr_b(1 downto 0) <= address_line;
					state <= Wr_miss_writeback_a;
					
				When Wr_miss_writeback_a =>
					we_b <= '1'; 
					writebackdelay := WB_delay;
					state <= writeback_delay;
					
				when writeback_delay =>
				   if writebackdelay = 0 then
						state <= Wr_miss_load;
						we_b <= '0';
					else
						state <= writeback_delay;
						writebackdelay := writebackdelay-1;
					end if;
					
				when Wr_miss_load =>
					addr_b <= addr_a(9 downto 1);
					re_b <= '1';
					state <= Wr_miss_load_a;
										
				when Wr_miss_load_a =>
					cache(line_int, 0) <= ram_output(15 downto 0);
					cache(line_int, 1) <= ram_output(31 downto 16);
					loaddelay := LD_delay;
					state <= load_delay;
				
				when load_delay =>
					if loaddelay = 0 then
						state <= actually_writing;
					else
						state <= load_delay;
						loaddelay := loaddelay-1;
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
					if cache_line_dirty_bits(line_int) = '1' then --could check in previous state if line_int is safe
						state <= Rd_miss_writeback;
					else
						state <= Rd_miss_load;
					end if;
					
				When Rd_miss_writeback =>
					ram_input(31 downto 16) <= cache(line_int, 1);
					ram_input(15 downto 0) <= cache(line_int, 0);
					addr_b(8 downto 2) <= cache_line_tags(line_int);
					addr_b(1 downto 0) <= address_line;
					state <= Rd_miss_writeback_a;
					
				When Rd_miss_writeback_a =>
					we_b <= '1';
					writebackdelay := WB_delay; 
					state <= writeback_delay_rd;
					
				when writeback_delay_rd =>
				   if writebackdelay = 0 then
						state <= Rd_miss_load;
						we_b <= '0';
					else
						state <= writeback_delay_rd;
						writebackdelay := writebackdelay-1;
					end if;
					
				when Rd_miss_load =>
					addr_b <= addr_a(9 downto 1);
					re_b <= '1';
					state <= Rd_miss_load_a;
										
				when Rd_miss_load_a =>
				   cache_line_dirty_bits(line_int) <= '0';
					cache(line_int, 0) <= ram_output(15 downto 0);
					cache(line_int, 1) <= ram_output(31 downto 16);
					loaddelay := LD_delay;
					state <= load_delay_rd;
				
				when load_delay_rd =>
					if loaddelay = 0 then
						state <= actually_reading;
					else
						state <= load_delay_rd;
						loaddelay := loaddelay-1;
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
