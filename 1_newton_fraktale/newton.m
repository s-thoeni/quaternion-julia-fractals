function x = newton( f, df, x0, tolerance, maxIterations )
    f = inline(f);
    df = inline(df);
    x(1) = x0 - (f(x0)/df(x0));
    ex(1) = abs(x(1)-x0);
    k = 2;
    
    while (ex(k-1) >= tolerance) && (k <= maxIterations)
        x(k) = x(k-1) - (f(x(k-1))/df(x(k-1)));
        ex(k) = abs(x(k)-x(k-1));
        k = k+1;
    end    
end