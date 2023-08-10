function [M2,beta,P2P1,T2T1,Po2Po1] = OSW(M1,theta)
% this fanction calculates the downstream of an oblique shock wave
% returning the downstream M, pressure ratio, tempreture ratio
k = 1.4;
theta = theta * pi/180;
% calulating the beta angle in radian
y= ((M1^2-1)^2-3*(1+((k-1)/2)*M1^2)*(1+((k+1)/2)*M1^2)*(tan(theta))^2)^(1/2);
x=((M1^2-1)^3-9*(1+((k-1)/2)*M1^2)*(1+((k-1)/2)*M1^2+((k+1)/4)*M1^4)*(tan(theta))^2)/y^3;
beta = atan((M1^2-1+2*y*cos((4*pi+acos(x))/3)) / (3*(1+((k-1)/2)*M1^2)*tan(theta)));

% calulating the downstream mach number
Mn1 = M1*sin(beta);
Mn2 = sqrt((1+((k-1)/2)*Mn1^2) / (k*Mn1^2-((k-1)/2)));
M2 = Mn2/sin(beta-theta);

% calulating the pressure & temperature ratios
P2P1 = 1+(2*k/(k+1))*(Mn1^2-1);
T2T1 = P2P1* (((k+1)*Mn1^2)/(2+(k-1)*(Mn1^2)))^(-1);
Po2Po1 =(1+(k-1)/2*Mn2^2)^(k/(k-1)) * P2P1 * (1+(k-1)/2*Mn1^2)^(-k/(k-1));
beta = beta * 180/pi; % to return beta in degree
end