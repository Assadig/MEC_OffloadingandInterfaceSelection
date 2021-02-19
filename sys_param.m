function [beta, gamma] = sys_param(k,N)
% Fixed Point Analysis taken from Prof. Anurags Kumar paper

CWmin = 16;
CWmax = 1024;

x0= [0,0];
x = fsolve(@nonLin, x0);

gamma = x(2);
beta = 1-((1-gamma)^(1/(N-1)));
    function F = nonLin(x)
    E_R = 0;
    E_X = 0;
        for i = 0:k
            E_R = E_R + x(2)^i; % Getting the average number attempts until k
            if (CWmin*(2^i) < CWmax)
            E_X = E_X + ((CWmin*(2^i))/2)*(x(2)^i); % Average duration 
            else
            E_X = E_X + (CWmax/2)*(x(2)^i); 
            end
        end
    F(1) = x(2) - (1-(1-(E_R/E_X))^(N-1));
    F(2) = x(1) - x(2);
    end

end
