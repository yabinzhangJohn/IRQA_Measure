function [ Unit_2D ] = CalFaceBlock(height, width, alpha, beta, gamma, center)

    Unit_LT = [1 -width/2 height/2];
    Unit_RT = [1 width/2 height/2];
    Unit_LB = [1 -width/2 -height/2];
    Unit_RB = [1 width/2 -height/2];

    Unit = [Unit_LT; Unit_RT; Unit_LB; Unit_RB];

    % the rotation matrix
    Rz = [cos(alpha) -sin(alpha) 0;
        sin(alpha) cos(alpha) 0;
        0 0 1];
    Ry = [cos(beta) 0 sin(beta);
        0 1 0;
        -sin(beta) 0 cos(beta)];
    Rx = [1 0 0;
        0 cos(gamma) -sin(gamma);
        0 sin(gamma) cos(gamma)];
    Unit_rotated = Rz*Ry*Rx*Unit';
    Unit_rotated = Unit_rotated';
    Unit_2D = Unit_rotated(:,2:3);
    
    Unit_center = mean(Unit_2D);
    Unit_2D = (Unit_2D-repmat(Unit_center,[4,1]))+ repmat(center, [4,1]);
end

