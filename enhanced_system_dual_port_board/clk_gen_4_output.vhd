---------------------------------------------
-- A down counter to generate a low frequency
-- clock for the ECE2214 labs. The generic
-- variables n and n1 control the output frequency.
-- The clock frequency is 50000000/((n-1)*(n1-1)) Hz.
--  - The default frequency is 0.5 Hz.
-----------------------------------------------------------
--  01/11/2018 - Upgraded to work with QUARTUS II - v18.0 
--- E.C.G.-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity clk_gen_4_output is
  generic( n  : integer := 25000;
           n1 : integer := 2000);  
  port( Clock : in  std_logic;
        c_out : out std_logic_vector(3 downto 0));
end;

architecture behavior of clk_gen_4_output is
  signal count: integer := n;
  signal scale: integer := n1; 	
  signal c_val: std_logic_vector (3 downto 0) := "0000";
begin
  process begin
  wait until(rising_edge(Clock));
  if scale = 0 then
    if count = 0 then
      c_val <= c_val + 1;
      count <= n - 1;
    else
      count <= count-1;
    end if;
    scale <= n1-1;
  else
    scale <= scale - 1;
  end if;
  c_out <= c_val;
  end process;
end behavior;