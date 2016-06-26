Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.std_logic_unsigned.all;

ENTITY TrafficLightIntersection IS
	PORT (CLOCK_50: IN 	std_logic;
		  KEY :	IN 	std_logic_vector(1 downto 0); 
		  SW :	IN 	std_logic_vector(0 downto 0);		  
		  HEX0 :	OUT std_logic_vector(6 DOWNTO 0);
		  HEX1 :	OUT std_logic_vector(6 DOWNTO 0);
		  HEX2 :	OUT std_logic_vector(6 DOWNTO 0);
		  HEX3 :	OUT std_logic_vector(6 DOWNTO 0);
		  LEDR :	OUT std_logic_vector(2 DOWNTO 0);
		  LEDG :	OUT std_logic_vector(2 DOWNTO 0));
END TrafficLightIntersection;

ARCHITECTURE Behavior OF TrafficLightIntersection IS

COMPONENT DecodeHex IS
	PORT (  BitInput:	IN std_logic_vector(3 DOWNTO 0);
		  HexOutput:	OUT std_logic_vector(6 DOWNTO 0));
END COMPONENT DecodeHex;

COMPONENT ClockCounter IS
	GENERIC (UpperBound: integer);
	PORT (	Clock:  IN  std_logic;
			Enable: OUT  std_logic);
END COMPONENT ClockCounter;

component TrafficControl IS 
	PORT (	EffClock:		  	IN STD_LOGIC;
			Clock :		  	IN STD_LOGIC;
			crosswalktraffic:	IN STD_LOGIC;
			lowpriortraffic:		IN STD_LOGIC;
			reset : 			IN STD_LOGIC;
			HIP :				OUT STD_LOGIC;    
			LOWP :			OUT STD_LOGIC;
			PED : 			OUT STD_LOGIC;
			HiDone :			OUT STD_LOGIC;
			LowDone :			OUT STD_LOGIC;
			PedDone :			OUT STD_LOGIC;    
			HiCount :		OUT STD_LOGIC_VECTOR (3 downto 0);
			LowCount :		OUT STD_LOGIC_VECTOR (3 downto 0);
			PedCount :		OUT STD_LOGIC_VECTOR (3 downto 0));
END component TrafficControl;

COMPONENT Edge_Detect is
Port(	Clock:		IN std_logic;
		Enable:	IN std_logic;
		Input:	IN std_logic;
		Output:	OUT std_logic);	
END COMPONENT Edge_Detect;

signal Enable1s :	STD_LOGIC;
signal Enable1ms :	STD_LOGIC;
signal PedXing :		STD_LOGIC;
signal reset : 		STD_LOGIC;
signal HiCountsig :	STD_LOGIC_VECTOR (3 downto 0);
signal LowCountsig :	STD_LOGIC_VECTOR (3 downto 0);
signal PedCountsig :	STD_LOGIC_VECTOR (3 downto 0);

begin

PedCross: Edge_Detect port map (Clock => CLOCK_50,
								Input => KEY(0),
								Enable => Enable1ms,
								Output=> PedXing);

Rst: Edge_Detect port map(		Clock => CLOCK_50,
								Input => KEY(1),
								Enable => Enable1ms,
								Output => reset);
					
OneSec: ClockCounter Generic map (	UpperBound=>49999999)
						port map( 	Clock => CLOCK_50,
									Enable => Enable1s);
								
OneMilliSec: ClockCounter Generic map(	UpperBound=>49999)
							port map(	Clock => CLOCK_50,
									Enable => Enable1ms);						

ControlIntersect: TrafficControl port map (EffClock => Enable1s,
		Clock => CLOCK_50,
		crosswalktraffic => PedXing,
 		lowpriortraffic => SW(0),
		reset => reset,
		HIP => LEDG(2),    
		LOWP => LEDG(1),
		PED => LEDG(0),
		HiDone => LEDR(2),
		LowDone => LEDR(1),
		PedDone => LEDR(0),   
		HiCount => HIcountsig,
		LowCount => LOWcountsig,
		PedCount => PEDcountsig);	
					
Pedestrian: DecodeHex port map(BitInput => PEDcountsig,
								HexOutput => HEX0);

LowPriority: DecodeHex port map(BitInput => LOWcountsig,
								HexOutput => HEX1);

HighPriority: DecodeHex port map(BitInput => HIcountsig,
								HexOutput => HEX2);
				
HEX3 <= "1111111"; --Always off--
		  
end Behavior;
