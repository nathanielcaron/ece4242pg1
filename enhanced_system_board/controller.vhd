----------------------------------------------------------------------------
-- Simple Microprocessor Design (ESD Book Chapter 3)
-- Copyright 2001 Weijun Zhang
--
-- Controller (control logic plus state register)
-- VHDL FSM modeling
-- controller.vhd
----------------------------------------------------------------------------

library	ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.MP_lib.all;

entity controller is
port(	clock:		in std_logic;
	rst:		in std_logic;
	IR_word:	in std_logic_vector(15 downto 0);
	cache_ready:  in std_logic;
	RFs_ctrl:	out std_logic_vector(1 downto 0);
	RFwa_ctrl:	out std_logic_vector(3 downto 0);
	RFr1a_ctrl:	out std_logic_vector(3 downto 0);
	RFr2a_ctrl:	out std_logic_vector(3 downto 0);
	RFwe_ctrl:	out std_logic;
	RFr1e_ctrl:	out std_logic;
	RFr2e_ctrl:	out std_logic;						 
	ALUs_ctrl:	out std_logic_vector(2 downto 0);	 
	jmpen_ctrl:	out std_logic;
	PCinc_ctrl:	out std_logic;
	PCclr_ctrl:	out std_logic;
	IRld_ctrl:	out std_logic;
	Ms_ctrl:	out std_logic_vector(1 downto 0);
	Mre_ctrl:	out std_logic;
	Mwe_ctrl:	out std_logic;
	oe_ctrl:	out std_logic;
	ctrl_state : out std_logic_vector(7 downto 0);
	button:	in std_logic
	
);
end;

architecture fsm of controller is

  type state_type is (S0,S1,S1a,S1b,S2,S3,S3a,S3b,S4,S4a,S4b,S5,S5a,S5b,
			S6,S6a,S7,S7a,S7b,S8,S8a,S8b,S9,S9a,S9b,S10,S11,S11a,s12,s12a,s12b,
			s13,s13a,s13b,s14,s14a,s14b,s15,s15a,s15b,s15c,s15d, S16, S16a, cache_delay);
  signal state: state_type;
  signal next_state: state_type;
  
begin

  process(clock, rst, IR_word)
    variable OPCODE: std_logic_vector(3 downto 0);
	 begin

    if rst='1' then			   
		Ms_ctrl <= "10";
		PCclr_ctrl <= '1';		  				-- Reset State
		PCinc_ctrl <= '0';
		IRld_ctrl <= '0';
		RFs_ctrl <= "00";		
		Rfwe_ctrl <= '0';
		Mre_ctrl <= '0';
		Mwe_ctrl <= '0';					
		jmpen_ctrl <= '0';		
		oe_ctrl <= '0';
		state <= S0;
    elsif (clock'event and clock='1') then
	 
		case state is
			when S0 =>
				ctrl_state <= x"00";
			when S1 =>
				ctrl_state <= x"10";
			when S1a =>
				ctrl_state <= x"11";
			when S1b =>
				ctrl_state <= x"12";
			when S2 =>
				ctrl_state <= x"20";
			when S3 =>
				ctrl_state <= x"30";
			when S3a =>
				ctrl_state <= x"31";
			when S3b =>
				ctrl_state <= x"32";
			when S4 =>
				ctrl_state <= x"40";
			when S4a =>
				ctrl_state <= x"41";
			when S4b =>
				ctrl_state <= x"42";
			when S5 =>
				ctrl_state <= x"50";
			when S5a =>
				ctrl_state <= x"51";
			when S5b =>
				ctrl_state <= x"52";
			when S6 =>
				ctrl_state <= x"60";
			when S6a =>
				ctrl_state <= x"61";
			when S7 =>
				ctrl_state <= x"70";
			when S7a =>
				ctrl_state <= x"71";
			when S7b =>
				ctrl_state <= x"72";
			when S8 =>
				ctrl_state <= x"80";
			when S8a =>
				ctrl_state <= x"81";
			when S8b =>
				ctrl_state <= x"82";
			when S9 =>
				ctrl_state <= x"90";
			when S9a =>
				ctrl_state <= x"91";
			when S9b =>
				ctrl_state <= x"92";
			when S10 =>
				ctrl_state <= x"A0";
			when S11 =>
				ctrl_state <= x"B0";
			when S11a =>
				ctrl_state <= x"B1";
			when S12 =>
				 ctrl_state <= x"C0";
			when S12a =>
				 ctrl_state <= x"C1";
			when S12b =>
				 ctrl_state <= x"C2";
			when S13 =>
				 ctrl_state <= x"D0";
			when S13a =>
				 ctrl_state <= x"D1";
			when S13b =>
				 ctrl_state <= x"D2";
			when S14 =>
				 ctrl_state <= x"E0";
			when S14a =>
				 ctrl_state <= x"E1";
			when S14b =>
				 ctrl_state <= x"E2";
			when S15 =>
				 ctrl_state <= x"F0";
			when S15a =>
				 ctrl_state <= x"F1";
			when S15b =>
				 ctrl_state <= x"F2";
			when S15c =>
				 ctrl_state <= x"F3";
			when S15d =>
				 ctrl_state <= x"F4";
			when cache_delay =>
				ctrl_state <= x"CD";
			when others =>
				ctrl_state <= x"FF";
		end case;
		
		case state is 

		when S0 =>
			PCclr_ctrl <= '0';						-- Reset State	
			state <= S1;	

		when S1 =>
			PCinc_ctrl <= '0';
			IRld_ctrl <= '1'; 						-- Fetch Instruction
			Mre_ctrl <= '1';  
			RFwe_ctrl <= '0'; 
			RFr1e_ctrl <= '0'; 
			RFr2e_ctrl <= '0'; 
			Ms_ctrl <= "10";
			Mwe_ctrl <= '0';
			jmpen_ctrl <= '0';
			oe_ctrl <= '0';
			state <= cache_delay;
			next_state <= S1a;

		when S1a =>
			state <= S1b;								--One memory access delay	--remove?

		when S1b =>
			if cache_ready = '1' then
				Mre_ctrl <= '0';
				IRld_ctrl <= '0';
				PCinc_ctrl <= '1';
				state <= S2;							-- Fetch end ...
			end if;

		when S2 =>
			PCinc_ctrl <= '0';
			OPCODE := IR_word(15 downto 12);
			case OPCODE is
				 when mov1 => 	state <= S3;
				 when mov2 => 	state <= S4;
				 when mov3 => 	state <= S5;
				 when mov4 => 	state <= S6;
				 when add =>  	state <= S7;
				 when subt =>	state <= S8;
				 when jz =>		state <= S9;
				 when halt =>	state <= S10; 
				 when readm => 	state <= S11;
				 when mult =>	state <= s12;
				 when div =>	state <= s13;
				 when greater =>	state <= s14;
				 when mov5 => state <= s15;
				 when mov4_12 =>	state <= S16;
				 when others => 	state <= S1;
				 end case;

		when S3 =>
			RFwa_ctrl <= IR_word(11 downto 8);
			RFs_ctrl <= "01";  						-- RF[rn] <= mem[direct]
			Ms_ctrl <= "01";
			Mre_ctrl <= '1';
			Mwe_ctrl <= '0';
			state <= cache_delay;
			next_state <= S3a;

		when S3a =>
			if cache_ready = '1' then
				RFwe_ctrl <= '1'; 
				Mre_ctrl <= '0'; 
				state <= S3b;
			end if;

		when S3b =>
			RFwe_ctrl <= '0';
			state <= S1;

		when S4 =>
			RFr1a_ctrl <= IR_word(11 downto 8);
			RFr1e_ctrl <= '1'; 						-- mem[direct] <= RF[rn]			
			Ms_ctrl <= "01";
			ALUs_ctrl <= "000";	  
			IRld_ctrl <= '0';
			state <= S4a;								-- read value from RF

		when S4a =>
			Mre_ctrl <= '0';
			Mwe_ctrl <= '1';							-- write into memory
			state <= cache_delay;
			next_state <= S4b;

		when S4b =>
			if cache_ready = '1' then
				Ms_ctrl <= "10";				  
				Mwe_ctrl <= '0';
				state <= S1;
			end if;

		when S5 =>
			RFr1a_ctrl <= IR_word(11 downto 8);	
			RFr1e_ctrl <= '1'; 						-- mem[RF[rn]] <= RF[rm]
			Ms_ctrl <= "00";
			ALUs_ctrl <= "001";
			RFr2a_ctrl <= IR_word(7 downto 4); 
			RFr2e_ctrl <= '1'; 						-- set addr.& data
			state <= S5a;

		when S5a =>
			Mre_ctrl <= '0';
			Mwe_ctrl <= '1'; 							-- write into memory
			state <= cache_delay;
			next_state <= S5b;

		when S5b =>
			if cache_ready = '1' then
				Ms_ctrl <= "10";						-- return
				Mwe_ctrl <= '0';
				state <= S1;
			end if;

		when S6 =>	RFwa_ctrl <= IR_word(11 downto 8);	
			RFwe_ctrl <= '1'; 						-- RF[rn] <= imm.
			RFs_ctrl <= "10";
			IRld_ctrl <= '0';
			state <= S6a;

		when S6a =>
			state <= S1;

		when S7 =>
			RFr1a_ctrl <= IR_word(11 downto 8);	
			RFr1e_ctrl <= '1'; 						-- RF[rn] <= RF[rn] + RF[rm]
			RFr2e_ctrl <= '1'; 
			RFr2a_ctrl <= IR_word(7 downto 4);
			ALUs_ctrl <= "010";
			state <= S7a;

		when S7a =>
			RFr1e_ctrl <= '0';
			RFr2e_ctrl <= '0';
			RFs_ctrl <= "00";
			RFwa_ctrl <= IR_word(11 downto 8);
			RFwe_ctrl <= '1';
			state <= S7b;

		when S7b =>
			state <= S1;
						
		when S8 =>
			RFr1a_ctrl <= IR_word(11 downto 8);	
			RFr1e_ctrl <= '1'; 						-- RF[rn] <= RF[rn] - RF[rm]
			RFr2a_ctrl <= IR_word(7 downto 4);
			RFr2e_ctrl <= '1';  
			ALUs_ctrl <= "011";
			state <= S8a;

		when S8a =>
			RFr1e_ctrl <= '0';
			RFr2e_ctrl <= '0';
			RFs_ctrl <= "00";
			RFwa_ctrl <= IR_word(11 downto 8);
			RFwe_ctrl <= '1';
			state <= S8b;

		when S8b =>
			state <= S1;

		when S9 =>
			jmpen_ctrl <= '1';
			RFr1a_ctrl <= IR_word(11 downto 8);	
			RFr1e_ctrl <= '1'; 						-- jz if R[rn] = 0
			ALUs_ctrl <= "000";
			state <= S9a;

		when S9a =>
			state <= S9b;

		when S9b =>
			jmpen_ctrl <= '0';
			state <= S1;

		when S10 =>
			state <= S10; 								-- halt

		when S11 =>   Ms_ctrl <= "01";
			Mre_ctrl <= '1'; 							-- read memory
			Mwe_ctrl <= '0';
			state <= cache_delay;
			next_state <= S11a;

		when S11a =>
			if cache_ready = '1' then
				oe_ctrl <= '1'; 
				Mre_ctrl <= '0';
				if (button = '0') then
					state <= S1;
				end if;
			end if;

		when S12 =>
			RFr1a_ctrl <= IR_word(11 downto 8);	
			RFr1e_ctrl <= '1'; 						-- RF[rn] <= RF[rn] * RF[rm]
			RFr2e_ctrl <= '1'; 
			RFr2a_ctrl <= IR_word(7 downto 4);
			ALUs_ctrl <= "100";
			state <= S12a;

		when S12a =>
			RFr1e_ctrl <= '0';
			RFr2e_ctrl <= '0';
			RFs_ctrl <= "00";
			RFwa_ctrl <= IR_word(11 downto 8);
			RFwe_ctrl <= '1';
			state <= S12b;

		when S12b =>
			state <= S1;
		  
		when S13 =>
			RFr1a_ctrl <= IR_word(11 downto 8);	
			RFr1e_ctrl <= '1'; 						-- RF[rn] <= RF[rn] / RF[rm]
			RFr2e_ctrl <= '1'; 
			RFr2a_ctrl <= IR_word(7 downto 4);
			ALUs_ctrl <= "101";
			state <= S13a;

		when S13a =>   RFr1e_ctrl <= '0';
			RFr2e_ctrl <= '0';
			RFs_ctrl <= "00";
			RFwa_ctrl <= IR_word(11 downto 8);
			RFwe_ctrl <= '1';
			state <= S13b;

		when S13b =>
			state <= S1;
		  
		when S14 =>
			RFr1a_ctrl <= IR_word(11 downto 8);	
			RFr1e_ctrl <= '1'; 						-- RF[rn] <= greater RF[rn],RF[rm]
			RFr2e_ctrl <= '1'; 
			RFr2a_ctrl <= IR_word(7 downto 4);
			ALUs_ctrl <= "110";
			state <= S14a;

		when S14a =>
			RFr1e_ctrl <= '0';
			RFr2e_ctrl <= '0';
			RFs_ctrl <= "00";
			RFwa_ctrl <= IR_word(11 downto 8);
			RFwe_ctrl <= '1';
			state <= S14b;

		when S14b =>
			state <= S1;

		when s15 =>
			RFr1a_ctrl <= IR_word(7 downto 4); 	-- address stored in R2
			RFr1e_ctrl <= '1'; 						-- enable port for reading
			Ms_ctrl <= "00";
			ALUs_ctrl <= "001";
			state <= s15a;

		when s15a =>
			Mre_ctrl <= '1';
			Mwe_ctrl <= '0';
			state <= cache_delay;
			next_state <= S15b;

		when s15b =>
			if cache_ready = '1' then
				RFwa_ctrl <= IR_word(11 downto 8); -- write the address of register to write to read value form mem[R2] to R1
				RFs_ctrl <= "01";
				Ms_ctrl <= "00";
				state <= s15c;
			end if;

		when s15c =>
			RFwe_ctrl <= '1';
			Mre_ctrl <= '0';
			state <= s15d;

		when s15d =>
			RFwe_ctrl <= '0';
			RFr1e_ctrl <= '0';
			state <= s1;

		when S16 =>	
			RFwa_ctrl <= "1110"; -- R14
			RFwe_ctrl <= '1'; -- RF[rn] <= imm.
			RFs_ctrl <= "10";
			IRld_ctrl <= '0';
			state <= S16a;
		when S16a =>   
			RFwe_ctrl <= '0';
			state <= S1;

		when cache_delay =>
			state <= next_state;

		when others =>
		 end case;

    end if;

  end process;

end fsm;
