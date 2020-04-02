% define the initial conditions
x0 = [?; ?; ?];

% define a set of time values
ts = ?;

% set the numerical values for the constants
c.M = ?;
c.K = ?;
c.B = ?;
c.A = ?;

% integrate the differential equations
rhs = @(t, x) eval_quarter_car_rhs(t, x, @eval_triangular_bump, c);
[ts, xs] = ode45(rhs, ts, x0);

% evaluate the outputs
zs = zeros(length(ts), 3);  % place to store outputs
for i=1:length(ts)
    % calculate x' at the given time
    xdot = eval_quarter_car_rhs(ts(i), xs(i, :), @eval_triangular_bump, c);
    % calculate the outputs that depend on x' and store them
    zs(i, :) = eval_quarter_car_outputs(ts(i), xdot, xs(i, :), @eval_triangular_bump, c);
end

% write your code to make the plots below
