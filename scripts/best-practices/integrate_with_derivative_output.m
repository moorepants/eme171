% integrate the ODEs as defined above
x0 = [5*pi/180; 0];
ts = linspace(0, 10, 500);
p = [1; 1; 9.81];
f_anon = @(t, x) eval_rhs_with_input(t, x, @eval_input, p);
[ts, xs] = ode45(f_anon, ts, x0);

% to compute the outputs at each time, loop through time evaluating f(t, x,
% r, p) and then h(t, x', x, r, p)
zs = zeros(length(ts), 2);  % place to store outputs
for i=1:length(ts)
    % calculate x' at the given time
    xdot = eval_rhs_with_input(ts(i), xs(i, :), @eval_input, p);
    % calculate the outputs that depend on x' and store them
    zs(i, :) = eval_output_with_state_derivatives(ts(i), xdot, xs(i, :), @eval_input, p);
end
