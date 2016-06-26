library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY ClockCounter IS
	GENERIC (UpperBound: integer);
	PORT (	Clock:	IN  std_logic;
			Enable:	OUT  std_logic);
END ClockCounter;

ARCHITECTURE behavior OF ClockCounter IS
	signal count : integer range 0 to(UpperBound-1);
	BEGIN
	PROCESS (Clock)
		BEGIN
		IF (rising_edge(Clock)) then
			IF(count = (UpperBound-1)) then
				count <= 0;
				Enable <= '1';
			else
				count <= count+1;
				Enable <= '0';
			end if;
		end if;
	END PROCESS;
END behavior;
