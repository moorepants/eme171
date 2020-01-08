% define the initial conditions
x0 = [ ; ; ];

% define a set of time values
ts = ;

% set the numerical values for the constants
c.M = ;
c.K = ;
c.B = ;
c.A = ;

% integrate the differential equations
f_anon = @(t, x) eval_rhs_with_input(t, x, @eval_input, c);
[ts, xs] = ode45(f_anon, ts, x0);

% evaluate the outputs
zs = zeros(length(ts), 3);  % place to store outputs
xdot = zeros(length(ts), 3);  % place to store outputs
for i=1:length(ts)
    % calculate x' at the given time
    xdot = eval_rhs_with_input_template(ts(i), xs(i, :), @eval_input, c);
    % calculate the outputs that depend on x' and store them
    zs(i, :) = eval_output_with_state_derivatives_template(ts(i), xdot, xs(i, :), @eval_input_template, c);
end

% write your code to make the plots below
