Library ieee;
use ieee.std_logic_1164.all;

entity seven_seg_decoder is
		port(sys_out : in std_logic_vector(15 downto 0);
			  	Hex0	:	out std_logic_vector(6 downto 0);
				Hex1	:	out std_logic_vector(6 downto 0)
			);
end;


architecture arch of seven_seg_decoder is

signal hex0_input: std_logic_vector(3 downto 0);
signal hex1_input: std_logic_vector(3 downto 0);

begin
		hex0_input <= sys_out(3 downto 0);
		hex1_input <= sys_out(7 downto 4);
		--Case Statement for 15 different possibilities (0 TO F)
		process(hex0_input)
			begin
				 case hex0_input is
				 when "0000" => Hex0 <= "1000000"; -- '0'     
				 when "0001" => Hex0 <= "1111001"; -- '1' 
				 when "0010" => Hex0 <= "0100100"; -- '2' 
				 when "0011" => Hex0 <= "0110000"; -- '3' 
				 when "0100" => Hex0 <= "0011001"; -- '4' 
				 when "0101" => Hex0 <= "0010010"; -- '5' 
				 when "0110" => Hex0 <= "0000010"; -- '6' 
				 when "0111" => Hex0 <= "1111000"; -- '7' 
				 when "1000" => Hex0 <= "0000000"; -- '8'     
				 when "1001" => Hex0 <= "0010000"; -- '9'
				 when others => Hex0 <= "1111111";
				 end case;
		end process;
		
		process(hex1_input)
			begin
				 case hex1_input is
				 when "0000" => Hex1 <= "1000000"; -- '0'     
				 when "0001" => Hex1 <= "1111001"; -- '1' 
				 when "0010" => Hex1 <= "0100100"; -- '2' 
				 when "0011" => Hex1 <= "0110000"; -- '3' 
				 when "0100" => Hex1 <= "0011001"; -- '4' 
				 when "0101" => Hex1 <= "0010010"; -- '5' 
				 when "0110" => Hex1 <= "0000010"; -- '6' 
				 when "0111" => Hex1 <= "1111000"; -- '7' 
				 when "1000" => Hex1 <= "0000000"; -- '8'     
				 when "1001" => Hex1 <= "0010000"; -- '9'
				 when others => Hex1 <= "1111111";
				 end case;
		end process;
end;