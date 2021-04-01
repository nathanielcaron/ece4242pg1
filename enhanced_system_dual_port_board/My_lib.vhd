-- Use this for a custom library

library ieee;
use ieee.std_logic_1164.all;  
use ieee.std_logic_arith.all;

PACKAGE My_lib IS

	COMPONENT my_system_console IS
   PORT ( 
		CLOCK_50		:	 IN STD_LOGIC;
		ledg_vir		:	 IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		ledr_vir		:	 IN STD_LOGIC_VECTOR(17 DOWNTO 0);
		hex0_vir		:	 IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		hex1_vir		:	 IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		hex2_vir		:	 IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		hex3_vir		:	 IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		hex4_vir		:	 IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		hex5_vir		:	 IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		hex6_vir		:	 IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		hex7_vir		:	 IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		key_vir		:	 OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		sw_vir		:	 OUT STD_LOGIC_VECTOR(17 DOWNTO 0));
   END COMPONENT;

	COMPONENT user_logic IS
	PORT(
	 -- INTERFACE WITH THE DE2-115 BOARD
		CLOCK_50 								: 		IN std_logic; 					  			-- CLOCK 
		LEDG										:		OUT std_logic_vector(8 downto 0);	-- LEDs 
		LEDR										:		OUT std_logic_vector(17 downto 0);		
		KEY										:		IN std_logic_vector(3 downto 0);		-- KEYs 	
		SW											:		IN std_logic_vector(17 downto 0);   -- SWITCHEs 	
		HEX0, HEX1, HEX2, HEX3				:		OUT std_logic_vector(6 downto 0);   -- 7-SEGMENTS 
		HEX4, HEX5, HEX6, HEX7				:		OUT std_logic_vector(6 downto 0);

		-- INTERFACE WITH THE VIRTUAL GUI
		ledg_vir									:		OUT std_logic_vector(8 downto 0);	-- VIRTUAL LEDs 
		ledr_vir									:		OUT std_logic_vector(17 downto 0);
		key_vir									:		IN std_logic_vector(3 downto 0);		-- VIRTUAL KEYs 
		sw_vir									:		IN std_logic_vector(17 downto 0);	-- VIRTUAL SWITCHEs 
		hex0_vir, hex1_vir, hex2_vir  	:		OUT std_logic_vector(6 downto 0);	-- Vir7-SEGMENTS 
		hex3_vir, hex4_vir 					:		OUT std_logic_vector(6 downto 0);
		hex5_vir, hex6_vir 					:		OUT std_logic_vector(6 downto 0);
		hex7_vir									:		OUT std_logic_vector(6 downto 0));
	END COMPONENT;

COMPONENT clk_gen_1_output IS
  GENERIC( n  : integer := 25000;
           n1 : integer := 2000);  
  PORT( Clock : in  std_logic;
        c_out : out std_logic );
end COMPONENT;
COMPONENT clk_gen_4_output IS
  GENERIC( n  : integer := 25000;
           n1 : integer := 2000);  
  PORT( Clock : in  std_logic;
        c_out : out std_logic_vector (3 downto 0));
end COMPONENT;

component SimpleCompArch is
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
		  D_addr_b_rd            						: out std_logic_vector(8 downto 0);
		  D_addr_b_wr            						: out std_logic_vector(8 downto 0);
		  D_cache_ready   								: out std_logic;
		  D_init_count 									: out std_logic_vector(1 downto 0);
		  ctrl_state 										: out std_logic_vector(7 downto 0);
		  D_PC												: out std_logic_vector(15 downto 0);
		  cache_state                             : out std_logic_vector(7 downto 0);
        -- end debug variables
		
		  -- board output
		  button							: in std_logic;
		  Hex0								:	out std_logic_vector(6 downto 0);
		  Hex1								:	out std_logic_vector(6 downto 0)
);
end component;

end My_lib;


package body My_lib is

------   Implementation of the functions   -----



end My_lib;

