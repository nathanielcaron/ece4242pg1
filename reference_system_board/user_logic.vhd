-- Quartus Prime VHDL Template
-- User_logic block of the simulated GUI
--    instructions: 
--			- Add your logic to this file to actuate over resources in the DE2-115 board
--			- Add you code in the section designated "-   USER DESIGN AREA    -"
--       - Only LED, SWITCHES and 7-SEGMENTS are available for remote control & visualization
--       - Variables ending in "_vir_l" are the virtual inputs and outputs that you should use
--			  to control inputs and outputs  
--
-- 		-- Default I/O states:
					-- All LEDs and 7-Segments outputs are OFF
					-- Input from board not assigned to the virtual interface   

library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.My_lib.all;

entity user_logic is
	port(
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
end user_logic;


-- Architecture:

architecture userlogic_arch of user_logic is
signal	ledg_vir_l				: 	std_logic_vector(8 downto 0):= "000000000";	
signal	ledr_vir_l				:	std_logic_vector(17 downto 0):= "000000000000000000" ; 
signal	hex0_vir_l				:	std_logic_vector(6 downto 0):= ("1111111");	
signal	hex1_vir_l				:	std_logic_vector(6 downto 0):= ("1111111");		 
signal	hex2_vir_l  			:	std_logic_vector(6 downto 0):= ("1111111");	
signal	hex3_vir_l				:	std_logic_vector(6 downto 0):= ("1111111");	
signal	hex4_vir_l				:	std_logic_vector(6 downto 0):= ("1111111");		 
signal	hex5_vir_l  			:	std_logic_vector(6 downto 0):= ("1111111");		
signal	hex6_vir_l				:	std_logic_vector(6 downto 0):= "1111111";		
signal	hex7_vir_l				:	std_logic_vector(6 downto 0):= "1111111";		 

signal a_i							:	std_logic_vector(3  downto 0);
signal y_i							:	std_logic_vector(15 downto 0);
signal En							:	std_logic;
signal s_o							:	std_logic_vector(15 downto 0);
signal clk							:  std_logic;
signal clear						:  std_logic;
signal preset						:  std_logic;
signal Q								:  std_logic_vector(3 downto 0);
signal Qn							:  std_logic_vector(3 downto 0);

	-- Debug signals from CPU: output for simulation purpose only	
signal D_rfout_bus											: std_logic_vector(15 downto 0);  
signal D_RFwa, D_RFr1a, D_RFr2a				: std_logic_vector(3 downto 0);
signal D_RFwe, D_RFr1e, D_RFr2e				: std_logic;
signal D_RFs										: std_logic_vector(1 downto 0);
signal D_ALUs										: std_logic_vector(2 downto 0);
signal D_PCld, D_jpz										: std_logic;
signal sys_out												: std_logic_vector(15 downto 0);
-- end debug variables	

-- Debug signals from Memory: output for simulation purpose only	
signal D_mdout_bus,D_mdin_bus					: std_logic_vector(15 downto 0); 
signal D_mem_addr											: std_logic_vector(9 downto 0); 
signal D_Mre,D_Mwe										: std_logic;
signal reset												: std_logic;
signal button												: std_logic;
-- end debug variables	

begin
-----------   USER DESIGN AREA    -------------- 
--a_i<=sw_vir(3 downto 0);
G0: clk_gen_1_output generic map (200,200) port map(CLOCK_50,clk);
En <= sw_vir(0);
clear <= key_vir(0);
preset <= key_vir(1);
ledr_vir_l(0) <= En;
ledg_vir_l(0) <= clear;
ledg_vir_l(1) <= preset;

reset <= key_vir(0);
button <= key_vir(1);

AO : SimpleCompArch port map (clk,reset,sys_out,D_rfout_bus,D_RFwa, D_RFr1a, D_RFr2a,D_RFwe, D_RFr1e, D_RFr2e,D_RFs, D_ALUs,
										D_PCld, 
										D_jpz,
										D_mdout_bus,
										D_mdin_bus,
										D_mem_addr,
										D_Mre,
										D_Mwe,
										button,
										hex0_vir_l,
										hex1_vir_l);


 -----------   END OF USER DESIGN AREA    -------------- 
 
 
 -- Variable assignment. Assigned the temporary variables to the physical board 
 --  and the virtual GUI. DO NOT change!
 LEDG<= ledg_vir_l; ledg_vir<=ledg_vir_l; 
 LEDR<= ledr_vir_l; ledr_vir<=ledr_vir_l;
 HEX0<= hex0_vir_l; hex0_vir<= hex0_vir_l;
 HEX1<= hex1_vir_l; hex1_vir<= hex1_vir_l;
 HEX2<= hex2_vir_l; hex2_vir<= hex2_vir_l;
 HEX3<= hex3_vir_l; hex3_vir<= hex3_vir_l;
 HEX4<= hex4_vir_l; hex4_vir<= hex4_vir_l;
 HEX5<= hex5_vir_l; hex5_vir<= hex5_vir_l;
 HEX6<= hex6_vir_l; hex6_vir<= hex6_vir_l;
 HEX7<= hex7_vir_l; hex7_vir<= hex7_vir_l;
 
 
end userlogic_arch;

