function [M2,v1,v2,T2T1,P2P1] = ExpansionWave(M1,theta)
% this fanction calculates the downstream of an Expansion Wave
% returning the downstream M, pressure ratio, tempreture ratio

k=1.4;
theta = theta * pi/180; %converting to radian

%calculating v1 & v2
v1 = sqrt((k+1)/(k-1))*atan((sqrt(((k-1)/(k+1))*(M1^2-1))))-atan(sqrt(M1^2-1));
v2 = theta + v1;    % converting to radian

%calculating M2
M2=0;
for M = M1:0.00001:8
    v = sqrt((k+1)/(k-1))*atan((sqrt(((k-1)/(k+1))*(M^2-1))))-atan(sqrt(M^2-1)) - v2;
    if abs(v) < 0.00001
        M2 = M; break
    end
end

%calulating the pressure & temperature ratios
T2T1 = ((1+((k-1)/2)*M1^2)/(1+((k-1)/2)*M2^2));
P2P1 = (T2T1)^(k/(k-1));

v1 = v1 * 180/pi;   %returning in degree
v2 = v2 * 180/pi;   %returning in degree
end