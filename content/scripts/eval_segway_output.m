function y = eval_segway_output(t, x, g, p, G)
    % EVAL_SEGWAY_INPUT - Returns the input vector, motor voltage and wind
    % force, at any given time. The voltage is computed as a full state
    % feedback controller adn the gust of wind is a step function with a 1
    % second duration.
    %
    % Syntax: u = eval_segway_input(t, x, p, G)
    %
    % Inputs:
    %   t - A scalar value of time, size 1x1.
    %   x - State vector [p3; p7; q8; p17, xw] at time t, size 5x1.
    %   g - Anonymous function of form g(t, x, p, G) which computes the
    %       input at time t.
    %   p - Constant parameter structure.
    %   G - Full state feedback gain matrix, size 1x4.
    % Outputs:
    %   y - Output vector [xw; yw; xp; yp; P] at time t, size 5x1.

    % motor current drawn from source
    i = x(1) / p.L;

    r = g(t, x, p, G);
    e = r(1);

    % electrical power
    power = e * i;

    % plotting
    thetap = x(3);
    xw = x(5);
    yw = p.d / 2;

    xp = xw - p.lp * sin(thetap);
    yp = yw + p.lp * cos(thetap);

    y = [xw; xp; yw; yp; power];

end
