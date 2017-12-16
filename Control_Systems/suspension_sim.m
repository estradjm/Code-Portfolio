clc;
clear;
alpha= 0;
Kp=17000;
Kd=50;
Ki=.1;
Ke=1;
sim('DNS_Final_Project')
% Car Animation Script
% This Matlab script is used in conjunction with your Simulink model to
% produce an animation of the half-car body as it travels down the road
% profile defined in the EE324, Spring 2009 project description.
%
% The script assumes your Simulink model has created the following vectors
% related to the motion of the car half-body model:
% yc = vertical position of the car body center of mass (CoM)
% theta = angular position of the car body
% yw1 = vertical position of the front wheel
% yw2 = vertical position of the rear wheel
% yr1 = vertical position of the road under the front wheel
% yr2 = vertical position of the road under the rear wheel
% Paramter Setup for Car Animation
xc=-1;yc0=1.25;dyc=0.25; D1=1;D2=2; % Define car body, e.g., center of mass,
height, length
dxw=1;yw0=.25;dyw=0.1; % Define wheels
rc1=sqrt(D1^2+dyc^2); ac1t=atan2(dyc,D1); ac1b=atan2(-dyc,D1); % Define front
of car in polar coordinates
rc2=sqrt(D2^2+dyc^2); ac2t=atan2(dyc,-D2); ac2b=atan2(-dyc,-D2); % Define
rear of car in polar coordinates
% Clear the workshop screen
clc;
% Get input to on status of active suspension control: off (0) or on (1)
Active=input('Is active suspension control on (0=No, 1=Yes)? ');
% Enter Loop to Create Car Animation
for i = 1:length(yc)
figure(1);clf(1)
% Draw Car Body
x=[xc+rc1*cos(ac1t+theta(i)), xc+rc1*cos(ac1b+theta(i)),
xc+rc2*cos(ac2b+theta(i)), xc+rc2*cos(ac2t+theta(i))];
y=[yc0+yc(i)+rc1*sin(ac1t+theta(i)), yc0+yc(i)+rc1*sin(ac1b+theta(i)),
yc0+yc(i)+rc2*sin(ac2b+theta(i)), yc0+yc(i)+rc2*sin(ac2t+theta(i))];
patch(x,y,'r'); hold on;
plot(xc,yc0+yc(i),'xk','MarkerSize',10,'linewidth',2);plot(xc,yc0+yc(i),'ok',
'MarkerSize',10,'linewidth',2)
% Draw Front Wheel

x=[xc+D1, xc+D1, xc+D1-dxw, xc+D1-dxw];
y=[yw0+yw1(i)+dyw, yw0+yw1(i)-dyw, yw0+yw1(i)-dyw, yw0+yw1(i)+dyw];
patch(x,y,'r')
% Draw Rear Wheel
x=[xc-D2, xc-D2, xc-D2+dxw, xc-D2+dxw];
y=[yw0+yw2(i)+dyw, yw0+yw2(i)-dyw, yw0+yw2(i)-dyw, yw0+yw2(i)+dyw];
patch(x,y,'r')
% Draw Passive Suspension Connecting Body to Wheels
plot([xc+D1-dxw/2, xc+D1-dxw/2],[yw0+dyw+yw1(i), yc0+yc(i)-(D1-
dxw/2)*tan(ac1t-theta(i))],'g-','MarkerSize',5,'linewidth',12);
plot([xc-D2+dxw/2, xc-D2+dxw/2],[yw0+dyw+yw2(i), yc0+yc(i)+(D2-
dxw/2)*tan(ac2t-theta(i))],'g-','MarkerSize',5,'linewidth',12);
if Active
% Draw Active Suspension Connecting Body to Wheels
plot([xc+D1-dxw/2, xc+D1-dxw/2],[yw0+dyw+yw1(i), yc0+yc(i)-(D1-
dxw/2)*tan(ac1t-theta(i))],'b-','MarkerSize',5,'linewidth',5);
plot([xc-D2+dxw/2, xc-D2+dxw/2],[yw0+dyw+yw2(i), yc0+yc(i)+(D2-
dxw/2)*tan(ac2t-theta(i))],'b-','MarkerSize',5,'linewidth',5);
end
% Draw Passive Suspension Connecting Wheel to Road
plot([xc+D1-dxw/2, xc+D1-dxw/2],[yr1(i),yw0-dyw+yw1(i)],'g','MarkerSize',5,'linewidth',12)
plot([xc-D2+dxw/2, xc-D2+dxw/2],[yr2(i),yw0-dyw+yw2(i)],'g','MarkerSize',5,'linewidth',12)
% Draw Road
x=[-3.5, -3.5, -1.5, -1.5, 0.5, 0.5];
y=[-1, yr2(i), yr2(i), yr1(i), yr1(i), -1];
patch(x,y,'k')
% Label Figure
text(-3.4,3.35,'Car Body and Wheels (Red); Car Body Center of Mass (X); Road
(Black)')
text(-3.4,3.1,'Suspension Components: Passive (Green); Active (Blue)')
title('Response of Half-car Model with Active Suspension System')
xlabel('Horizonal Position [m]')
ylabel('Vertical Position [m]')
% Scale Plot Axes
set(gca,'ylim',[-0.5,3.5])
set(gca,'xlim',[-3.5,0.5])
end
