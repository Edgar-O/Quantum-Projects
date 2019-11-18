import qsharp

from Ising_Model import SpinEnergy
from scipy.optimize import minimize
from random import uniform
progress = []

# Define an objective function that calls the SpinEnergy operation from Q#
def objective(x):
    #print(x.tolist())
    result = SpinEnergy.simulate(parameter = x.tolist(), iterations = 200,  j = -1, h = 100)
    # Record the energy to keep track of the optimization
    progress.append(result)
    return result
    
# Define a random starting parameter from 0 to pi
starting_parameters = [uniform(0,3.14), uniform(0,3.14), uniform(0,3.14)]

# Call the minimize function with the Powell classical optimizer method
result = minimize(objective, starting_parameters, method = 'Powell')

# Print the results
print("Minimum energy:", result.fun)
print("Minimum parameters:", result.x)

# Plot Energy vs. number of evaluations from minimize
import matplotlib.pyplot as plt
plt.plot(progress)
plt.xlabel("Number of energy evaluations")
plt.ylabel("Energy")
plt.show()