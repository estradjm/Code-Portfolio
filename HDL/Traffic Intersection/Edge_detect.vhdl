library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

Entity Edge_Detect is
Port(	Clock: IN std_logic;
		Input: IN std_logic;
		Output: OUT std_logic);	
END Edge_Detect;

Architecture structural of Edge_Detect IS
signal Q1:std_logic;
signal Q0:std_logic;

Begin
Process(Clock)
BEGIN
if (rising_edge (Clock)) then
Q0<=not Input;
Q1<=Q0;
Output <= not(Q0) and (Q1);
END IF;
end process;
end structural;
