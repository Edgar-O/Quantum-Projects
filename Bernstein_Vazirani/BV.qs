//Bernstein-Vazirani oracle takes in a string of inputs "x" and produces an output f(x)
//The output is dependent the interaction between the inputs and a hidden string "a" within the oracle
//This interaction can be expressed with the following function:
//f(x) = a dot x (mod 2); the output is equal to the dot product of "a" and "x" mod 2
//This code seeks to extract the hidden string of bits "a" with only a single query of the oracle
namespace BernsteinV
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;

    operation finda() : Unit 
    {
        using ( (query, target) = (Qubit[5], Qubit()) )
        {
            PrepState(query, target);
            BVOracle(query, target);
            ExtractString(query);

            ResetAll(query); Reset(target);
        }
    }
    operation PrepState(query : Qubit[], target : Qubit) : Unit
    {
        //This operation applied a Hamadard transform to the input and set up the target qubit
        for ( i in 0..4) {H(query[i]);}
        X(target);
        H(target);
    }
    operation BVOracle(query : Qubit[], target : Qubit) : Unit 
    {
        //"a" is the hidden string in the oracle that we want to extract
        let a = [RandomInt(2), RandomInt(2), RandomInt(2), RandomInt(2), RandomInt(2)];
        Message($"Hidden string a: {a}");

        //This will flip the target qubit when both "a" and "x" are equal to 1
        for (i in 0..4) 
        {
            if (a[i] == 1) {CNOT(query[i], target);}
        }
    }
    operation ExtractString(query : Qubit[]) : Unit
    {
        //We extract the hidden string of bits by applying another Hamadard transform to the output query qubits
        //Since all the information is within the query qubits, the target qubit doesn't need to be measured
        mutable a = new Int[5];

        for (i in 0..4) {H(query[i]); set a w/= i <- ResultArrayAsInt([M(query[i])]);}
        //Decoded String should be identical to the hidden string
        Message($"Decoded String: {a}");
    }
}