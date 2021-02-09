function [x] = Test(k,N)
x=@test;
    function F = test(x)
    CWmin = 16;
    CWmax = 1024;
    E_R = 0;
    E_X = 0;
        for i = 0:k
            E_R = E_R + x^i;
            if (CWmin*(2^i) < CWmax)
            E_X = E_X + ((CWmin*(2^i))/2)*(x^i);
            else
            E_X = E_X + (CWmax/2)*(x^i); 
            end
        end
     F = 1-(1-(E_R/E_X))^N;
    end
end
