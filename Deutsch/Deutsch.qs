//An Oracle is a test that verifies an input
//An Oracle in this case is a function of x (f(x))
//In this case x can only take on values of either 1 or 0
//All four possible outcomes are as follows: 
//Constant: f(0) = 0, f(1) = 0
//Constant: f(0) = 1, f(1) = 1
//Balanced: f(0) = 0, f(1) = 1
//Balanced: f(0) = 1, f(1) = 0
//Thus we can group these four outcomes into two catagories; Constant or Balanced
//Classically you would need two queries to confirm what catagory a function like this would fall into
//In other words you would have to input both possible values of x individually and record the output
//The Deutsch problem is a simple demonstration of how quantum parallelism can speed up a problem such as this
//This code will show whether a function is balanced or constant with only a single query
namespace Deutsch 
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;

    operation query() : Unit
    {
        using ( (queryQ, targetQ) = (Qubit(), Qubit()) )
        {
            let fx = [RandomInt(2), RandomInt(2)];  //This will randomly generate any possible f(x)
            
            H(queryQ);   //this is simular to being able to input both values of x at the same time
            X(targetQ); H(targetQ);

            if (fx[0] == 0 and fx[1] == 0) {ConstantZero(queryQ, targetQ); Message($"The function was Constant: {fx}");}
            elif (fx[0] == 1 and fx[1] == 1) {ConstantOne(queryQ, targetQ); Message($"The function was Constant: {fx}");}
            elif (fx[0] == 0 and fx[1] == 1) {BalancedSame(queryQ, targetQ); Message($"The function was Balanced: {fx}");}
            elif (fx[0] == 1 and fx[1] == 0) {BalancedDiff(queryQ, targetQ); Message($"The function was Balanced: {fx}");}

            let resultFinal = MeasureQ(queryQ, targetQ);
            if (resultFinal == 0) {Message($"The function is Constant: {resultFinal}");}
            elif (resultFinal == 1) {Message($"The function is Balanced: {resultFinal}");}
            
            Reset(queryQ); Reset(targetQ);
        }
    }
    operation ConstantZero(queryQ : Qubit, targetQ : Qubit) : Unit
    {
        //No gates needed for this case
    }
    operation ConstantOne(queryQ : Qubit, targetQ : Qubit) : Unit
    {
        X(targetQ);
    }
    operation BalancedSame(queryQ : Qubit, targetQ : Qubit) : Unit
    {
        CNOT(queryQ, targetQ);  // in this case f(x) = x
    }
    operation BalancedDiff(queryQ : Qubit, targetQ : Qubit) : Unit
    {
        // f(x) = NOT(x)
        X(targetQ);
        CNOT(queryQ, targetQ);
    }
    operation MeasureQ(queryQ : Qubit, targetQ : Qubit) : Int
    {
        //Apply H gate to query qubit before measuring 
        //If the query qubit is zero, f(x) is constant
        //If the query qubit is one, f(x) is balanced

        H(queryQ);
        return ResultArrayAsInt([M(queryQ)]);
    }

}