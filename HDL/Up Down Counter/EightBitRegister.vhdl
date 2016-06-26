library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


ENTITY EightBitRegister IS
	PORT (		Clock:		IN  std_logic;
			Vector:		IN  std_logic_vector(7 DOWNTO 0);
			Load:	 	IN  std_logic;
			Output:		OUT std_logic_vector(7 DOWNTO 0)
			);
END EightBitRegister;

ARCHITECTURE behavior OF EightBitRegister IS
signal vector_value : std_logic_vector(7 downto 0);
BEGIN
	PROCESS(Clock)
	BEGIN
		IF (rising_edge(Clock) AND Load = '0') THEN
			vector_value <= Vector;
		ELSE
			vector_value <= vector_value;
		END IF;
		Output <= vector_value;
	END PROCESS;
END behavior;