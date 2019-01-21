%% This file demonstrates how to do basic simulation of first order differential
%% equations of a simple DC motor model.
% This file contains three functions. The first function in the file will be the
% primary function that calls the other two functions defined below.
function simulate_dc_motor()
    % The system has four state variables and here the initial condition for
    % each state variable is set.
    % x = [q, i, theta, omega]
    x0 = [0, 0, 0, 0];

    % Create a vector of time values that we desire to know x(t) at. The
    % larger the number of values, the more accurate the result is, but the
    % slower the integration runs.
    t = linspace(0, 10, 1000);

    % Call a function that integrates the system's equations and returns
    % x(t).
    % The @ is required to pass in functions to other functions, i.e. a
    % function name is not a standard variable name.
    [t, x] = euler_integrate(@f, t, x0);

    % Plot the results. Always label x and y axis and provide units! Note
    % that Octave/Matlab can render mathematical symbols using LaTeX
    % notation.
    figure(1);
    plot(t, x);
    xlabel('Time [s]');
    legend('q [C]', 'i [A]', '\theta [rad]', '\omega [rad/s]');

    % We wrote our own integration function here, but Octave/Matlab includes
    % many better integration routines that can handle certain ODEs more
    % carefully, ensuring accurate results. For example ode45() works just
    % like euler_integrate() but uses the Runga-Kutta 4-5 integration
    % algorithm. This is a good algorithm for most non-stiff system
    % equations and will work with most of the models in this class. You use
    % it like so:
    [t, x] = ode45(@f, t, x0);

    % You should almost exactly the same results as the custom integration
    % function:
    figure(2);
    plot(t, x);
    xlabel('Time [s]');
    legend('q [C]', 'i [A]', '\theta [rad]', '\omega [rad/s]');
end

function [t, x] = euler_integrate(f, t, x0)
    % EULER_INTEGRATE - Integrates a set of first order ordinary
    % differential equations using Euler's integration method.
    %
    % Syntax: [t, x] = euler_integrat(f, t, x0)
    %
    % Inputs:
    %   f - An anonymous function that evaluates the right hand side of the
    %       first order ordinary differential equations, i.e. dx/dt. The
    %       function must follow the syntax dxdt = f(t, x) and return a size
    %       1xm vector where t is size 1x1 and x is size 1xm.
    %   t - Vector of monotonically increasing time values. [size 1xn]
    %   x0 - Vector a initial conditions for the states. [size 1xm]
    % Outputs:
    %   t - Vector of monotonically increasing time values (same as the
    %       input t). [size 1xn]
    %   x - Matrix of state values as a function of time. [size nxm]

    % Create an "empty" matrix to hold the results n x m.
    x = nan * ones(length(t), length(x0));

    % Set the initial conditions to the first element.
    x(1, :) = x0;

    % Use a for loop to sequentially calculate each new x.
    for i = 2:length(t)
        deltat = t(i) - t(i-1);
        x(i, :) = x(i - 1, :) + deltat * f(t(i - 1), x(i - 1, :));
    end
end

function xdot = f(t, x)

    % Extract the state variables so we can use the variable names we want.
    q = x(1);
    i = x(2);
    theta = x(3);
    omega = x(4);

    % Declare the constants. Make sure units are compatible!
    L = 0.5;  % motor inductance [H]
    Rw = 1.0;  % motor winding resistance [Ohm]
    ktau = 1.5;  % motor torque constant [N*m/A]
    b = 1.8;  % Rotor viscous friction [N*m*s]
    J = 0.1;  % Rotor inertia [kg*m^2]

    % Initialize the empty vector for the derivative of the states. [1xm]
    xdot = nan * zeros(1, length(x));

    % The voltage is the source effort in this system. So we can specify what we
    % want it to be.
    % Example 1, constant voltage:
    V = 0.5;
    % Uncomment the following two examples to try them out.
    % Example 2, sinusoidal voltage (function of time):
    %V = 0.5*sin(pi*t);
    % Example 3, voltage switches on at 1 second (also function of time):
%    if t < 1
%        V = 0;
%    else
%        V = 0.5;
%    end

    % Fill the derivative entries based on the system's equations.
    xdot(1) = i;
    xdot(2) = (-Rw*i - ktau*omega + V) / L;
    xdot(3) = omega;
    xdot(4) = (-b*omega + ktau*i) / J;
end
