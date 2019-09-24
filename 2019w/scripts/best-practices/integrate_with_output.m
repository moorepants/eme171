% same integration code as above
x0 = [5*pi/180; 0];
ts = linspace(0, 10, 500);
p = [1; 1; 9.81];
f_anon = @(t, x) eval_rhs_with_input(t, x, @eval_input, p);
[ts, xs] = ode45(f_anon, ts, x0);

% to compute the outputs at each time, you must iterate through time
ys = zeros(length(ts), 4);  % create a matrix to store the values, nxq
for i=1:length(ts)
    % the r input isn't used, so nan can be set as a placeholder
    ys(i, :) = eval_output(ts(i), xs(i, :), nan, p);
end
