-- cache memory module (SSRAM)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity cache is
generic (
        CACHE_RAM_BUS_WIDTH   :    natural := 32;
        DATA_WIDTH            :    natural := 16;
        ADDR_WIDTH            :    natural := 10;
        RAM_ADDR_WIDTH        :    natural := 9
);
--"A" signals are CPU facing, "B" signals are RAM facing
port (     
        clock_a          :     in std_logic;
        cache_ready      :     out std_logic;
        addr_a           :     in std_logic_vector((ADDR_WIDTH-1) downto 0);
        addr_b           :     in std_logic_vector((RAM_ADDR_WIDTH-1) downto 0);
        data_in_a        :     in std_logic_vector((DATA_WIDTH-1) downto 0);
        data_in_b        :     in std_logic_vector((CACHE_RAM_BUS_WIDTH-1) downto 0);
        we_a             :     in std_logic;
        we_b             :     in std_logic;
        re_a             :     in std_logic;
        re_b             :     in std_logic;
        data_out_a       :     out std_logic_vector((DATA_WIDTH-1) downto 0);
        data_out_b       :     out std_logic_vector((CACHE_RAM_BUS_WIDTH-1) downto 0)
);
end;

architecture behav of cache is
    -- Create array for cache data
    subtype word_type is std_logic_vector((DATA_WIDTH-1) downto 0);
    type cache_array is array (3 downto 0, 1 downto 0) of word_type;
    signal cache : cache_array := ((others=> (others=> "00000000")));
    -- Create array for cache line tags
    type cache_line_tag_array is array (0 to 3) of std_logic_vector (6 DOWNTO 0);
    signal cache_line_tags : cache_line_tag_array;
    -- Create array for cache line dirty bits (1 means it is dirty)
    type cache_line_dirty_bit is array (0 to 3) of std_logic;
    signal cache_line_dirty_bits : cache_line_dirty_bit := (others => '0');
    -- Create signals for bit structure of address
    signal address_word     : std_logic;
    signal address_line     : std_logic_vector (1 downto 0);
    signal address_tag      : std_logic_vector (6 downto 0);
    signal word_int         : integer;
    signal line_int         : integer;
    -- Create signals to trigger loads and write backs
    signal load_block            : std_logic := '0';
    signal write_back_block      : std_logic := '0';
    signal hit                   : std_logic := '0';
begin

    -- Break down address into bit structure (tag = 6 bits, line = 2 bits, word = 1 bit)
    address_tag <= addr_a(9 downto 3);
    address_line <= addr_a(2 downto 1);
    address_word <= addr_a(0);

    -- Convert line and word to integers to index into cache array
    word_int <= 1 when (address_word = '1') else 0;
    line_int <= to_integer(unsigned(address_line));

    -- Determine whether there is a HIT or a MISS
    hit <= '1' when address_tag = cache_line_tags(line_int) else '0';

    -- Process for writing to cache lines
    write : process(clock_a)
    begin
        if rising_edge(clock_a) then
            if address_tag = cache_line_tags(line_int) then
                -- HIT
                if (we_a = '1' and re_a = '0') then
                    -- write to word at the correct line and word index
                    cache(line_int, word_int) <= data_in_a;
                    -- MUST MARK BIT AS DIRTY
                    cache_line_dirty_bits(line_int) <= '1';
                end if;
            else
                -- MISS
                -- Step 1: Check if dirty bit, if dirty then must write back block
                -- Step 2: Once bit is clean, must load the new word
                -- Step 3: Poll until address_tag = cache_line_tags(line_int)
                -- Step 4: Perform write to cache
                -- MUST MARK BIT AS DIRTY
            end if;
        end if;
    end process;
    
    -- Process for reading from cache lines
    read : process(clock_a)
    begin
        if rising_edge(clock_a) then
            if address_tag = cache_line_tags(line_int) then
                -- HIT
                if (re_a = '1' and we_a = '0') then
                    -- output word at the correct line and word index
                    data_out_a <= cache(line_int, word_int);
                else
                    data_out_a <= "ZZZZZZZZ";
                end if;
            else
                -- MISS
                data_out_a <= "ZZZZZZZZ";
                -- Step 1: Check if dirty bit, if dirty then must write back block
                -- Step 2: Once bit is clean, must load the new word
                -- Step 3: Poll until address_tag = cache_line_tags(line_int)
                -- Step 4: Perform read from cache
            end if;
        end if;
    end process;
    
    -- Process for loading blocks of main memory into cache lines
    load : process(clock_b)
    begin
        if (rising_edge(clock_b)) then
            if (load_block = '1' and write_back_block = '0') then
                -- load block from main memory
                
            end if;
        end if;
    end process;

    -- Process for writing blocks back to main memory
    writeBack : process(clock_b)
    begin
        if (rising_edge(clock_b)) then
            if (write_back_block = '1' and load_block = '0') then
                -- write back block to main memory
                
            end if;
        end if;
    end process;

end behav;
