function r = eval_input(t, x, p)
    % EVAL_INPUT - Returns the input vector at any given time.
    %
    % Syntax: r = eval_input(t, x, p)
    %
    % Inputs:
    %   t - A scalar value of time, size 1x1.
    %   x - State vector at time t, size mx1 were m is the number of states.
    %   p - Constant parameter vector, size px1 where p is the number of
    %       parameters.
    % Outputs:
    %   r - Input vector at time t, size ox1 where o is the number of
    %       inputs.

    % NOTE : x is not needed in this case

    % unpack the 3x1 parameter vector
    m = p(1);
    l = p(2);
    g = p(3);

    % define a sinusoidal time varying input
    tau = m*g*l/2*sin(pi/20*t);

    % pack the inputs into an 1x1 vector
    r = [tau];

end
