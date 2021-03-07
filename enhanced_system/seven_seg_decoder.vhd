Library ieee;
use ieee.std_logic_1164.all;

entity seven_seg_decoder is
		port(
				I		:	in std_logic_vector(3 downto 0);
			  	qout	:	out std_logic_vector(6 downto 0));
end;


architecture arch of seven_seg_decoder is
	begin
		--Case Statement for 15 different possibilities (0 TO F)
		process(I)
			begin
				 case I is
				 when "0000" => qout <= "0000001"; -- '0'     
				 when "0001" => qout <= "1001111"; -- '1' 
				 when "0010" => qout <= "0010010"; -- '2' 
				 when "0011" => qout <= "0000110"; -- '3' 
				 when "0100" => qout <= "1001100"; -- '4' 
				 when "0101" => qout <= "0100100"; -- '5' 
				 when "0110" => qout <= "0100000"; -- '6' 
				 when "0111" => qout <= "0001111"; -- '7' 
				 when "1000" => qout <= "0000000"; -- '8'     
				 when "1001" => qout <= "0000100"; -- '9' 
				 when "1010" => qout <= "0000010"; -- 'a'
				 when "1011" => qout <= "1100000"; -- 'b'
				 when "1100" => qout <= "0110001"; -- 'C'
				 when "1101" => qout <= "1000010"; -- 'd'
				 when "1110" => qout <= "0110000"; -- 'E'
				 when "1111" => qout <= "0111000"; -- 'F'
				 end case;
		end process;
end;