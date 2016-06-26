library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY project3 IS
	PORT(	CLOCK_50:	IN std_logic;
		KEY: 		IN std_logic_vector(3 downto 0);
		SW:		IN std_logic_vector(7 downto 0);
		HEX0,HEX1:	OUT std_logic_vector(6 downto 0);
		HEX2,HEX3:	OUT std_logic_vector(6 downto 0);
		LEDR: 		OUT std_logic_vector(7 downto 0));			
END project3;

ARCHITECTURE structural OF project3 IS
	COMPONENT DecodeHex IS
		PORT(	BitInput: 	IN std_logic_vector(3 downto 0);
			HexOutput: 	OUT std_logic_vector(6 downto 0));
	END COMPONENT DecodeHex;
	
	COMPONENT ClockCounter IS
		GENERIC ( UpperBound: integer:=50000000);
			PORT(	Clock:	IN  std_logic;
				Enable: IN  std_logic;
				EffClk: OUT std_logic);							
	END COMPONENT ClockCounter;
	
	COMPONENT UpDownCounterHold IS
		PORT (	Clock:		IN  std_logic;
			Enable: 		IN  std_logic;
			Reset:  		IN  std_logic;
			Direction:	IN  std_logic;
			Hold:		IN std_logic;
			Load:		IN std_logic;
			Max:		IN  std_logic_vector(7 DOWNTO 0);
			Output:		OUT std_logic_vector(7 DOWNTO 0));
	END COMPONENT UpDownCounterHold;
	
	COMPONENT EightBitRegister IS
		PORT (	Clock:		IN  std_logic;
			Vector:		IN  std_logic_vector(7 DOWNTO 0);
			Load:	 	IN  std_logic;
			Output:		OUT std_logic_vector(7 DOWNTO 0));
	END COMPONENT EightBitRegister;
	
	signal CountEnable: 	std_logic;
	signal CountValue: 	std_logic_vector(7 downto 0);
	signal CountMax:	std_logic_vector(7 downto 0);
	
	
	BEGIN
		ClockCounter0 : ClockCounter port map(	Clock => CLOCK_50,
							Enable => '1',
							EffClk => CountEnable );

		Counter : UpDownCounterHold port map( 	Clock => CLOCK_50,
								Enable => CountEnable,
								Reset => KEY(1),
								Direction => KEY(0),
								Hold => KEY(2),
								Load => KEY(3),
								Max => CountMax,
								Output => CountValue);

		CounterMaximum: EightBitRegister port map(	Clock => CLOCK_50,
								Vector =>SW(7 downto 0),
								Load =>KEY(3),
								Output => CountMax);
		Hex_0: DecodeHex port map(	BitInput => CountValue(3 downto 0),
						HexOutput => HEX0);										
		Hex_1: DecodeHex port map(	BitInput => CountValue(7 downto 4),
						HexOutput => HEX1);	
									
		LEDR <= CountValue;
		HEX2 <= "1111111";
		HEX3 <= "1111111";
		
END structural;
