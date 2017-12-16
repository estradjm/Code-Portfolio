%Data Importation and Extraction
input=load('input.mat'); %10 second signal
fs=360; %Sampling Frequency (Hertz)
N=length(input);
t = ((0:length(input)-1)./fs); %Time Interval
t=t';
figure(1)
plot(t, input)
title('Noise Corrupted ECG Signal')
xlabel('Time [sec]')
ylabel('Amplitude')
%--------------------------------------------------------------------------
Ys = fft(input)/N;
equal_space=linspace(0,.5,N/2); %adjusting the interval of frequency range
freq = fs*equal_space;
Ys = Ys(1:ceil(N)/2);
plot(freq,2*abs(Ys))
title('ECG signal in Frequency Domain')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
F_0=60;
Delta_F=1;
[b,a] = f_iirnotch (F_0,Delta_F,fs);%creates coefficient vectors a and b
refined=filter(b,a,input); %filter signal
[H Hf] = f_freqz(b,a,N); %returns transfer function
amp=abs(H);
figure(2)
plot(Hf*fs,amp)
title('60 Hertz Notch Filter')
xlabel('Frequency [Hz]')
ylabel('|H(f)|')
%--------------------------------------------------------------------------
%Attempting different values of delta F
subplot(3,1,1)
plot(t,refined)
title('Refined ECG Signal with delta F=1')
xlabel('Time [sec]')
ylabel('Amplitude')
F_0=60;
Delta_F=5;
[b,a] = f_iirnotch (F_0,Delta_F,fs);%creates coefficient vectors a and b
refined=filter(b,a,input); %filter signal
subplot(3,1,2)
13
plot(t,refined)
title('Refined ECG Signal with delta F=5')
xlabel('Time [sec]')
ylabel('Amplitude')
F_0=60;
Delta_F=10;
[b,a] = f_iirnotch (F_0,Delta_F,fs);%creates coefficient vectors a and b
refined=filter(b,a,input); %filter signal
subplot(3,1,3)
plot(t,refined)
title('Refined ECG Signal with delta F=10')
xlabel('Time [sec]')
ylabel('Amplitude')
%--------------------------------------------------------------------------
%interference
interference=input-refined;
plot(t, interference)
title('Interference')
xlabel('Time [sec]')
ylabel('Amplitude')
