clear all; clc;
%% Constants
k = 1.4;
R = 287;
Amax = 250;
M1 = 2.75;
P1 = 12110;     % Pa
T1 = 216.5;     % K
pho1 = 0.193;   % Kg/m3
To1 = T1 * (1+(k-1)/2*M1^2); % To1 = To2 = To3 = To4 = To5
Po1 = P1 * (To1/T1)^(k/(k-1));
BestP4P1 = 1; % dummy
IntakeArea = 1:50;
Thrust = 1:50;

%% Determining the intake angles
for theta = 1:0.05:30
    % from 1 to 2
    [M2,beta1,P2P1,T2T1,Po2Po1] = OSW(M1,theta);
    
    % form 2 to 3
    for theta2 = 1:0.5:30
        [M3,beta2,P3P2,T3T2,Po3Po2] = OSW(M2,theta2);
        if ~isreal(M3)
            break;       % if theta2 exceeds the maximum, break
        end
        P3P1 = P3P2 * P2P1;
        Po3Po1 = Po3Po2 * Po2Po1;
        T3T1 = T3T2 * T2T1;
        
        % from 3 to 4
        [M4,T4T3,P4P3,Po4Po3] = NSW(M3);
        
        P4P1 = P4P3 * P3P1;
        Po4Po1 = Po4Po3 * Po3Po1;
        T4T1 = T4T3 * T3T1;
        
        if P4P1 > BestP4P1
            BestP4P1 = P4P1;
            BestPo4Po1 = Po4Po1;
            BestT4T1 = T4T1;
            BestM2 = M2;
            BestM3 = M3;
            BestM4 = M4;
            BestTheta1 = theta;
            BestTheta2 = theta2;
            BestBeta1 = beta1;
            BestBeta2 = beta2;
        end
    end
end
% clearing dummy loop data
clear beta1 beta2 M2 M3 M4 P2P1 P3P1 P3P2 P4P1 P4P3 T2T1 T3T1 T3T2 T4T1 T4T3 pho4pho3 theta theta2;

i = 1;
for IntakeSide = 5:1:250
    %% Intake Design (1-2-3-4)
    % the maximum cowl height is 125mm and hence maximum intake side of 54.175mm
    % taking IntakeSide = 50;
    IntakeArea(i) = IntakeSide * Amax * 10^-6;
    [wedgeL1,wedgeL2,obliqueL1,obliqueL2,cowlHeight] = IntakeDesign(IntakeSide,BestTheta1,BestTheta2,BestBeta1,BestBeta2);
    A4 = IntakeSide * Amax * 10^-6; % Intake Area in m2
    T4 = BestT4T1 * T1;
    P4 = BestP4P1 * P1;
    To4 = To1;
    Po4 = P4 * (To1/T4)^(k/(k-1));
    pho4 = P4/(R*T4);
    mDot = pho4 * A4 * BestM4 * sqrt(k*R*T4);
    
    
    %% The Subsonic Diffuser (4-5)
    A5 = 0.0313;    % the combustion chamber maximum cross-sectional area
    A4Astar = sqrt(1/BestM4^2 *(2/(k+1)*(1+(k-1)/2*BestM4^2))^((k+1)/(k-1)));
    Astar4 = A4/A4Astar;
    A5Astar = A5/Astar4;
    M5 = 0.6479; err1 = inf;
    while err1 > 10e-3
        M5 = M5 - 0.001;
        err1 = A5Astar - sqrt(1/M5^2 *(2/(k+1)*(1+(k-1)/2*M5^2))^((k+1)/(k-1)));
    end
    T5 = T4 * (1+(k-1)/2*BestM4^2)/(1+(k-1)/2*M5^2);
    P5 = P4 * (T5/T4)^(k/(k-1));
    To5 = To1;
    Po5 = Po4;
    
    
    %% The Conbustion Chamber (5-6)
    Tstar5 = T5 * 1/M5^2 * ((1+k*M5^2)/(1+k))^2;
    if Tstar5 > 2200     % the max T at the combustion chamber
        T6 = 2200;
    else
        T6 = Tstar5;
    end
    
    if i == 48   % max thrust iteration
        BesttComustionTemp = T6;
    end
    
    % Tostar5 = To1 * (1+k*M5^2)^2/((k+1)*M5^2)*(2+(k-1)*M5^2);
    T6Tstar5 = T6 / Tstar5;
    M6 = M5; err2 = inf;
    while err2 > 10e-3
        M6 = M6 + 0.001;
        err2 = (M6^2 *((k+1)/(1+k*M6^2))^2) - T6Tstar5;
    end
    P6 = P5 * (1+k*M5^2)/(1+k*M6^2);
    To6 = T6 * (1+(k-1)/2*M6^2);
    Po6 = 0.95 * P6 * (To6/T6)^(k/(k-1)); % 0.95 due to the 5% friction loss
    
    
    %% The Nozzle
    A6 = 2*A5;
    Astar6 = A6 * 1/(sqrt(1/M6^2 *(2/(k+1)*(1+(k-1)/2*M6^2))^((k+1)/(k-1)))); % Astar6 is At
    
    PePo6 = P1/Po6;
    M7 = 1; err3 = 10;
    while err3 > 10e-3
        M7 = M7 + 0.001;
        err3 = PePo6 - (1+(k-1)/2*M7^2)^(-k/(k-1));
    end
    A7 = Astar6 * sqrt(1/M7^2 *(2/(k+1)*(1+(k-1)/2*M7^2))^((k+1)/(k-1)));
    if A7 > Amax
        A7 = Amax;
    end
    
    T7 = To6 * 1/(1+(k-1)/2*M7^2);
    P7 = Po6 * (T7/To6)^(k/(k-1)); % Pe
    Po7 = P7 * (To6/T7)^(k/(k-1));
    To7 = To6;
    PePo = P7/Po6;
    pho7 = P7/(R*T7);
    mDote = pho7 * A7 * M7 * sqrt(k*R*T7);
    
    
    %% The Thrust
    Ve = M7 * sqrt(k*R*T7);
    Vi = M1 * sqrt(k*R*T1);
    Thrust(i) = mDot*(Ve-Vi) + A7*(P7-P1);
    i = i + 1;
end

plot(IntakeArea,Thrust)
xlabel('Intake Area (m2)')
ylabel('Thrust (N)')
title('Thrust variations with different intake area')

