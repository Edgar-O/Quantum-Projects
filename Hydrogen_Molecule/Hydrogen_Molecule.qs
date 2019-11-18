

namespace HydrogenMolecule 
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Measurement;

    operation hydrogen() : Unit
    {
        //The only parameter we change is a rotation around the Z axis
        let parameter = 0.0;

        // The Hamiltonian for the bond energy of a hydrogen molecule when transformed into an Ising model equals:
        // H = a + h0*z0 + h1*z1 + jx(x0*x1) + jy(y0*y1) + jz(z0*z1)
        // the components of coeff are the energy coefficients a, h0, h1, jx, jy, and jz respectively
        let coeff = [0.2252, 0.3435, -0.4347, 0.5716, 0.0910, 0.0910];

        let energy = HydrogenEntanglement(parameter, 50, coeff);
        Message($"Energy: {energy}");
    }
    operation Parameterize(q : Qubit[], parameter : Double) : Unit 
    {
        // sets up the entanglement between two qubits and applies the parameter 
        X(q[0]);
        Rx(-PI()/2.0, q[0]);
        Ry(PI()/2.0, q[1]);
        CNOT(q[1], q[0]);
        Rz(parameter, q[0]);

        // unentangles qubits gets them ready to be measured
        CNOT(q[1], q[0]);
        Rx(PI()/2.0, q[0]);
        Ry(-PI()/2.0, q[1]);    
    }
    operation HydrogenEntanglement (parameter : Double, iterations : Int, coeff : Double[]) : Double
    {
        mutable sum = 0.0;

        // creats a list with two Double components
        // z,y,x = [0,0]
        // These are the spin values for two electrons.
        // Electron spins can align or anti-align along any of the three cartesian axis
        mutable z = new Double[2];
        mutable x = new Double[2];
        mutable y = new Double[2];

        using ( q = Qubit[2] ) {
            // Allocate an array of two qubits whose states represented by complex vectors will be mapped to two freely rotating electrons
            for (iter in 1..iterations) {
                // Rotate the state of each qubit
                Parameterize(q, parameter);

                // For each qubit, measure the state along the x axis and convert it to a spin value of 1 or -1
                // Convert again into a Double, then replace the corresponding i component in mutable list x[i]
                for (i in 0..1) {set x w/= i <- IntAsDouble(2 * ResultArrayAsInt([MResetX(q[i])]) - 1);}
                //Message($"x is: {x}");

                // Measurements collapse the qubit state to the axis it was measured in
                // The state of each qubit will have to be roated again before measuring along a different axis
                Parameterize(q, parameter);

                for (i in 0..1) {set y w/= i <- IntAsDouble(2 * ResultArrayAsInt([MResetY(q[i])]) - 1);}
                //Message($"y is: {y}");

                Parameterize(q, parameter);

                for (i in 0..1) {set z w/= i <- IntAsDouble(2 * ResultArrayAsInt([MResetZ(q[i])]) - 1);}
                //Message($"z is: {z}");

                // Calculate the total energy from the spin values
                // Energy Hamiltonian transformed into an Ising model
                let energy = coeff[0] + coeff[1] * z[0] + coeff[2] * z[1] + coeff[3] * z[0] * z[1] + coeff[4] * x[0] * x[1] + coeff[5] * y[0] * y[1];
                set sum += energy;
            }
        }
        // The average energy = sum of the energies + all the iterations
        //sum is already a Double
        return sum/IntAsDouble(iterations);
    }
}
