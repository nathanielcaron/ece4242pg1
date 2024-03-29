--------------------------------------------------------
-- Simple Microprocessor Design
--
-- Program Counter 
-- PC.vhd
--------------------------------------------------------

library    ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;  
use work.MP_lib.all;

entity PC is
port(   clock:    	in std_logic;
        PCld:     	in std_logic;
        PCinc:    	in std_logic;
        PCclr:    	in std_logic;
        PCin:     	in std_logic_vector(15 downto 0);
        PCout:    	out std_logic_vector(15 downto 0);
		  Inst_count: 	out std_logic_vector(15 downto 0)
);
end;

architecture behv of PC is

signal tmp_PC: std_logic_vector(15 downto 0);
signal tmp_IC: std_logic_vector(15 downto 0);

begin                
    process(PCclr, PCinc, PCld, PCin, tmp_PC,clock)
    begin
        if PCclr='1' then    
           tmp_PC <= ZERO;
			  tmp_IC <= ZERO;
        elsif (rising_edge(clock)) then      
            if  (PCld = '1' and PCinc='0') then
              tmp_PC <= PCin;
				  tmp_IC <= tmp_IC + 1;
            elsif  (PCinc='1' and PCld = '0') then
               tmp_PC <= tmp_PC + 1;
					tmp_IC <= tmp_IC + 1;
            end if;
       end if;
    end process;

    PCout <= tmp_PC;
	 Inst_count <= tmp_IC;

end behv;

