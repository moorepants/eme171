function [A, B] = segway_state_space(p)
    % SEGWAY_STATE_SPACE - Returns the state and input matrices of a simple
    % Segway longitudinal balancing model.
    %
    % Syntax: [A, B] = segway_state_space(p)
    %
    % Inputs:
    %   p - Structure containing the base constant parameters of the system.
    % Outputs:
    %   A - 4x4 state matrix corresponding to the state x = [p3; p7; q8; p17]
    %   B - 4x2 input matrix corresponding to the input u = [e(t); F(t)]

    % define all of the generalized linear constants of the bond graph
    R2 = p.R;
    I3 = p.L;
    r4_5 = p.T;
    I7 = p.Jp;
    C8 = 1/p.mp/p.g/p.lp;
    m9_10 = p.lp;
    I12 = p.mp;
    I14 = p.mw;
    m16_15 = p.d/2;
    I17 = p.Jw;

    % solve the derivative casuality system numerically
    % M*y = N*w + b*r
    % y = [p7dot; p17dot]
    % w = [p3; q8]
    % r = [F(t)]
    % y = M^-1*N*w + M^-1*b*r
    M = [  1 + I12/I7*m9_10^2,                   -I12/I17*m9_10*m16_15;
         -I12/I7*m9_10*m16_15, 1 + I14/I17*m16_15^2 + I12/I17*m16_15^2];

    N = [r4_5/I3, 1/C8;
         r4_5/I3,    0];

    b = [  m9_10;
         -m16_15];

    invM = inv(M);

    % M^-1 * N
    MN = invM * N;
    % M^-1 * b
    Mb = invM * b;

    % y = MN * w + Mb * r

    % define the state and input matrices
    A = [ -R2/I3, -r4_5/I7,       0, -r4_5/I17;
         MN(1,1),        0, MN(1,2),         0;
               0,     1/I7,       0,         0;
         MN(2,1),        0, MN(2,2),         0];

    B = [1, 0;
         0, Mb(1);
         0, 0;
         0, Mb(2)];

end
