library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;


ENTITY UpDownCounterHold IS
	PORT (		Clock:		IN  std_logic;
			Enable: 		IN  std_logic;
			Reset:  		IN  std_logic;
			Direction:	IN  std_logic;
			Hold:		IN  std_logic;
			Load:		IN std_logic;
			Max:		IN  std_logic_vector(7 DOWNTO 0);
			Output:		OUT std_logic_vector(7 DOWNTO 0)
			);
END UpDownCounterHold;

ARCHITECTURE behavior OF UpDownCounterHold IS
signal count : std_logic_vector(7 downto 0);
BEGIN
	PROCESS(Clock)
	BEGIN
	IF (Reset = '0') THEN
		count <= "00000000";	
	ELSIF (rising_edge(Clock) AND Enable = '1') THEN
		IF (Hold = '0') THEN
			count <= count;
		ELSIF (Load = '0') THEN
			count <= Max;
		ELSIF (Load = '1' AND Direction = '1') THEN
			count <= count + 1;
			IF (count+1 > Max) THEN
				count <= "00000000";
			END IF;
		ELSIF (Load = '1' AND Direction = '0') THEN
			count <= count - 1;	
			IF (count-1 > Max) THEN
					count <= Max;
			END IF;	
		ELSE
			count <= count;	
		END IF;
	END IF;
	Output <= count;
	END PROCESS;
END Behavior;