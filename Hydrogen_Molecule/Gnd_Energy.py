import qsharp

from HydrogenMolecule import HydrogenEntanglement
#hydrogen.simulate()

from scipy.optimize import minimize

# Electron interaction energies for a typical Hydrogen molecule, in atomic units (Hartrees)
#coeffs = [6.1280037, 9.34711039, -11.8287886, 15.5540271, 2.4762359, 2.4762359]
coeffs = [0.2252, 0.3435, -0.4347, 0.5716, 0.091, 0.091]

# Define an objective function that evaluates HydrogenEnergy
def objective(x):
    #print(x)
    # input (x) gets converted to list by minimize
    return HydrogenEntanglement.simulate(parameter = x[0], iterations = 100, coeff = coeffs)

# Define a starting parameter
starting_parameter = 0.0

# Call a classical minimizer to find the lowest energy
result = minimize(objective, starting_parameter, method = 'Powell')

print("Minimum energy:", result.fun)
print("Minimum parameter:", result.x)