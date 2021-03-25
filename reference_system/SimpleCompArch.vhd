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
--		  hex0_input						: out std_logic_vector(3 downto 0);
--		  hex1_input						: out std_logic_vector(3 downto 0);
--		  temp_out							:	out std_logic_vector(15 downto 0);
		
		-- Debug signals from CPU: output for simulation purpose only	
--		D_rfout_bus											: out std_logic_vector(15 downto 0);  
--		D_RFwa, D_RFr1a, D_RFr2a				: out std_logic_vector(3 downto 0);
--		D_RFwe, D_RFr1e, D_RFr2e				: out std_logic;
--		D_RFs										: out std_logic_vector(1 downto 0);
--		D_ALUs									: out std_logic_vector(2 downto 0);
--		D_PCld, D_jpz										: out std_logic;
--		Hex0_in 							: out std_logic_vector (3 downto 0);
--		Hex1_in							: out std_logic_vector (3 downto 0);
		Hex0								:	out std_logic_vector(6 downto 0);
		Hex1								:	out std_logic_vector(6 downto 0);
		button							: in std_logic
--		oe_signal							: out std_logic
		-- end debug variables	

		-- Debug signals from Memory: output for simulation purpose only	
--		D_mdout_bus					: out std_logic_vector(15 downto 0)
--	D_mdin_bus	
--		D_mem_addr											: out std_logic_vector(9 downto 0); 
--		D_Mre,D_Mwe										: out std_logic
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
	signal counter						: std_logic_vector(3 downto 0) := "0000";
	signal output_ready_signal		: std_logic;
	signal clk_out								: std_logic;
	
	-- System Debug Signals
	signal D_rfout_bus				: std_logic_vector(15 downto 0);
	signal D_RFwa, D_RFr1a, D_RFr2a				: std_logic_vector(3 downto 0);
	signal D_RFwe, D_RFr1e, D_RFr2e				: std_logic;
	signal D_RFs										: std_logic_vector(1 downto 0);
	signal D_ALUs									: std_logic_vector(2 downto 0);
	signal D_PCld, D_jpz										: std_logic;
	signal D_mdout_bus				: std_logic_vector(15 downto 0); 
	signal D_mdin_bus					: std_logic_vector(15 downto 0); 
	signal D_mem_addr											: std_logic_vector(9 downto 0); 
	signal D_Mre,D_Mwe										: std_logic;

begin

Unit1: CPU port map (sys_clk,sys_rst,mdout_bus,mdin_bus,mem_addr,Mre,Mwe,oe,
										D_rfout_bus,D_RFwa, D_RFr1a, D_RFr2a,D_RFwe, 			 				--Degug signals
										D_RFr1e, D_RFr2e,D_RFs, D_ALUs,D_PCld, D_jpz,button);	 						--Degug signals
																					
Unit2: ram port map(mem_addr, sys_clk, mdin_bus, Mre,Mwe,mdout_bus);
Unit3: obuf port map(oe, mdout_bus, sys_out);
--Unit4: clk_gen_1_output  port map(sys_clk,clk_out);

--Hex0_in <= sys_out(3 downto 0) when oe = '1';
--Hex1_in <= sys_out(7 downto 4) when oe = '1';
intermediate_output <= sys_out when oe = '1';

--hex0_input <= sys_out(3 downto 0) when oe = '1';
--hex1_input <= sys_out(7 downto 4) when oe = '1';

--process(clk_out, output_ready_signal)
--begin
----	if () then
------		if (output_ready_signal = '1') then	
------			hex0_input <= sys_out(3 downto 0);
------			hex1_input <= sys_out(7 downto 4);
--------			hex0_input <= hex0_input + 1;
--------			hex1_input <= hex1_input + 1;
------		end if;
----		hex0_input <= "0001";
----		hex1_input <= "0001";
------	else
------		hex0_input <= "ZZZZ";
------		hex1_input <= "ZZZZ";
----	else 
----		hex0_input <= "0010";
----		hex1_input <= "0010";
----	end if;
--
--	if(rising_edge(clk_out)) then
--		hex0_input <= D_mdin_bus(3 downto 0);
--		hex1_input <= D_mdin_bus(7 downto 4);
--	end if;
--
--end process;
--	hex0_input <= sys_out(11 downto 8) WHEN sys_out > 0 AND sys_out < 65000 ELSE "0000";
--	hex1_input <= sys_out(15 downto 12) WHEN sys_out > 0 AND sys_out < 65000 ELSE "0000";
--		hex0_input <= sys_out(11 downto 8);			
--		hex1_input <= sys_out(15 downto 12);

Unit4: seven_seg_decoder port map(intermediate_output,Hex0,Hex1);
--Unit4: digit0 port map(intermediate_output,Hex0);

-- Debug signals: output to upper level for simulation purpose only
	D_mdout_bus <= mdout_bus;	
	D_mdin_bus <= mdin_bus;
	D_mem_addr <= mem_addr; 
	D_Mre <= Mre;
	D_Mwe <= Mwe;
	sys_output <= sys_out;
--	oe_signal <= oe;
--	Hex1 <= "1111111";
--	temp_out <= intermediate_output;
--	Hex0_in <= hex0_input;
--	Hex1_in <= hex1_input;
-- end debug variables
		
end rtl;