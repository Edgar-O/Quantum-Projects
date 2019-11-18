import qsharp

import numpy as np
import matplotlib.pyplot as plt
from AverageSpin import GetAverage

# create a list of 20 angles from 0 to 2pi
angle_range = np.linspace(0, 2*np.pi, 20)
data = [0]*20


for i in range(20):
    # angle is the qubit rotation around x axis
    # Iterations is the number of times the qubit is rotated and measured
    data[i] = GetAverage.simulate(angle = angle_range[i], iterations = 1000)


# print the angle of rotation vs. average spin value
# The average spin value should be -1 at angles 0 and 2pi
# The average spin value should be +1 at angle pi
print(data)
plt.xlabel('Angle [radians]')
plt.ylabel('Average value')
plt.plot(angle_range, data)
plt.show()