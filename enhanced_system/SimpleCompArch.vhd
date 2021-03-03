------------------------------------------------------------------
-- Simple Computer Architecture
--
-- System composed of
--     CPU, Memory and output buffer
--    Sinals with the prefix "D_" are set for Debugging purpose only
-- SimpleCompArch.vhd
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;  
use ieee.numeric_std.all;               
use work.MP_lib.all;

entity SimpleCompArch is
port( sys_clk                               :    in std_logic;
          sys_rst                           :    in std_logic;
          sys_output                        :    out std_logic_vector(15 downto 0);
        
        -- Debug signals from CPU: output for simulation purpose only    
        D_rfout_bus                         : out std_logic_vector(15 downto 0);  
        D_RFwa, D_RFr1a, D_RFr2a            : out std_logic_vector(3 downto 0);
        D_RFwe, D_RFr1e, D_RFr2e            : out std_logic;
        D_RFs                               : out std_logic_vector(1 downto 0);
        D_ALUs                              : out std_logic_vector(2 downto 0);
        D_PCld, D_jpz                       : out std_logic;
        -- end debug variables    

        -- Debug signals from Memory: output for simulation purpose only    
        D_mdout_bus,D_mdin_bus                : out std_logic_vector(15 downto 0); 
        D_mem_addr                            : out std_logic_vector(9 downto 0); 
        D_Mre,D_Mwe                           : out std_logic 
        -- end debug variables    
);
end;

architecture rtl of SimpleCompArch is
    --Memory local variables                                                             (ORIGIN    -> DEST)
    signal mdout_bus            : std_logic_vector(15 downto 0);  -- Mem data output     (MEM      -> CTLU)
    signal mdin_bus             : std_logic_vector(15 downto 0);  -- Mem data bus input  (CTRLER    -> Mem)
    signal mdout_bus32          : std_logic_vector(31 downto 0);
    signal mdin_bus32           : std_logic_vector(31 downto 0);
    signal mem_addr             : std_logic_vector(9 downto 0);   -- Const. operand addr.(CTRLER    -> MEM)
    signal mem_addr9            : std_logic_vector(8 downto 0);
    signal Mre                  : std_logic;                    -- Mem. read enable      (CTRLER    -> Mem) 
    signal Mwe                  : std_logic;                    -- Mem. write enable     (CTRLER    -> Mem)
    signal Mre32                : std_logic;                    -- Mem. read enable      (CTRLER    -> Mem) 
    signal Mwe32                : std_logic;                    -- Mem. write enable     (CTRLER    -> Mem)
    signal cache_ready          : std_logic;

    --System local variables
    signal oe                    : std_logic;    
begin

Unit1: CPU port map (sys_clk,sys_rst,mdout_bus,mdin_bus,mem_addr,Mre,Mwe,oe,
                    D_rfout_bus,D_RFwa, D_RFr1a, D_RFr2a,D_RFwe,            --Debug signals
                    D_RFr1e, D_RFr2e,D_RFs, D_ALUs,D_PCld, D_jpz,           --Debug signals
                    mem_addr9, mdin_bus32, Mre32, Mwe32, mdout_bus32        --RAM
                    clock_b                                                 --cache
                    );
                                                                                    
Unit2: ram32bus port map(mem_addr9, sys_clk, mdin_bus32, Mre32, Mwe32, mdout_bus32);
Unit3: obuf port map(oe, mdout_bus, sys_output);
Unit4: cache port map(sys_clk, cache_ready, 
                    mem_addr, mem_addr9,
                    mdin_bus, mdin_bus32,
                    Mwe, Mwe32,
                    Mre, Mre32,
                    mdout_bus, mdout_bus32
                    );

-- Debug signals: output to upper level for simulation purpose only
    D_mdout_bus <= mdout_bus;    
    D_mdin_bus <= mdin_bus;
    D_mem_addr <= mem_addr; 
    D_Mre <= Mre;
    D_Mwe <= Mwe;
-- end debug variables        
        
end rtl;
