namespace Superdense 
{
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;
    //Alice and Bob prepare a Bell State, takes one qubit each and seperate
    //Alice wants to send Bob 2-bits of information.
    //She must do some operations on her qubit and physically send her qubit to Bob
    //Bob must then measure both qubits and extract Alice's message
    operation Sent() : Unit
    {
        //Generates a uniformly sampled random integer greater than or equal to zero and less than a provided upper bound
        //in this case, a random number either zero or one
        let message = [RandomInt(2), RandomInt(2)];
        Message($"Message sent: {message}");

        using ( (AliceQ, BobQ) = (Qubit(), Qubit()) )
        {
            PrepareBell(AliceQ, BobQ);

            Encode(AliceQ, message);

            Decode(AliceQ, BobQ);

            Reset(AliceQ); Reset(BobQ);
        }
    }
    operation PrepareBell(AliceQ : Qubit, BobQ : Qubit) : Unit
    {
        H(AliceQ);
        CNOT(AliceQ, BobQ);
    }
    operation Encode(AliceQ : Qubit, message : Int[]) : Unit
    //Here we want to encode a 2-bit message 00,01,10,or 11
    //we want to encode this in the entangled state of Alice's and Bob qubits
    {
        if (message[0] == 0 and message[1] == 0)
        {
        }
        elif (message[0] == 1 and message[1] == 0)
        {
            X(AliceQ);
        }
        elif (message[0] == 0 and message[1] == 1)
        {
            Z(AliceQ);
        }
        elif(message[0] == 1 and message[1] == 1)
        {
            Z(AliceQ);
            X(AliceQ);
        }
    }
    operation Decode(AliceQ : Qubit, BobQ : Qubit) : Unit
    {
        //this operation decode's Alices message after Bob physically receives her qubit
        //before Bob measures the qubits, he must first untangle the qubits and apply the H gate to Alice's qubit
        CNOT(AliceQ, BobQ);
        H(AliceQ);

        //ResultArrayAsInt in this case convers zero into 0 and one into 1
        //must have first imported the following library: Microsoft.Quantum.Convert
        let resultAlice = ResultArrayAsInt([M(AliceQ)]);
        let resultBob = ResultArrayAsInt([M(BobQ)]);
        Message($"Bob measures: Alice's qubit = {resultAlice}, Bob's qubit = {resultBob}");

        //the following extracts Alice's message based on what Bob measures for each qubit
        if (resultAlice == 0 and resultBob == 0)
        {
            Message($"Message Received: 00");
        }
        elif (resultAlice == 0 and resultBob == 1)
        {
            Message($"Message Received: 10");
        }
        elif (resultAlice == 1 and resultBob == 0)
        {
            Message($"Message Received: 01");
        }
        elif (resultAlice == 1 and resultBob == 1)
        {
            Message($"Message Received: 11");
        }
    }
}







