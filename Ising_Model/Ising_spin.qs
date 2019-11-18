namespace Ising_Model {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Core;

    operation EnergyCal() : Unit {
    
        let parameter = [0.0, 0.0, 0.0];
        let AvgEnergy = SpinEnergy(parameter, 100, 1, 2);
        Message($"Average energy: {AvgEnergy}");
    }

    operation SpinEnergy(parameter : Double[], iterations : Int, j : Int, h : Int) : Double {
        // The sum of all the energies
        mutable sum = 0;

        // Find the number of qubits to be parameterized
        let nQubits = Length(parameter);

        // Define a mutable array for calculating spins
        //If nQubits = 3, s = [0,0,0]
        mutable s = new Int[nQubits];

        //Allocate an array of n qubits in the state 0
        using ( q = Qubit[nQubits] ) {
            
            for (iter in 1..iterations) {
                // rotates the ith qubit by the ith parameter
                for (i in 0..nQubits - 1) {Rx(parameter[i], q[i]);}

                // replace the value in location s[i] with the spin value measured
                for (i in 0..nQubits - 1) {set s w/= i <- 2 * ResultArrayAsInt([M(q[i])]) - 1;}

                // calculate the sum of the energy in the system and add it to the overall sum
                // j is a constant that defines what type of interaction happens between neighbors
                // j is possitive for each pair of aligned spin neighbors
                // h is a constant that biases the spins towards a particular direction
                // possitive h corresponds to a +1 spin bias
                // negative h towards a -1 spin bias
                set sum += -j * (s[0] * s[1] + s[1] * s[2]) - h * (s[0] + s[1] + s[2]);

                // Reset all the qubits to the 0 state
                ResetAll(q);
            }   
        }
        // Calculate the average energy over all iterations
        return IntAsDouble(sum)/IntAsDouble(iterations);
    }
}