library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use work.MP_lib.all;

entity feb16 is
	port(Taddress		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		Tclken		: IN STD_LOGIC  := '1';
		Tclock		: IN STD_LOGIC  := '1';
		Tdata		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		Twren		: IN STD_LOGIC ;
		Tq		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0));
		
end;

architecture mem_test of feb16 is

component ram is
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		clken		: IN STD_LOGIC  := '1';
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
end component;

begin
	Unit0: ram port map(Taddress, Tclken, Tclock, Tdata, Twren, Tq);

	
end mem_test;
