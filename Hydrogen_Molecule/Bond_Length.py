import qsharp
from HydrogenMolecule import HydrogenEntanglement
from scipy.optimize import minimize
import numpy as np
import matplotlib.pyplot as plt

# Define the electron interaction energies at each bond length
coeffs = [[2.8489, 0.5678, -1.4508, 0.6799, 0.0791, 0.0791],
            [1.1182, 0.4754, -0.9145, 0.6438, 0.0825, 0.0825],
            [0.4808, 0.3937, -0.5950, 0.6025, 0.0870, 0.0870],
            [0.1626, 0.3288, -0.3915, 0.5616, 0.0925, 0.0925],
            [-0.0172, 0.2779, -0.2550, 0.5235, 0.0986, 0.0986],
            [-0.1253, 0.2374, -0.1603, 0.4892, 0.1050, 0.1050],
            [-0.1927, 0.2048, -0.0929, 0.4588, 0.1116, 0.1116],
            [-0.2355, 0.1782, -0.0442, 0.4323, 0.1181, 0.1181],
            [-0.2632, 0.1565, -0.0088, 0.4094, 0.1241, 0.1241],
            [-0.2812, 0.1390, 0.0171, 0.3898, 0.1297, 0.1297],
            [-0.2934, 0.1251, 0.0359, 0.3730, 0.1347, 0.1347],
            [-0.3018, 0.1142, 0.0495, 0.3586, 0.1392, 0.1392],
            [-0.3125, 0.0997, 0.0665, 0.3354, 0.1467, 0.1467],
            [-0.3135, 0.0984, 0.0679, 0.3329, 0.1475, 0.1475]]

# Define an objective function that evaluates HydrogenEnergy
def objective(x, coeffs):
    return HydrogenEntanglement.simulate(parameter = x[0], iterations = 100, coeff = coeffs)

# Define an empty array and minimize the energy at each bond length
# Minimized energy from each bond length becomes a component in the array
min = [0]*14
for i in range(14):
    result = minimize(objective, 0.0, args=(coeffs[i]), method='Powell')
    #print(result.fun)
    min[i] = float(result.fun)
    
# Make an array for bond length from 0.2 to 2.8 angstroms
length_range = np.linspace(0.0, 2.8, 14)
#print(min)

# Graph energies vs. bond lengths
plt.xlabel('Bond Length [angstroms]')
plt.ylabel('Minimum energy')
plt.plot(length_range, min)
plt.show()