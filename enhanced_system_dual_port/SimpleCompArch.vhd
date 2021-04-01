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
        D_mdout_bus,D_mdin_bus                	: out std_logic_vector(15 downto 0);
		  D_RAM_d_out 										: out std_logic_vector(31 downto 0); 
        D_mem_addr                            	: out std_logic_vector(9 downto 0); 
        D_Mre,D_Mwe                           	: out std_logic;
        D_RAMre,D_RAMwe                         : out std_logic;
		  D_cachew0       								: out std_logic_vector(15 downto 0);
		  D_cachew1       								: out std_logic_vector(15 downto 0);
		  D_cachew2       								: out std_logic_vector(15 downto 0);
		  D_cachew3       								: out std_logic_vector(15 downto 0);
		  D_cachew4       								: out std_logic_vector(15 downto 0);
		  D_cachew5       								: out std_logic_vector(15 downto 0);
		  D_cachew6       								: out std_logic_vector(15 downto 0);
		  D_cachew7       								: out std_logic_vector(15 downto 0);
		  D_cache_hit                           	: out std_logic;
		  D_addr_b_rd, D_addr_b_wr            		: out std_logic_vector(8 downto 0);
		  D_cache_ready   								: out std_logic;
		  D_init_count 									: out std_logic_vector(1 downto 0);
		  ctrl_state 										: out std_logic_vector(7 downto 0);
		  D_PC												: out std_logic_vector(15 downto 0);
		  cache_state                             : out std_logic_vector(7 downto 0);
		  D_Inst_count 									: out std_logic_vector(15 downto 0)
        -- end debug variables    
);
end;

architecture rtl of SimpleCompArch is
    --Memory local variables                                                             (ORIGIN    -> DEST)
    signal mdout_bus            		: std_logic_vector(15 downto 0);  -- Mem data output     (MEM      -> CTLU)
    signal mdin_bus             		: std_logic_vector(15 downto 0);  -- Mem data bus input  (CTRLER    -> Mem)
    
	 signal mdout_bus_ram_a          : std_logic_vector(31 downto 0);
	 signal mdout_bus_ram_b          : std_logic_vector(31 downto 0);
	 
    signal mdin_bus_ram_a           : std_logic_vector(31 downto 0);
	 signal mdin_bus_ram_b           : std_logic_vector(31 downto 0);
    
	 signal mem_addr             		: std_logic_vector(9 downto 0);   -- Const. operand addr.(CTRLER    -> MEM)
    
	 signal mem_addr_ram_a           : std_logic_vector(8 downto 0);
	 signal mem_addr_ram_b           : std_logic_vector(8 downto 0);
    
	 signal Mre                  		: std_logic;                    -- Mem. read enable      (CTRLER    -> Mem) 
    signal Mwe                  		: std_logic;                    -- Mem. write enable     (CTRLER    -> Mem)
    
	 signal Mre_ram_a                : std_logic;
	 signal Mre_ram_b                : std_logic := '0'; -- Port b of RAM is used for writing only
	 
    signal Mwe_ram_a                : std_logic := '0'; -- Port a of RAM is used for reading only
	 signal Mwe_ram_b                : std_logic;
    
	 signal cache_ready          		: std_logic;
	 signal cache_hit            		: std_logic;  
	 signal cachew0_db       	:     std_logic_vector(15 downto 0);
	 signal cachew1_db       	:     std_logic_vector(15 downto 0);
	 signal cachew2_db       	:     std_logic_vector(15 downto 0);
	 signal cachew3_db       	:     std_logic_vector(15 downto 0);
	 signal cachew4_db       	:     std_logic_vector(15 downto 0);
	 signal cachew5_db       	:     std_logic_vector(15 downto 0);
	 signal cachew6_db       	:     std_logic_vector(15 downto 0);
	 signal cachew7_db       	:     std_logic_vector(15 downto 0);
	 signal init_count_db 		: std_logic_vector(1 downto 0);
	 signal c_state 				: std_logic_vector(7 downto 0);
	 signal ct_state 				: std_logic_vector(7 downto 0);
	 signal Inst_count 			: std_logic_vector(15 downto 0);

    --System local variables
    signal oe                   : std_logic;    
begin

Unit1: CPU port map (sys_clk,sys_rst,mdout_bus,mdin_bus,mem_addr,Mre,Mwe,oe, 
                    D_rfout_bus,D_RFwa,D_RFr1a,D_RFr2a,D_RFwe,            --Debug signals
                    D_RFr1e,
						  D_RFr2e,
						  D_RFs,
						  D_ALUs,
						  D_PCld,
						  D_jpz,
                    cache_ready,ct_state, D_PC, Inst_count);
                    
-- dual port RAM                                             
Unit2: ram_dual_port port map(mem_addr_ram_a, mem_addr_ram_b, sys_clk,
										mdin_bus_ram_a, mdin_bus_ram_b,
										Mre_ram_a, Mre_ram_b, Mwe_ram_a, Mwe_ram_b,
										mdout_bus_ram_a, mdout_bus_ram_b);

Unit3: obuf port map(oe, mdout_bus, sys_output);

Unit4: cache port map(sys_rst, sys_clk, mem_addr, mdin_bus,
							 mdin_bus_ram_b, Mwe, Mre, cache_ready,
                      mem_addr_ram_a, mem_addr_ram_b, Mwe_ram_b, Mre_ram_a,
							 mdout_bus,
							 mdout_bus_ram_a, cache_hit, cachew0_db, 
							 cachew1_db, cachew2_db, cachew3_db, cachew4_db, cachew5_db, cachew6_db,
							 cachew7_db, init_count_db, c_state);

-- Debug signals: output to upper level for simulation purpose only
    D_mdout_bus <= mdout_bus;    
    D_mdin_bus <= mdin_bus;
    D_mem_addr <= mem_addr; 
    D_Mre <= Mre;
    D_Mwe <= Mwe;
    D_RAMre <= Mre_ram_a;
    D_RAMwe <= Mwe_ram_b;
	 D_cachew0 <= cachew0_db;
	 D_cachew1 <= cachew1_db;
	 D_cachew2 <= cachew2_db;
	 D_cachew3 <= cachew3_db;
	 D_cachew4 <= cachew4_db;
	 D_cachew5 <= cachew5_db;
	 D_cachew6 <= cachew6_db;
	 D_cachew7 <= cachew7_db;
	 D_cache_hit <= cache_hit;
	 D_addr_b_rd <= mem_addr_ram_a;
	 D_addr_b_wr <= mem_addr_ram_b;
	 D_init_count <= init_count_db;
	 D_RAM_d_out <= mdout_bus_ram_a;
	 cache_state <= c_state;
	 ctrl_state <= ct_state;
	 D_cache_ready <= cache_ready;
	 D_Inst_count <= Inst_count;
-- end debug variables        
        
end rtl;
