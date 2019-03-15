import numpy as np
from scipy.io import loadmat
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from matplotlib.patches import Circle

dat = loadmat('segway-sim-data.mat', squeeze_me=True)

d = float(dat['p']['d'])
ts = dat['ts']
us = dat['us']
xs = dat['xs']
ys = dat['ys']

max_force = us.max()


def update_line(i, person, wheel, wind):
    wheel.center = (ys[i, 0], ys[i, 2])
    # s = r*theta, theta = s/r
    wheel.angle = -np.rad2deg(xs[i, 4]/0.2)
    person.set_data([ys[i, 0], ys[i, 1]],
                    [ys[i, 2], ys[i, 3]])
    wind.set_data([ys[i, 1], ys[i, 1] - us[i, 1]/max_force],
                  [ys[i, 3], ys[i, 3]])
    return person, wheel, wind

fig, ax = plt.subplots()

wheel = Circle((0.0, 0.2), radius=0.2, linestyle='--', linewidth=3,
               edgecolor='k')
ax.add_patch(wheel)

person, = ax.plot([], [], 'k', linewidth=2)

wind, = ax.plot([ys[0, 1], ys[0, 1] - us[0, 1]/max_force],
                [ys[0, 3], ys[0, 3]],
                color='r', linewidth=4, marker="<", markersize=10)

ax.set_ylim(0.0, max(ys[:, 3]) + 0.2)
ax.set_xlim(min(ys[:, 1]) - 0.4/2, max(ys[:, 1]) + 0.4/2)
ax.set_aspect('equal')

line_ani = animation.FuncAnimation(fig, update_line, len(ts),
                                   fargs=(person, wheel, wind), interval=0.1)

plt.show()
