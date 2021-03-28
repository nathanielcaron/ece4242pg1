------------------------------------------------------------------
-- Simple Computer Architecture
--
-- System composed of
-- 	CPU, Memory and output buffer
--    Sinals with the prefix "D_" are set for Debugging purpose only
-- SimpleCompArch.vhd
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;  		   
use work.MP_lib.all;

entity SimpleCompArch is
port( sys_clk								:	in std_logic;
		  sys_rst							:	in std_logic;
		  sys_output						:	out std_logic_vector(15 downto 0);
		
-- Debug signals from CPU: output for simulation purpose only	
		D_rfout_bus											: out std_logic_vector(15 downto 0);  
		D_RFwa, D_RFr1a, D_RFr2a				: out std_logic_vector(3 downto 0);
		D_RFwe, D_RFr1e, D_RFr2e				: out std_logic;
		D_RFs										: out std_logic_vector(1 downto 0);
		D_ALUs									: out std_logic_vector(2 downto 0);
		D_PCld, D_jpz										: out std_logic;
		-- end debug variables	

		-- Debug signals from Memory: output for simulation purpose only	
		D_mdout_bus, D_mdin_bus				: out std_logic_vector(15 downto 0);
		D_mem_addr											: out std_logic_vector(9 downto 0); 
		D_Mre,D_Mwe										: out std_logic;
				button							: in std_logic;
		Hex0								:	out std_logic_vector(6 downto 0);
		Hex1								:	out std_logic_vector(6 downto 0)
		-- end debug variables	
);
end;

architecture rtl of SimpleCompArch is
--Memory local variables												  							        							(ORIGIN	-> DEST)
	signal mdout_bus					: std_logic_vector(15 downto 0);  -- Mem data output 		(MEM  	-> CTLU)
	signal mdin_bus					: std_logic_vector(15 downto 0);  -- Mem data bus input 	(CTRLER	-> Mem)
	signal mem_addr					: std_logic_vector(9 downto 0);   -- Const. operand addr.(CTRLER	-> MEM)
	signal Mre							: std_logic;							 -- Mem. read enable  	(CTRLER	-> Mem) 
	signal Mwe							: std_logic;							 -- Mem. write enable 	(CTRLER	-> Mem)
	signal sys_out						: std_logic_vector(15 downto 0);
	signal intermediate_output		: std_logic_vector(15 downto 0) := "1111111111111111";
	
	--System local variables
	signal oe							: std_logic;
	signal hex0_input					: std_logic_vector(3 downto 0) := "1111";
	signal hex1_input					: std_logic_vector(3 downto 0) := "1111";
	signal counter						: std_logic_vector(15 downto 0) := "0000000000000000";
	signal output_ready_signal		: std_logic;
	signal clk_out								: std_logic;
	

begin

Unit1: CPU port map (sys_clk,sys_rst,mdout_bus,mdin_bus,mem_addr,Mre,Mwe,oe,
										D_rfout_bus,D_RFwa, D_RFr1a, D_RFr2a,D_RFwe, 			 				--Degug signals
										D_RFr1e, D_RFr2e,D_RFs, D_ALUs,D_PCld, D_jpz,button);	 						--Degug signals
																					
Unit2: ram port map(mem_addr, sys_clk, mdin_bus, Mre,Mwe,mdout_bus);
Unit3: obuf port map(oe, mdout_bus, sys_out);

intermediate_output <= sys_out when oe = '1';

Unit4: seven_seg_decoder port map(intermediate_output,Hex0,Hex1);

-- Debug signals: output to upper level for simulation purpose only
	D_mdout_bus <= mdout_bus;	
	D_mdin_bus <= mdin_bus;
	D_mem_addr <= mem_addr; 
	D_Mre <= Mre;
	D_Mwe <= Mwe;
	sys_output <= sys_out;

-- end debug variables
		
end rtl;