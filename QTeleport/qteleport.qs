namespace Teleport 
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;

    operation tele() : Unit
    {
        //AQ = Alice's qubit, SQ = Shared qubit, BQ = Bob's qubit
        using ( (AQ, SQ, BQ) = (Qubit(), Qubit(), Qubit()) )
        {
            H(AQ);

            // Collapse the state of Alice's qubit randomly and report
            let AliceInit = M(AQ);
            Message($"Initial Alice state: {AliceInit}");

            PrepShared(SQ, BQ);

            let message = AliceMeasured(AQ, SQ);
            Message($"Alice measured: {message}");

        
            TransferToBob(BQ, message);
            Reset(AQ); Reset(SQ); Reset(BQ);
        }
    }
    operation PrepShared(SQ : Qubit, BQ : Qubit) : Unit
    {
        H(SQ);
        CNOT(SQ, BQ);
    }
    operation AliceMeasured(AQ : Qubit, SQ : Qubit) : Int[]
    {
        CNOT(AQ, SQ);
        H(AQ);
        let resultA = M(AQ);
        let resultS = M(SQ);
        return [ ResultArrayAsInt([resultA]), ResultArrayAsInt([resultS]) ];
    }
    operation TransferToBob(BQ : Qubit, message : Int[]) : Unit
    {
        if (message[0] == 0 and message[1] == 0) {Message($"Message Received: 00");}

        elif (message[0] == 0 and message[1] == 1)
        {
            Message($"Message Received: 10");
            X(BQ);
        }
        elif (message[0] == 1 and message[1] == 0)
        {
            Message($"Message Received: 01");
            Z(BQ);
        }
        elif (message[0] == 1 and message[1] == 1)
        {
            Message($"Message Received: 11");
            Z(BQ);
            X(BQ);
        }

        let resultB = M(BQ);
        Message($"Bob measured: {resultB}");
    }
}

