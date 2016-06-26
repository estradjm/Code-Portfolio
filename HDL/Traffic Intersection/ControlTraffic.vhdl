Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.std_logic_unsigned.all;
Use ieee.std_logic_arith.all;

Entity TrafficControl is 
	PORT (EffClock: IN STD_LOGIC;
		Clock : IN STD_LOGIC;
		crosswalktraffic : IN STD_LOGIC;
		lowpriortraffic : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		HIP : OUT STD_LOGIC;    
		LOWP : OUT STD_LOGIC;
		PED : OUT STD_LOGIC;
		HiDone : OUT STD_LOGIC;
		LowDone : OUT STD_LOGIC;
		PedDone : OUT STD_LOGIC;    
		HiCount : OUT STD_LOGIC_VECTOR (3 downto 0);
		LowCount : OUT STD_LOGIC_VECTOR (3 downto 0);
		PedCount : OUT STD_LOGIC_VECTOR (3 downto 0));
		
end TrafficControl;

architecture Behavioral of TrafficControl is

	type State is (HighPriority, LowPriority, Pedestrian, COUNTDOWN5Ped, COUNTDOWN5Low, L2Ped);
	signal CurrentState , NextState : State;
	signal countdown9 : std_logic_vector (3 downto 0); 
	signal countdown4 : std_logic_vector (3 downto 0); 
	signal countdown5 : std_logic_vector (3 downto 0); 
    signal resetsig : std_logic;
    signal HiEnable : std_logic;
	signal LowEnable : std_logic;
	signal PedEnable : std_logic;
	signal register5  : std_logic;
	signal register9  : std_logic;
	signal register4  : std_logic;
	signal trip5 : std_logic;
	signal trip9 : std_logic;
	signal trip4 : std_logic;
	signal Go2Ped : std_logic;

begin 
	HiCount <= countdown5;
	LowCount <= countdown9;
	PedCount <= countdown4;
	resetsig <= reset;
	
Works : process (Go2Ped, reset, CurrentState, countdown4, countdown5, countdown9, NextState, crosswalktraffic, lowpriortraffic, Clock)
begin
		case CurrentState is
			when HighPriority => 
				NextState <= CurrentState;
				HIP <= '1';    
				LOWP <= '0';
				PED  <= '0';
				HiDone <= '0';
				LowDone <= '1';
				PedDone <= '1';     
				HIenable <= '0';
				LowEnable <= '0';
				PedEnable <= '0';
				trip5 <= '1';
				trip4 <= '1';
				trip9 <= '1';
				Go2Ped <= '0';
				if crosswalktraffic = '1'  then 
					NextState <= COUNTDOWN5Ped;		
				elsif lowpriortraffic = '1' then 
					NextState <= COUNTDOWN5Low;
				elsif reset = '1' then
					NextState <= HighPriority;
					trip4 <='1';
					trip5 <='1';
					trip9 <='1';
				end if;   
				
			when Pedestrian =>
				NextState <= CurrentState;
				HIP <= '0';    
				LOWP <= '0';
				PED  <= '1';
				HiDone <= '1';
				LowDone <= '1';
				PedDone <= '0';     
				HIenable <= '0';
				LowEnable <= '0';
				PedEnable <= '1';   
				trip4 <= '0';
				Go2Ped <= '0';
				if countdown4 = 0 and lowpriortraffic = '1' then
					NextState <= LowPriority;
					trip4 <= '1';
				elsif countdown4 = 0 and lowpriortraffic = '0' then
					NextState <= HighPriority;
					trip4 <= '1';
				elsif reset = '1' then
					NextState <= HighPriority;
					trip4 <='1';
					trip5 <='1';
					trip9 <='1';
				end if;  
				
			when LowPriority =>
				NextState <= CurrentState;
				HIP <= '0';    
				LOWP <= '1';
				PED  <= '0';
				HiDone <= '1';
				LowDone <= '0';
				PEDdone <= '1';       
				HiEnable <= '0';
				LowEnable <= '1';
				PedEnable <= '0';
				trip9 <= '0';
				if countdown9 = 0 and Go2Ped = '0' then
					NextState <= HighPriority;
					trip4 <='1';
					trip5 <='1';
					trip9 <='1';
				elsif countdown9 = 0 and Go2Ped = '1' then
					NextState <= L2Ped;
					trip4 <='1';
					trip5 <='1';
					trip9 <='1';
				elsif crosswalktraffic = '1' then
					Go2Ped <= '1';
				elsif reset = '1' then
					NextState <= HighPriority;
					trip4 <='1';
					trip5 <='1';
					trip9 <='1';
				end if;          
				
			when COUNTDOWN5Ped =>
				NextState <= CurrentState;
				HIP <= '1';    
				LOWP <= '0';
				PED  <= '0';
				HiDone <= '0';
				LowDone <= '1';
				PedDone <= '1';       
				HiEnable <= '1';
				LowEnable <= '0';
				PedEnable <= '0';
				trip5 <= '0';
				Go2Ped <= '0';
				if countdown5 = 0 then
					NextState <= pedestrian;
					trip5 <= '1';
				elsif reset = '1' then
					NextState <= HighPriority;
					trip4 <='1';
					trip5 <='1';
					trip9 <='1';
				end if;
				
			when COUNTDOWN5low =>
				NextState <= CurrentState;
				HIP <= '1';    
				LOWP <= '0';
				PED  <= '0';
				HiDone <= '0';
				LowDone <= '1';
				PedDone <= '1';     
				HiEnable <= '1';
				LowEnable <= '0';
				PedEnable <= '0';
				trip5 <= '0';
				Go2Ped <= '0';
				if countdown5 = 0 then
					NextState <= LowPriority;
					trip5 <='1';
				elsif crosswalktraffic = '1' then
					NextState <= COUNTDOWN5Ped;
				elsif reset = '1' then
					NextState <= HighPriority;
					trip4 <='1';
					trip5 <='1';
					trip9 <='1';
				end if;
				
			when L2Ped =>
				NextState <= CurrentState;
				HIP <= '1';    
				LOWP <= '0';
				PED  <= '0';
				HiDone <= '0';
				LowDone <= '1';
				PedDone <= '1';     
				HiEnable <= '1';
				LowEnable <= '0';
				PedEnable <= '0';
				trip5<='0';
				if countdown5 = 0 then
					NextState <= Pedestrian;
					trip5 <= '1';
				elsif reset = '1' then
					NextState <= HighPriority;
					trip4 <='1';
					trip5 <='1';
					trip9 <='1';
				end if;
		end case;
end process; 

CountDOWN5Down : process (EffClock, HiEnable, resetsig, countdown5, trip5)
begin         
	if register5 = '1' or resetsig = '1' then
		countdown5 <= "0101"; 
	elsif (RISING_EDGE (EffClock)) and HiEnable = '1' THEN
			if countdown5 = 0 then
				countdown5 <= "0101";
			else
				countdown5 <= countdown5 - 1; 
			end if;
	end if;
end process;        

count9Down : process (EffClock, LowEnable, resetsig, countdown9, trip9)
begin         
	if register9 = '1' or resetsig = '1' then
		countdown9 <= "1001";
		elsif (Rising_Edge(EffClock)) and LowEnable = '1' THEN
			if countdown9 = 0 then
				countdown9 <= "1001";
			else
				countdown9 <= countdown9 - 1; 
			end if;
	end if;
end process;
                
count4Down : process (EffClock, PedEnable, resetsig, countdown4, trip4)
begin 
	if register4 = '1' or resetsig = '1' then
		countdown4 <= "0100";
		elsif (rising_edge (EffClock)) and PedEnable = '1' THEN
			if countdown4 = 0 then
				countdown4 <= "0100";
			else
				countdown4 <= countdown4 - 1; 
			end if;
	end if;
end process;

PROCESS(Clock)
begin
	IF Rising_Edge(Clock) THEN
		CurrentState <= NextState;
		register5 <= trip5;
		register4 <= trip4;
		register9 <= trip9;
	END IF;
END PROCESS;

end Behavioral;