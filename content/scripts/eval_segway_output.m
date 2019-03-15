function y = eval_segway_output(t, x, g, p, G)

    % motor current draw from source
    i = x(1) / p.L;

    r = g(t, x, p, G);
    e = r(1);

    % electrical power
    power = e * i;

    % plotting
    thetap = x(3);  % q8 = thetap

    % TODO : need extra ODE xw' = vw to get this value
    x_com_w = x(5);
    y_com_w = p.d / 2;

    x_com_p = x_com_w - p.lp * sin(thetap);
    y_com_p = y_com_w + p.lp * cos(thetap);

    y = [x_com_w; x_com_p; y_com_w; y_com_p; power];

end
