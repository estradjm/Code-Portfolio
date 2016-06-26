fs=8000;
Ts=1/8000;
t_sixteenth=0.000125:Ts:.1;
t_eighth=0.000125:Ts:.2;
t_quarter=0.000125:Ts:.4;
t_half=0.000125:Ts:.8;
t_whole=0.000125:Ts:1.6;

sixteenth_rest=zeros(1,length(t_sixteenth));
eighth_rest=zeros(1,length(t_eighth));
quarter_rest=zeros(1,length(t_quarter));
half_rest=zeros(1,length(t_half));

f_G=220*2^(-26/12);
f_A=220*2^(-24/12);
f_B=220*2^(-22/12);
f_C=220*2^(-21/12);
f_D=220*2^(-19/12);
f_E=220*2^(-17/12);
f_F=220*2^(-16/12);
f_G2=220*2^(-14/12);
f_G2S=220*2^(-13/12);
f_A2=220*2^(-12/12);
f_B2=220*2^(-10/12);
f_C2=220*2^(-9/12);
f_D2=220*2^(-7/12);
f_E2=220*2^(-5/12);
f_F2=220*2^(-4/12);
f_G3=220*2^(-2/12);
f_A3=220;
f_B3=220*2^(2/12);
f_C3=220*2^(3/12);
f_D3=220*2^(5/12);
f_E3=220*2^(7/12);
f_F3=220*2^(8/12);
f_G4=220*2^(10/12);

G_eighth=cos(2*pi*f_G*t_eighth);
Gh_eighth=cos(4*pi*f_G*t_eighth);
G_quarter=cos(2*pi*f_G*t_quarter);
Gh_quarter=cos(4*pi*f_G*t_quarter);
G_half=cos(2*pi*f_G*t_half);
Gh_half=cos(4*pi*f_G*t_half);

A_eighth=cos(2*pi*f_A*t_eighth);
Ah_eighth=cos(4*pi*f_A*t_eighth);
A_quarter=cos(2*pi*f_A*t_quarter);
Ah_quarter=cos(4*pi*f_A*t_quarter);

B_eighth=cos(2*pi*f_B*t_eighth);
Bh_eighth=cos(4*pi*f_B*t_eighth);
B_quarter=cos(2*pi*f_B*t_quarter);
Bh_quarter=cos(4*pi*f_B*t_quarter);

C_eighth=cos(2*pi*f_C*t_eighth);
Ch_eighth=cos(4*pi*f_C*t_eighth);
C_quarter=cos(2*pi*f_C*t_quarter);
Ch_quarter=cos(4*pi*f_C*t_quarter);
C_half=cos(2*pi*f_C*t_half);
Ch_half=cos(4*pi*f_C*t_half);

D_sixteenth=cos(2*pi*f_D*t_sixteenth);
Dh_sixteenth=cos(4*pi*f_D*t_sixteenth);
D_eighth=cos(2*pi*f_D*t_eighth);
Dh_eighth=cos(4*pi*f_D*t_eighth);
D_quarter=cos(2*pi*f_D*t_quarter);
Dh_quarter=cos(4*pi*f_D*t_quarter);

E_eighth=cos(2*pi*f_E*t_eighth);
Eh_eighth=cos(4*pi*f_E*t_eighth);
E_quarter=cos(2*pi*f_E*t_quarter);
Eh_quarter=cos(4*pi*f_E*t_quarter);
E_half=cos(2*pi*f_E*t_half);
Eh_half=cos(4*pi*f_E*t_half);

F_eighth=cos(2*pi*f_F*t_eighth);
Fh_eighth=cos(4*pi*f_F*t_eighth);
F_quarter=cos(2*pi*f_F*t_quarter);
Fh_quarter=cos(4*pi*f_F*t_quarter);
F_half=cos(2*pi*f_F*t_half);
Fh_half=cos(4*pi*f_F*t_half);

G2_eighth=cos(2*pi*f_G2*t_eighth);
G2h_eighth=cos(4*pi*f_G2*t_eighth);
G2_quarter=cos(2*pi*f_G2*t_quarter);
G2h_quarter=cos(4*pi*f_G2*t_quarter);
G2_half=cos(2*pi*f_G2*t_half);
G2h_half=cos(4*pi*f_G2*t_half);

G2S_eighth=cos(2*pi*f_G2S*t_eighth);
G2hS_eighth=cos(4*pi*f_G2S*t_eighth);

A2_eighth=cos(2*pi*f_A2*t_eighth);
A2h_eighth=cos(4*pi*f_A2*t_eighth);
A2_quarter=cos(2*pi*f_A2*t_quarter);
A2h_quarter=cos(4*pi*f_A2*t_quarter);

B2_eighth=cos(2*pi*f_B2*t_eighth);
B2h_eighth=cos(4*pi*f_B2*t_eighth);
B2_quarter=cos(2*pi*f_B2*t_quarter);
B2h_quarter=cos(4*pi*f_B2*t_quarter);
B2_half=cos(2*pi*f_B2*t_half);
B2h_half=cos(4*pi*f_B2*t_half);

C2_eighth=cos(2*pi*f_C2*t_eighth);
C2h_eighth=cos(4*pi*f_C2*t_eighth);
C2_quarter=cos(2*pi*f_C2*t_quarter);
C2h_quarter=cos(4*pi*f_C2*t_quarter);
C2_half=cos(2*pi*f_C2*t_half);
C2h_half=cos(4*pi*f_C2*t_half);

D2_sixteenth=cos(2*pi*f_D2*t_sixteenth);
D2h_sixteenth=cos(4*pi*f_D2*t_sixteenth);
D2_eighth=cos(2*pi*f_D2*t_eighth);
D2h_eighth=cos(4*pi*f_D2*t_eighth);
D2_quarter=cos(2*pi*f_D2*t_quarter);
D2h_quarter=cos(4*pi*f_D2*t_quarter);
D2_half=cos(2*pi*f_D2*t_half);
D2h_half=cos(4*pi*f_D2*t_half);

E2_sixteenth=cos(2*pi*f_E2*t_sixteenth);
E2h_sixteenth=cos(4*pi*f_E2*t_sixteenth);
E2_eighth=cos(2*pi*f_E2*t_eighth);
E2h_eighth=cos(4*pi*f_E2*t_eighth);
E2_quarter=cos(2*pi*f_E2*t_quarter);
E2h_quarter=cos(4*pi*f_E2*t_quarter);
E2_half=cos(2*pi*f_E2*t_half);
E2h_half=cos(4*pi*f_E2*t_half);
E2_whole=cos(2*pi*f_E2*t_whole);
E2h_whole=cos(4*pi*f_E2*t_whole);

F2_eighth=cos(2*pi*f_F2*t_eighth);
F2h_eighth=cos(4*pi*f_F2*t_eighth);
F2_quarter=cos(2*pi*f_F2*t_quarter);
F2h_quarter=cos(4*pi*f_F2*t_quarter);

G3_eighth=cos(2*pi*f_G3*t_eighth);
G3h_eighth=cos(4*pi*f_G3*t_eighth);
G3_quarter=cos(2*pi*f_G3*t_quarter);
G3h_quarter=cos(4*pi*f_G3*t_quarter);
G3_half=cos(2*pi*f_G3*t_half);
G3h_half=cos(4*pi*f_G3*t_half);

A3_eighth=cos(2*pi*f_A3*t_eighth);
A3h_eighth=cos(4*pi*f_A3*t_eighth);
A3_quarter=cos(2*pi*f_A3*t_quarter);
A3h_quarter=cos(4*pi*f_A3*t_quarter);

B3_eighth=cos(2*pi*f_B3*t_eighth);
B3h_eighth=cos(4*pi*f_B3*t_eighth);
B3_quarter=cos(2*pi*f_B3*t_quarter);
B3h_quarter=cos(4*pi*f_B3*t_quarter);
B3_half=cos(2*pi*f_B3*t_half);
B3h_half=cos(4*pi*f_B3*t_half);

C3_eighth=cos(2*pi*f_C3*t_eighth);
C3h_eighth=cos(4*pi*f_C3*t_eighth);
C3_quarter=cos(2*pi*f_C3*t_quarter);
C3h_quarter=cos(4*pi*f_C3*t_quarter);
C3_half=cos(2*pi*f_C3*t_half);
C3h_half=cos(4*pi*f_C3*t_half);

D3_sixteenth=cos(2*pi*f_D3*t_sixteenth);
D3h_sixteenth=cos(4*pi*f_D3*t_sixteenth);
D3_eighth=cos(2*pi*f_D3*t_eighth);
D3h_eighth=cos(4*pi*f_D3*t_eighth);
D3_quarter=cos(2*pi*f_D3*t_quarter);
D3h_quarter=cos(4*pi*f_D3*t_quarter);
D3_half=cos(2*pi*f_D3*t_half);
D3h_half=cos(4*pi*f_D3*t_half);

E3_sixteenth=cos(2*pi*f_E3*t_sixteenth);
E3h_sixteenth=cos(4*pi*f_E3*t_sixteenth);
E3_eighth=cos(2*pi*f_E3*t_eighth);
E3h_eighth=cos(4*pi*f_E3*t_eighth);
E3_quarter=cos(2*pi*f_E3*t_quarter);
E3h_quarter=cos(4*pi*f_E3*t_quarter);
E3_half=cos(2*pi*f_E3*t_half);
E3h_half=cos(4*pi*f_E3*t_half);
E3_whole=cos(2*pi*f_E3*t_whole);
E3h_whole=cos(4*pi*f_E3*t_whole);

F3_eighth=cos(2*pi*f_F3*t_eighth);
F3h_eighth=cos(4*pi*f_F3*t_eighth);
F3_quarter=cos(2*pi*f_F3*t_quarter);
F3h_quarter=cos(4*pi*f_F3*t_quarter);

G4_eighth=cos(2*pi*f_G4*t_eighth);
G4h_eighth=cos(4*pi*f_G4*t_eighth);
G4_quarter=cos(2*pi*f_G4*t_quarter);
G4h_quarter=cos(4*pi*f_G4*t_quarter);
G4_half=cos(2*pi*f_G4*t_half);
G4h_half=cos(4*pi*f_G4*t_half);

% ADSR ENVELOPE
	% attack 	= 2/10 of note length
	% decay 	= 1/10 of note length
	% sustain 	= 6/10 of note length
	% release 	= 1/10 of note length

attack = (length(t_whole))*(2/10);
attack1 = (length(t_half))*(2/10);
attack2 = (length(t_quarter))*(2/10);
attack3 = (length(t_eighth))*(2/10);
attack4 = (length(t_sixteenth))*(2/10);

decay = .5*attack;
decay1 = .5*attack1;
decay2 = .5*attack2;
decay3 = .5*attack3;
decay4 = .5*attack4;

sustain = 3*attack;
sustain1 = 3*attack1;
sustain2 = 3*attack2;
sustain3 = 3*attack3;
sustain4 = 3*attack4;

release = .5*attack;
release1 = .5*attack1;
release2 = .5*attack2;
release3 = .5*attack3;
release4 = .5*attack4;

ADSR_whole = [linspace(0,1,attack) linspace(1,.7,decay) linspace(.7,.7,sustain) linspace(.7,0,release)];
ADSR_half = [linspace(0,1,attack1) linspace(1,.7,decay1) linspace(.7,.7,sustain1) linspace(.7,0,release1)];
ADSR_quarter = [linspace(0,1,attack2) linspace(1,.7,decay2) linspace(.7,.7,sustain2) linspace(.7,0,release2)];
ADSR_eighth = [linspace(0,1,attack3) linspace(1,.7,decay3) linspace(.7,.7,sustain3) linspace(.7,0,release3)];
ADSR_sixteenth = [linspace(0,1,attack4) linspace(1,.7,decay4) linspace(.7,.7,sustain4) linspace(.7,0,release4)];


G_eighth_ADSR=ADSR_eighth.*G_eighth;
Gh_eighth_ADSR=ADSR_eighth.*Gh_eighth;
G_half_ADSR=ADSR_half.*G_half;
Gh_half_ADSR=ADSR_half.*Gh_half;

A_eighth_ADSR=ADSR_eighth.*A_eighth;
Ah_eighth_ADSR=ADSR_eighth.*Ah_eighth;
A_quarter_ADSR=ADSR_quarter.*A_quarter;
Ah_quarter_ADSR=ADSR_quarter.*Ah_quarter;

B_eighth_ADSR=ADSR_eighth.*B_eighth;
Bh_eighth_ADSR=ADSR_eighth.*Bh_eighth;

C_eighth_ADSR=ADSR_eighth.*C_eighth;
Ch_eighth_ADSR=ADSR_eighth.*Ch_eighth;
C_quarter_ADSR=ADSR_quarter.*C_quarter;
Ch_quarter_ADSR=ADSR_quarter.*Ch_quarter;
C_half_ADSR=ADSR_half.*C_half;
Ch_half_ADSR=ADSR_half.*Ch_half;

D_sixteenth_ADSR=ADSR_sixteenth.*D_sixteenth;
Dh_sixteenth_ADSR=ADSR_sixteenth.*Dh_sixteenth;
D_eighth_ADSR=ADSR_eighth.*D_eighth;
Dh_eighth_ADSR=ADSR_eighth.*Dh_eighth;
D_quarter_ADSR=ADSR_quarter.*D_quarter;
Dh_quarter_ADSR=ADSR_quarter.*Dh_quarter;

E_eighth_ADSR=ADSR_eighth.*E_eighth;
Eh_eighth_ADSR=ADSR_eighth.*Eh_eighth;
E_quarter_ADSR=ADSR_quarter.*E_quarter;
Eh_quarter_ADSR=ADSR_quarter.*Eh_quarter;
E_half_ADSR=ADSR_half.*E_half;
Eh_half_ADSR=ADSR_half.*Eh_half;

F_eighth_ADSR=ADSR_eighth.*F_eighth;
Fh_eighth_ADSR=ADSR_eighth.*Fh_eighth;
F_quarter_ADSR=ADSR_quarter.*F_quarter;
Fh_quarter_ADSR=ADSR_quarter.*Fh_quarter;
F_half_ADSR=ADSR_half.*F_half;
Fh_half_ADSR=ADSR_half.*Fh_half;

G2_eighth_ADSR=ADSR_eighth.*G2_eighth;
G2h_eighth_ADSR=ADSR_eighth.*G2h_eighth;
G2_quarter_ADSR=ADSR_quarter.*G2_quarter;
G2h_quarter_ADSR=ADSR_quarter.*G2h_quarter;
G2_half_ADSR=ADSR_half.*G2_half;
G2h_half_ADSR=ADSR_half.*G2h_half;

G2S_eighth_ADSR=ADSR_eighth.*G2S_eighth;
G2hS_eighth_ADSR=ADSR_eighth.*G2hS_eighth;

A2_eighth_ADSR=ADSR_eighth.*A2_eighth;
A2h_eighth_ADSR=ADSR_eighth.*A2h_eighth;
A2_quarter_ADSR=ADSR_quarter.*A2_quarter;
A2h_quarter_ADSR=ADSR_quarter.*A2h_quarter;

B2_eighth_ADSR=ADSR_eighth.*B2_eighth;
B2h_eighth_ADSR=ADSR_eighth.*B2h_eighth;
B2_quarter_ADSR=ADSR_quarter.*B2_quarter;
B2h_quarter_ADSR=ADSR_quarter.*B2h_quarter;
B2_half_ADSR=ADSR_half.*B2_half;
B2h_half_ADSR=ADSR_half.*B2h_half;

C2_eighth_ADSR=ADSR_eighth.*C2_eighth;
C2h_eighth_ADSR=ADSR_eighth.*C2h_eighth;
C2_quarter_ADSR=ADSR_quarter.*C2_quarter;
C2h_quarter_ADSR=ADSR_quarter.*C2h_quarter;
C2_half_ADSR=ADSR_half.*C2_half;
C2h_half_ADSR=ADSR_half.*C2h_half;

D2_sixteenth_ADSR=ADSR_sixteenth.*D2_sixteenth;
D2h_sixteenth_ADSR=ADSR_sixteenth.*D2h_sixteenth;
D2_eighth_ADSR=ADSR_eighth.*D2_eighth;
D2h_eighth_ADSR=ADSR_eighth.*D2h_eighth;
D2_quarter_ADSR=ADSR_quarter.*D2_quarter;
D2h_quarter_ADSR=ADSR_quarter.*D2h_quarter;
D2_half_ADSR=ADSR_half.*D2_half;
D2h_half_ADSR=ADSR_half.*D2h_half;

E2_sixteenth_ADSR=ADSR_sixteenth.*E2_sixteenth;
E2h_sixteenth_ADSR=ADSR_sixteenth.*E2h_sixteenth;
E2_eighth_ADSR=ADSR_eighth.*E2_eighth;
E2h_eighth_ADSR=ADSR_eighth.*E2h_eighth;
E2_quarter_ADSR=ADSR_quarter.*E2_quarter;
E2h_quarter_ADSR=ADSR_quarter.*E2h_quarter;
E2_half_ADSR=ADSR_half.*E2_half;
E2h_half_ADSR=ADSR_half.*E2h_half;
E2_whole_ADSR=ADSR_whole.*E2_whole;
E2h_whole_ADSR=ADSR_whole.*E2h_whole;

F2_eighth_ADSR=ADSR_eighth.*F2_eighth;
F2h_eighth_ADSR=ADSR_eighth.*F2h_eighth;
F2_quarter_ADSR=ADSR_quarter.*F2_quarter;
F2h_quarter_ADSR=ADSR_quarter.*F2h_quarter;

G3_eighth_ADSR=ADSR_eighth.*G3_eighth;
G3h_eighth_ADSR=ADSR_eighth.*G3h_eighth;
G3_quarter_ADSR=ADSR_quarter.*G3_quarter;
G3h_quarter_ADSR =ADSR_quarter.*G3h_quarter;
G3_half_ADSR=ADSR_half.*G3_half;
G3h_half_ADSR=ADSR_half.*G3h_half;

A3_eighth_ADSR=ADSR_eighth.*A3_eighth;
A3h_eighth_ADSR=ADSR_eighth.*A3h_eighth;
A3_quarter_ADSR=ADSR_quarter.*A3_quarter;
A3h_quarter_ADSR=ADSR_quarter.*A3h_quarter;

B3_eighth_ADSR=ADSR_eighth.*B3_eighth;
B3h_eighth_ADSR=ADSR_eighth.*B3h_eighth;
B3_quarter_ADSR=ADSR_quarter.*B3_quarter;
B3h_quarter_ADSR=ADSR_quarter.*B3h_quarter;
B3_half_ADSR=ADSR_half.*B3_half;
B3h_half_ADSR=ADSR_half.*B3h_half;

C3_eighth_ADSR=ADSR_eighth.*C3_eighth;
C3h_eighth_ADSR=ADSR_eighth.*C3h_eighth;
C3_quarter_ADSR=ADSR_quarter.*C3_quarter;
C3h_quarter_ADSR=ADSR_quarter.*C3h_quarter;
C3_half_ADSR=ADSR_half.*C3_half;
C3h_half_ADSR=ADSR_half.*C3h_half;

D3_sixteenth_ADSR=ADSR_sixteenth.*D3_sixteenth;
D3h_sixteenth_ADSR=ADSR_sixteenth.*D3h_sixteenth;
D3_eighth_ADSR=ADSR_eighth.*D3_eighth;
D3h_eighth_ADSR=ADSR_eighth.*D3h_eighth;
D3_quarter_ADSR=ADSR_quarter.*D3_quarter;
D3h_quarter_ADSR=ADSR_quarter.*D3h_quarter;
D3_half_ADSR=ADSR_half.*D3_half;
D3h_half_ADSR=ADSR_half.*D3h_half;

E3_sixteenth_ADSR=ADSR_sixteenth.*E3_sixteenth;
E3h_sixteenth_ADSR=ADSR_sixteenth.*E3h_sixteenth;
E3_eighth_ADSR=ADSR_eighth.*E3_eighth;
E3h_eighth_ADSR=ADSR_eighth.*E3h_eighth;
E3_quarter_ADSR=ADSR_quarter.*E3_quarter;
E3h_quarter_ADSR=ADSR_quarter.*E3h_quarter;
E3_half_ADSR=ADSR_half.*E3_half;
E3h_half_ADSR=ADSR_half.*E3h_half;
E3_whole_ADSR=ADSR_whole.*E3_whole;
E3h_whole_ADSR=ADSR_whole.*E3h_whole;

F3_eighth_ADSR=ADSR_eighth.*F3_eighth;
F3h_eighth_ADSR=ADSR_eighth.*F3h_eighth;
F3_quarter_ADSR=ADSR_quarter.*F3_quarter;
F3h_quarter_ADSR=ADSR_quarter.*F3h_quarter;

G4_eighth_ADSR=ADSR_eighth.*G4_eighth;
G4h_eighth_ADSR=ADSR_eighth.*G4h_eighth;
G4_quarter_ADSR=ADSR_quarter.*G4_quarter;
G4h_quarter_ADSR =ADSR_quarter.*G4h_quarter;
G4_half_ADSR=ADSR_half.*G4_half;
G4h_half_ADSR=ADSR_half.*G4h_half;



song = [F2h_eighth_ADSR A3h_eighth_ADSR B3h_quarter_ADSR F2h_eighth_ADSR A3h_eighth_ADSR B3h_quarter_ADSR F2h_eighth_ADSR A3h_eighth_ADSR B3h_eighth_ADSR E3h_eighth_ADSR D3h_quarter_ADSR B3h_eighth_ADSR C3h_eighth_ADSR B3h_eighth_ADSR G3h_eighth_ADSR E2h_half_ADSR sixteenth_rest D2h_eighth_ADSR E2h_eighth_ADSR G3h_eighth_ADSR E2h_half_ADSR quarter_rest F2h_eighth_ADSR A3h_eighth_ADSR B3h_quarter_ADSR F2h_eighth_ADSR A3h_eighth_ADSR B3h_quarter_ADSR F2h_eighth_ADSR A3h_eighth_ADSR B3h_eighth_ADSR E3h_eighth_ADSR D3h_quarter_ADSR B3h_eighth_ADSR C3h_eighth_ADSR E3h_eighth_ADSR B3h_eighth_ADSR G3h_half_ADSR sixteenth_rest B3h_eighth_ADSR G3h_eighth_ADSR D2h_eighth_ADSR E2h_half_ADSR quarter_rest D2h_eighth_ADSR E2h_eighth_ADSR F2h_quarter_ADSR G3h_eighth_ADSR A3h_eighth_ADSR B3h_quarter_ADSR C3h_eighth_ADSR B3h_eighth_ADSR E2h_half_ADSR quarter_rest F2h_eighth_ADSR G3h_eighth_ADSR A3h_quarter_ADSR B3h_eighth_ADSR C3h_eighth_ADSR D3h_quarter_ADSR E3h_eighth_ADSR F3h_eighth_ADSR G4h_half_ADSR quarter_rest D2h_eighth_ADSR E2h_eighth_ADSR F2h_quarter_ADSR G3h_eighth_ADSR A3h_eighth_ADSR B3h_quarter_ADSR C3h_eighth_ADSR B3h_eighth_ADSR E2h_half_ADSR quarter_rest F2h_eighth_ADSR E2h_eighth_ADSR A3h_eighth_ADSR G3h_eighth_ADSR B3h_eighth_ADSR A3h_eighth_ADSR C3h_eighth_ADSR B3h_eighth_ADSR D3h_eighth_ADSR C3h_eighth_ADSR E3h_eighth_ADSR D3h_eighth_ADSR F3h_eighth_ADSR E3h_eighth_ADSR E3h_sixteenth_ADSR F3h_eighth_ADSR D3h_sixteenth_ADSR E3h_whole_ADSR quarter_rest quarter_rest quarter_rest E3h_eighth_ADSR quarter_rest];      

song2 = [Fh_eighth_ADSR A2h_eighth_ADSR A2h_eighth_ADSR A2h_eighth_ADSR Fh_eighth_ADSR A2h_eighth_ADSR A2h_eighth_ADSR A2h_eighth_ADSR Fh_eighth_ADSR A2h_eighth_ADSR A2h_eighth_ADSR A2h_eighth_ADSR Fh_eighth_ADSR A2h_eighth_ADSR A2h_eighth_ADSR A2h_eighth_ADSR Eh_eighth_ADSR G2h_eighth_ADSR G2h_eighth_ADSR G2h_eighth_ADSR Eh_eighth_ADSR G2h_eighth_ADSR G2h_eighth_ADSR Ch_eighth_ADSR Eh_eighth_ADSR G2h_eighth_ADSR G2h_eighth_ADSR G2h_eighth_ADSR Eh_eighth_ADSR G2h_eighth_ADSR G2h_eighth_ADSR Ch_eighth_ADSR Fh_eighth_ADSR A2h_eighth_ADSR A2h_eighth_ADSR A2h_eighth_ADSR Fh_eighth_ADSR A2h_eighth_ADSR A2h_eighth_ADSR A2h_eighth_ADSR Fh_eighth_ADSR A2h_eighth_ADSR A2h_eighth_ADSR A2h_eighth_ADSR Fh_eighth_ADSR A2h_eighth_ADSR A2h_eighth_ADSR A2h_eighth_ADSR Eh_eighth_ADSR G2h_eighth_ADSR G2h_eighth_ADSR G2h_eighth_ADSR Eh_eighth_ADSR G2h_eighth_ADSR G2h_eighth_ADSR Ch_eighth_ADSR Eh_eighth_ADSR G2h_eighth_ADSR G2h_eighth_ADSR G2h_eighth_ADSR Eh_eighth_ADSR G2h_eighth_ADSR G2h_eighth_ADSR Eh_eighth_ADSR Dh_eighth_ADSR Fh_eighth_ADSR Dh_eighth_ADSR Fh_eighth_ADSR Gh_eighth_ADSR Dh_eighth_ADSR Gh_eighth_ADSR Dh_eighth_ADSR Ch_eighth_ADSR Eh_eighth_ADSR Ch_eighth_ADSR Eh_eighth_ADSR Ah_eighth_ADSR Eh_eighth_ADSR Ah_eighth_ADSR Eh_eighth_ADSR Dh_eighth_ADSR Fh_eighth_ADSR Dh_eighth_ADSR Fh_eighth_ADSR Gh_eighth_ADSR Dh_eighth_ADSR Gh_eighth_ADSR Dh_eighth_ADSR Ch_eighth_ADSR Eh_eighth_ADSR Ch_eighth_ADSR Eh_eighth_ADSR Ah_eighth_ADSR Eh_eighth_ADSR Ah_eighth_ADSR Eh_eighth_ADSR Dh_eighth_ADSR Fh_eighth_ADSR Dh_eighth_ADSR Fh_eighth_ADSR Gh_eighth_ADSR Dh_eighth_ADSR Gh_eighth_ADSR Dh_eighth_ADSR Ch_eighth_ADSR Eh_eighth_ADSR Ch_eighth_ADSR Eh_eighth_ADSR Ah_eighth_ADSR Eh_eighth_ADSR Ah_eighth_ADSR Eh_eighth_ADSR Dh_eighth_ADSR Fh_eighth_ADSR Fh_eighth_ADSR eighth_rest Dh_eighth_ADSR Fh_eighth_ADSR Fh_eighth_ADSR eighth_rest Ch_eighth_ADSR G2h_eighth_ADSR G2h_eighth_ADSR eighth_rest Ch_eighth_ADSR G2h_eighth_ADSR G2h_eighth_ADSR eighth_rest Eh_eighth_ADSR A2h_eighth_ADSR eighth_rest A2h_eighth_ADSR Eh_eighth_ADSR A2h_eighth_ADSR eighth_rest A2h_eighth_ADSR Eh_eighth_ADSR G2hS_eighth_ADSR G2hS_eighth_ADSR G2hS_eighth_ADSR G2hS_eighth_ADSR eighth_rest Eh_eighth_ADSR eighth_rest];

song3 = song+song2;

sound(song3)

P_3_9(song3(1:12800),fs,50,650)

wavwrite(song3,fs,32,'lostwoods')