-- cache memory module

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
		rst				:	 in std_logic;
		clock_a			:	 in std_logic;
		addr_a			:	 in std_logic_vector(9 downto 0);
		data_in_a		:	 in std_logic_vector(15 downto 0);

		ram_input		:	 out std_logic_vector(31 downto 0);

		we_a			:	 in std_logic;
		re_a			:	 in std_logic;
		cache_ready		:	 out std_logic := '1';

		addr_ram_read	:	 out std_logic_vector(8 downto 0);
		addr_ram_write	:	 out std_logic_vector(8 downto 0);

		we_ram			:	 out std_logic;
		re_ram			:	 out std_logic;

		data_out_a		:	 out std_logic_vector(15 downto 0);

		ram_output		:	 in std_logic_vector(31 downto 0);

		hit				: 	  out std_logic;
		cachew0_db		:	 out std_logic_vector(15 downto 0);
		cachew1_db		:	 out std_logic_vector(15 downto 0);
		cachew2_db		:	 out std_logic_vector(15 downto 0);
		cachew3_db		:	 out std_logic_vector(15 downto 0);
		cachew4_db		:	 out std_logic_vector(15 downto 0);
		cachew5_db		:	 out std_logic_vector(15 downto 0);
		cachew6_db		:	 out std_logic_vector(15 downto 0);
		cachew7_db		:	 out std_logic_vector(15 downto 0);
		init_count_db 	: 	  out std_logic_vector(1 downto 0);
		c_state 		: 	  out std_logic_vector(7 downto 0)
);
end;

architecture behav of cache is
	-- Create array for cache data
	subtype word_type is std_logic_vector((DATA_WIDTH-1) downto 0);
	type cache_array is array (3 downto 0, 1 downto 0) of word_type;
	signal cache	: cache_array	:= ((others=> (others=> "ZZZZZZZZZZZZZZZZ")));
	-- Create array for cache line tags
	type cache_line_tag_array is array (0 to 3) of std_logic_vector (6 DOWNTO 0);
	signal cache_line_tags	: cache_line_tag_array;
	-- Create array for cache line dirty bits (1 means it is dirty)
	type cache_line_dirty_bit is array (0 to 3) of std_logic;
	signal cache_line_dirty_bits	: cache_line_dirty_bit	:= (others => '0');
	-- Create signals for bit structure of address
	signal address_word 	: std_logic;
	signal address_line 	: std_logic_vector (1 downto 0);
	signal address_tag 		: std_logic_vector (6 downto 0);
	signal word_int 		: integer range 0 to 1;
	signal line_int 		: integer range 0 to 3;
	-- Create signals to trigger loads and write backs
	signal load_block		: std_logic := '0';
	signal write_back_block	: std_logic := '0';
	--temp signal for the ram bus
	--signal block_to_RAM	: std_logic_vector(31 downto 0);
	--set delays for writback and load (CHECK COUNT FOR DELAY ONCE DONE!!!!!)
	signal WB_delay			: integer range 0 to 15 := 13;
	signal LD_delay			: integer range 0 to 15 := 13;
	signal LD_delay_startup	: integer range 0 to 15 := 14; --not 15 b/c startup_a takes a cycle
	
	--setting up state for case structure
	type state_type is (Init, Wr_writeback, writeback_delay, Write, Wr_clean_delay, 
	Rd_writeback, writeback_delay_rd, Read, Rd_clean_delay,
	startup, startup_a, startup_b, startup_delay);
	signal state			: state_type;
	signal delaystate		: state_type;
	signal current_State	: state_type;
	signal rdy_signal		: std_logic;
	signal hit_flag			: std_logic;
	signal init_count		: integer range 0 to 3	:= 0;
begin

	-- Break down address into bit structure (tag = 6 bits, line = 2 bits, word = 1 bit)
	address_tag <= addr_a(9 downto 3);
	address_line <= addr_a(2 downto 1);
	address_word <= addr_a(0);
	-- Convert line and word to integers to index into cache array
	word_int <= 1 when address_word = '1' else 0;
	line_int <= to_integer(unsigned(address_line));
	
	-- Determine whether there is a HIT or a MISS
	hit_flag <= 'Z' when (we_a='0' and re_a='0') else
					'1' when address_tag = cache_line_tags(line_int) else
					'0';

	-- main process
	process (clock_a, rst)
		variable writebackdelay	: integer range 0 to 15;
		variable loaddelay		: integer range 0 to 15;

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
		
		if rst='1' then
			state <= startup;
			rdy_signal <= '0';
			we_ram <= '0';
			re_ram <= '0';

		elsif rising_edge(clock_a) then
		
			case state is
				when startup =>
					c_state <= x"00";
				when startup_a =>
					c_state <= x"01";
				when startup_b =>
					c_state <= x"02";
				when startup_delay =>
					c_state <= x"03";
				when Init =>
					c_state <= x"10";
				when Wr_writeback =>
					c_state <= x"22";
				when writeback_delay =>
					c_state <= x"23";
				when Write =>
					c_state <= x"26";
				when Wr_clean_delay =>
					c_state <= x"27";
				when Rd_writeback =>
					c_state <= x"32";
				when writeback_delay_rd =>
					c_state <= x"33";
				when Read =>
					c_state <= x"36";
				when Rd_clean_delay =>
					c_state <= x"37";
				when others =>
					c_state <= x"FF";
			end case;

			case state is
				--initializing cache
				when startup =>
					addr_ram_read <= std_logic_vector(to_unsigned(init_count, 9));
					re_ram <= '1';
					state <= startup_a;

				when startup_a =>
					loaddelay	:= LD_delay_startup;
					state <= startup_delay;
					
				when startup_delay =>
					if loaddelay = 0 then
						state <= startup_b;
						loaddelay	:= LD_delay_startup;
						cache(init_count, 0) <= ram_output(15 downto 0);
						cache(init_count, 1) <= ram_output(31 downto 16);
						-- update tags
						cache_line_tags(init_count) <= std_logic_vector(to_unsigned(init_count, 10))(9 downto 3);
					else
						state <= startup_delay;
						loaddelay	:= loaddelay-1;
					end if;
					
				when startup_b =>
					if init_count = 3 then
						state <= Init;
						init_count <= 0;
						re_ram <= '0';
					else
						state <= startup;
						init_count <= init_count + 1;
					end if;

				--intitilizing state
				when Init =>
					-- set ready flag to one
					rdy_signal <= '1';
					re_ram <= '0';
					if we_a = '1' and re_a = '0' then
						if hit_flag = '1' then
							-- write to word at the correct line and word index
							cache(line_int, word_int) <= data_in_a;
							-- MUST MARK BIT AS DIRTY
							cache_line_dirty_bits(line_int) <= '1';
							--go wait for next address
							state <= Init;
						elsif hit_flag = '0' then
							if cache_line_dirty_bits(line_int) = '1' then
								-- set address for reading from RAM
								addr_ram_read <= addr_a(9 downto 1);
								-- set cache data on ram bus for writing
								ram_input(31 downto 16) <= cache(line_int, 1);
								ram_input(15 downto 0) <= cache(line_int, 0);
								-- set address for writing to RAM
								addr_ram_write(8 downto 2) <= cache_line_tags(line_int);
								addr_ram_write(1 downto 0) <= address_line;
								state <= Wr_writeback;
							else
								addr_ram_read <= addr_a(9 downto 1);
								re_ram <= '1'; --counts as first cycle of mem access
								state <= Wr_clean_delay;
								loaddelay	:= LD_delay;
							end if;
							rdy_signal <= '0';
						else
							state <= Init;
						end if;
					elsif we_a = '0' and re_a = '1' then
						if hit_flag = '1' then
							data_out_a <= cache(line_int, word_int);
							state <= Init;
						elsif hit_flag = '0' then
							data_out_a <= "ZZZZZZZZZZZZZZZZ";
							if cache_line_dirty_bits(line_int) = '1' then
								-- set address for reading from RAM
								addr_ram_read <= addr_a(9 downto 1);
								-- set cache data on ram bus for writing
								ram_input(31 downto 16) <= cache(line_int, 1);
								ram_input(15 downto 0) <= cache(line_int, 0);
								-- set address for writing to RAM
								addr_ram_write(8 downto 2) <= cache_line_tags(line_int);
								addr_ram_write(1 downto 0) <= address_line;
								state <= Rd_writeback;
							else
								addr_ram_read <= addr_a(9 downto 1);
								re_ram <= '1'; --counts as first cycle of mem access
								state <= Rd_clean_delay;
								loaddelay	:= LD_delay;
							end if;
							rdy_signal <= '0';
						else
							state <= Init;
						end if;
					end if;

			--Writing states				
				-- writeback + load
				When Wr_writeback => --counts as the first cycle of the mem access
					-- enable reading from and writing to RAM
					re_ram <= '1';
					we_ram <= '1'; --must be set after address loaded
					writebackdelay	:= WB_delay;
					state <= writeback_delay;
					
				when writeback_delay =>
					writebackdelay	:= writebackdelay-1;
				   if writebackdelay = 0 then
						state <= Write;
						we_ram <= '0';
					else
						state <= writeback_delay;
					end if;
				
				when Wr_clean_delay =>
					if loaddelay = 0 then
						state <= Write;
					else
						state <= Wr_clean_delay;
						loaddelay	:= loaddelay-1;
					end if;
								
				when Write => --counts as last cycle of mem access
					-- read from RAM
					cache_line_dirty_bits(line_int) <= '1';
					--overwriting the other anyway
					if(word_int = 1) then
						cache(line_int, 0) <= ram_output(15 downto 0);
					else
						cache(line_int, 1) <= ram_output(31 downto 16);
					end if;
					-- update tags
					cache_line_tags(line_int) <= address_tag;
					state <= Init;
					-- write to word at the correct line and word index
					cache(line_int, word_int) <= data_in_a;
					rdy_signal <= '1';
					
				--reading states
				When Rd_writeback => --counts as start of mem access
					-- enable reading from and writing to RAM
					re_ram <= '1';
					we_ram <= '1';
					writebackdelay	:= WB_delay;
					state <= writeback_delay_rd;
					
				when writeback_delay_rd =>
					writebackdelay	:= writebackdelay-1;
				   if writebackdelay = 0 then
						state <= Read;
						we_ram <= '0';
					else
						state <= writeback_delay_rd;
					end if;
				
				when Rd_clean_delay =>
					if loaddelay = 0 then
						state <= Read;
					else
						state <= Rd_clean_delay;
						loaddelay	:= loaddelay-1;
					end if;
					
				when Read =>
					-- Writing to cache
				   cache_line_dirty_bits(line_int) <= '0';
					cache(line_int, 0) <= ram_output(15 downto 0);
					cache(line_int, 1) <= ram_output(31 downto 16);
					if(word_int = 0) then
						data_out_a  <= ram_output(15 downto 0);
					else
						data_out_a  <= ram_output(31 downto 16);
					end if;
					-- update tags
					cache_line_tags(line_int) <= address_tag;
					state <= Init;
					rdy_signal <= '1';
												
			end case;
	
		end if;

		cache_ready <= rdy_signal;
		hit <= hit_flag;

	end process;
end behav;
