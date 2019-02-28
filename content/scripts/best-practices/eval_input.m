function r = eval_input(t, x, p)
    % EVAL_INPUT - Returns the input vector at any given time.
    %
    % Syntax: r = eval_input(t, x, p)
    %
    % Inputs:
    %   t - A scalar value of time, size 1x1.
    %   x - State vector at time t, size nx1 were m is the number of states.
    %   p - Constant parameter vector, size ox1 were m is the number of parameters.
    % Outputs:
    %   r - Input vector at time t, size mx1.

    % unpack the states (not needed in this case)
    theta = x(1);
    omega = x(2);

    % unpack the parameters
    m = p(1);
    l = p(2);
    g = p(3);

    % define the time varying input
    tau = m * g * l * sin(pi/20*t);

    % pack the inputs into a vector
    r = [tau];

end
