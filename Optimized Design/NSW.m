function [M2,T2T1,P2P1,pho2pho1,Po2Po1] = NSW(M1)
% this fanction calculates the downstream of an Normal Shock Wave
% returning the downstream M, pressure ratio, tempreture ratio, density ratio

k = 1.4;
M2 = sqrt((1+ M1^2*(k-1)/2) / (k*M1^2-(k-1)/2));
P2P1 = 1 + 2*k/(k+1) * (M1^2-1);
pho2pho1 = ((k+1)*M1^2) / (2+(k-1)*M1^2);
Po2Po1 =(1+(k-1)/2*M2^2)^(k/(k-1)) * P2P1 * (1+(k-1)/2*M1^2)^(-k/(k-1));
T2T1 = P2P1/pho2pho1;

end