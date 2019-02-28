function y = eval_output(t, x, r, p)
    % EVAL_OUTPUT - Returns the output vector at the specified time.
    %
    % Syntax: y = eval_output(t, x, r, p)
    %
    % Inputs:
    %   t - Scalar value of time, size 1x1.
    %   x - State vector at time t, size mx1 where m is the number of
    %       states.
    %   r - Input vector at time t, size nx1 were n is the number of inputs.
    %   p - Constant parameter vector, size ox1 were p is the number of
    %       parameters.
    % Outputs:
    %   t - Output vector at time t, size ptx1.

    theta = x(1);
    omega = x(2);

    m = p(1);
    l = p(2);
    g = p(3);

    x_pos = l.*cos(theta);
    y_pos = l.*sin(theta);

    kinetic_energy = m*l^2*omega^2/2;
    potential_energy = m*g*y_pos;

    y = [x_pos; y_pos; kinetic_energy; potential_energy];

end
