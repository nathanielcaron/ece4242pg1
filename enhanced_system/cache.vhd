-- cache memory module (SSRAM)

library ieee;
use ieee.std_logic_1164.all;

entity cache is
generic (
		CACHE_RAM_BUS_WIDTH	: 	natural := 32;
		DATA_WIDTH 			:	natural := 16;
		ADDR_WIDTH			:	natural := 10
);
port ( 	
		clock_a		: 	in std_logic;
		clock_b		: 	in std_logic;
		addr_a		:	in natural range 0 to 2**ADDR_WIDTH-1;
		addr_b		:	in natural range 0 to 2**ADDR_WIDTH-1;
		data_in_a	:	in std_logic_vector((DATA_WIDTH-1) downto 0);
		data_in_b	:	in std_logic_vector((CACHE_RAM_BUS_WIDTH-1) downto 0);
		we_a			:	in std_logic := '1';
		we_b			:	in std_logic := '1';
		data_out_a	:	out std_logic_vector((DATA_WIDTH-1) downto 0);
		data_out_b	:	out std_logic_vector((CACHE_RAM_BUS_WIDTH-1) downto 0)
);
end;

architecture behav of cache is
	subtype word_type is std_logic_vector((DATA_WIDTH-1) downto 0);
	type memory_type is array(2**ADDR_WIDTH-1 downto 0) of word_type;
	shared variable ram : memory_type;
begin

	-- port A
	process(clock_a)
	begin
		if (rising_edge(clock_a)) then

		end if;
		-- Can use clock A to access cache quickly
	end process;

	-- port B
	process(clock_b)
	begin
		if (rising_edge(clock_b)) then

		end if;
		-- Can use clock B to store cache back into main memory
	end process;

end behav;