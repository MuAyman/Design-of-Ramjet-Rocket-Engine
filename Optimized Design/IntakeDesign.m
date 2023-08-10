function [wedgeLength1,wedgeLength2,obliqueLength1,obliqueLength2,cowlHeight] = IntakeDesign(IntakeSide,theta1,theta2,beta1,beta2)
    
theta1 = theta1 * pi/180;
theta2 = theta2 * pi/180;
beta1 = beta1 * pi/180;
beta2 = beta2 * pi/180;

obliqueLength2 = IntakeSide / sin(beta2-theta2);
obliqueLength1 = obliqueLength2 * sin(beta2) / sin(beta1-theta1);
wedgeLength2 = obliqueLength2 * cos(beta2+theta2);
wedgeLength1 = obliqueLength2 * sin(theta1+beta2-beta1) / sin(beta1-theta1);

cowlHeight = obliqueLength1 * sin(beta1);

end