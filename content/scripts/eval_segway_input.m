function u = eval_segway_input(t, x, p, G)
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
    %   p - Constant parameter structure.
    %   G - Full state feedback gain matrix, size 1x4.
    % Outputs:
    %   u - Input vector [e(t); F(t)] at time t, size 2x1.

    % compute the full state feedback controller base on first four
    % essential states
    % 1x1 = 1x4 * 4x1
    e = -G * x(1:4);

    % define a gust of wind applied between 1 and 2 seconds
    if t > 1.0 && t < 2.0
        % magnitude of force from a gust of wind hitting a human at speed v
        rho = 1.2;  % air density [kg/m^3]
        CdA = 0.84;  % drag coeff times frontal area [m^2]
        v = 18; % wind speed [m/s]
        F = rho*CdA*v**2/2;
    else
        F = 0.0;
    end

    % pack input into a 2x1 vector
    u = [e; F];

end
