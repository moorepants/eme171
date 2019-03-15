function xdot = eval_segway_rhs(t, x, g, p, A, B, G)

    % evaluate the input
    u = g(t, x, p, G);

    xdot = zeros(5, 1);

    xdot(1:4, :) = A * x(1:4) + B * u;

    % add an extra non-essential ODE so we can get xw
    omega_w = x(4) / p.Jw;
    vw = omega_w * p.d / 2;
    xdot(5, 1) = vw;

end
