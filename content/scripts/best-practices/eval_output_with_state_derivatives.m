function z = eval_output_with_state_derivatives(t, xdot, x, r, p)
    % EVAL_OUTPUT_WITH_STATE_DERIVATIVES - Returns the output vector at the
    % specified time.
    %
    % Syntax: z = eval_output_with_state_derivatives(t, xdot, x, r, p)
    %
    % Inputs:
    %   t - Scalar value of time, size 1x1.
    %   xdot - State derivative vector as time t, size mx1.
    %   x - State vector at time t, size mx1 where m is the number of
    %       states.
    %   r - Input vector at time t, size ox1 were n is the number of inputs.
    %   p - Constant parameter vector, size ox1 were p is the number of
    %       parameters.
    % Outputs:
    %   z - Output vector at time t, size qx1.

    thetadot = xdot(1);
    omegadot = xdot(2);

    theta = x(1);
    omega = x(2);

    m = p(1);
    l = p(2);
    g = p(3);

    radial_acc = omega^2 * l;
    tangential_acc = omegadot * l;

    z = [radial_acc; tangential_acc]; 

end
