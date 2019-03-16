:title: Modeling, Simulation, and Control of a Segway
:status: hidden

The essential states are:

- :math:`p_3 = L\dot{i}`: flux through the DC motor circuit
- :math:`p_7 = J_p \omega_p`: pitch angular momentum of the person + platform
- :math:`q_8 = \theta_p`: absolute pitch angle of the person + platform
- :math:`p_{17} = J_w \omega_w`: rolling angular momentum of the wheel and rotor assembly

The inputs are:

- :math:`e(t)`: specified voltage applied to the DC motor circuit
- :math:`F(t)`: longitudinal wind force

The model is linear and thus can be put into state space form. The following
function accepts a structure, ``p``, containing all of the base constant
parameters and outputs the state matrix ``A`` and input matrix ``B``. Inside
the function, the base parameters are converted to the generalized numbered
linear constants of each port in the Bond Graph and the linear system needed to
convert the :math:`\dot{p}_7` and :math:`\dot{p}_{17}` into explicit form due
to the two derivative causality inertia ports is solved numerically before
constructing the two system matrices.

.. code-include:: ../scripts/segway_state_space.m
   :lexer: matlab

The following m-file computes the two inputs. The wind force is specified as a
step function that provides a constant wind force between a start and stop
time. The voltage is specified as a linear function of the four states. Each
state is multiplied by a gain value and summed together to provide "full state
feedback" control. The gain values are chosen using the `LQR method`_ in the
primary script further below. These gain values are supplied to the function.
Note that this assumes it is possible to measure each state directly (which is
an slightly unrealistic assumption, but used for the purposes of this
demonstration).

.. _LQR method: https://en.wikipedia.org/wiki/Linear%E2%80%93quadratic_regulator

.. code-include:: ../scripts/eval_segway_input.m
   :lexer: matlab

The function that computes the derivative of the states then becomes fairly
simple because we have defined the linear system as a state space. I do add an
additional state equation that is necessary if we desire to know the
longitudinal position of the wheel center. This state is called an "ignorable"
coordinate because the dynamics only depend on the velocity of the wheel center
not its position, but it is necessary to integrate the velocity to know this
value.

- :math:`\dot{x}_w = \frac{p_{14}}{I_{14}} = \frac{_{16}r_{15}}{I_{17}}p_{17}`:
  longitudinal momentum of the wheel assembly

.. code-include:: ../scripts/eval_segway_rhs.m
   :lexer: matlab

The next m-file computes several useful outputs. The power draw from the
battery is computed and the Cartesian location of the mass center of the wheel
assembly and the mass center of the person are computed for use in animating
the motion.

.. code-include:: ../scripts/eval_segway_output.m
   :lexer: matlab

Finally, the main script file is shown below. There are these main steps:

1. Define the constant parameters.
2. Calculate the state and input matrices.
3. Calculate the eigenvalues and eigenvectors of the state matrix.
4. Try a simple proportional feedback controller.
5. Try a simple PID feedback controller.
6. Calculate the gains for a full state feedback controller based on LQR.
7. Simulate the motion and save data to a file.
8. Plot the trajectories of the states, inputs, and outputs.

Type ``simulate_segway`` in Octave or Matlab to run the script.

.. code-include:: ../scripts/simulate_segway.m
   :lexer: matlab

The above script generate a ``.mat`` file which stores all of the trajectories
generated from the simulation. The following Python file loads this data and
animates the simulation. The animation can be done in Octave/Matlab but I was
having trouble getting a nice result with Octave, so I just wrote it in Python.
You'll need to install Python, NumPy, SciPy, and matplotlib for this to run. I
recommend installing Anaconda_ to get them all.

Type ``python animate_segway.py`` to run the script from a terminal or command
prompt.

.. _Anaconda: https://www.anaconda.com/distribution/

.. code-include:: ../scripts/animate_segway.py
   :lexer: python

The final resulting animation of the simulation is shown in the GIF below:

.. image:: https://objects-us-east-1.dream.io/eme171/assets/2019/segway.gif
   :align: center
