function xdot = eval_segway_rhs(t, x, g, p, A, B, G)
    % EVAL_SEGWAY_RHS - Returns the time derivative of the states, i.e.
    % evaluates the right hand side of the explicit ordinary differential
    % equations.
    %
    % Syntax: xdot = eval_segway_rhs(t, x, r, p)
    %
    % Inputs:
    %   t - Scalar value of time, size 1x1.
    %   x - State vector [p3; p7; q8; p17; xw], size 5x1.
    %   g - Anonymous function of form g(t, x, p, G) which computes the
    %       input at time t.
    %   p - Constant parameter structure.
    %   A - State matrix for first four states, size 4x4.
    %   B - Input matrix, size 4x2.
    %   G - Full state feedback gain matrix, size 1x4.
    % Outputs:
    %   xdot - Time derivative of the states at time t, size 5x1.

    % evaluate the input
    u = g(t, x, p, G);

    xdot = zeros(5, 1);

    xdot(1:4, :) = A * x(1:4) + B * u;

    % add an extra non-essential ODE so we can get wheel position
    omega_w = x(4) / p.Jw;
    vw = omega_w * p.d / 2;
    xdot(5, 1) = vw;

end
