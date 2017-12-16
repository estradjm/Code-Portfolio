function [b,a] = f_iirnotch (F_0,Delta_F,fs)
%F_IIRNOTCH: Design an IIR notch filter
%
% Usage: [b,a] = f_iirnotch (F_0,Delta_F,fs)
%
% Inputs:
% F_0 = notch frequency
% Delta_F = radius of 3dB bandwidth (Delta_F << fs)
% fs = sampling frequency
% Outputs:
% b = 1 by 3 numerator coefficient vector
% a = 1 by 3 denominator coefficient vector
%
% See also: F_IIIRES, F_IIRCOMB, F_IIRINV
% Initialize
fs = f_clip (fs,0,fs);
F_0 = f_clip (F_0,0,fs/2);
Delta_F = f_clip (Delta_F,0,fs/4);
% Find the parameters
r = 1 - (Delta_F*pi/fs);
theta_0 = 2*pi*F_0/fs;
b_0 = abs(1 - 2*r*cos(theta_0) + r^2)/(2*abs(1-cos(theta_0)));
% Find the coefficient vectors
b = b_0*[1,-2*cos(theta_0),1];
a = [1,-2*r*cos(theta_0),r^2];
