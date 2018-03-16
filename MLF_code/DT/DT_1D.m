function  [d] = DT_1D(f, n) 
% dt of 1d function using squared distance 
    INF_C = 1E20;
    k = 1;
    v(1) = 1;
    z(1) = -INF_C;
    z(2) = INF_C;
    
    for q = 2:n
        s = ( (f(q) + (q-1)^2) - (f(v(k)) + (v(k)-1)^2))/(2*q - 2*v(k));
        while(s < z(k))
            k = k-1;
            s = ( (f(q) + (q-1)^2) - (f(v(k)) + (v(k)-1)^2))/(2*q - 2*v(k));
        end
        k = k + 1;
        v(k) = q;
        z(k) = s;
        z(k+1) = INF_C;
    end
    
    k = 1;
    for q = 1:n
        
        while(z(k+1) < q-1)
            k = k + 1;
        end
        d(q) = (q - v(k))^2 + f(v(k));
    end

end


