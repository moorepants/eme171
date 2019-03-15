function u = eval_segway_input(t, x, p, G)

    % 1 x 4 * 4 x 1
    e = -G * x(1:4);

    % define a gust of wind
    if t > 1.0 && t < 2.0
        % magnitude of force from a gust of wind hitting a human at velocity
        % v
        % rho = 1.2
        % Cd*A = 0.84
        v = 18; % m/s
        F = 1.2*0.84/2*v**2;
    else
        F = 0.0;
    end

    u = [e; F];

end
