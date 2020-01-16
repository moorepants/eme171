function r = eval_steer_control_input(t, x, p)

% unpack the states
omega = x(1);
theta = x(2);

% unpack the control gains
kp = p.kp;

% calculate the inputs
beta = kp*omega;
delta = kp*theta;

% pack up the inputs
r = [beta; delta];

end
