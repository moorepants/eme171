function r = eval_steer_control_input(t, x, p)

% unpack the states
omega = x(1);
theta = x(2);

% unpack the control gains
kp = p.kp;
kd = p.kd;

% calculate the inputs
beta = kp*omega;
delta = kp*theta + kd*omega;

% pack up the inputs
r = [beta; delta];

end
