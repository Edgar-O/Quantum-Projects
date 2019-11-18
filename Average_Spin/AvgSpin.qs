namespace AverageSpin {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;

    operation Spin() : Unit
    {
        let spin = GetAverage(PI()/2.0, 100);
        Message($"Average spin is: {spin}");
    }
    operation GetAverage(angle : Double, iterations : Int) : Double
    {
        mutable n = 0;
        using (q = Qubit()) 
        {
            for (i in 1..iterations)
            {
                Rx(angle, q);
                set n += 2 * ResultArrayAsInt([M(q)]) -1 ;

                Reset(q);                
            }
        }
        //return the average spin
        //with a rotation of Pi/2 the average spin should be close to zero
        return IntAsDouble(n)/IntAsDouble(iterations);
    }
}