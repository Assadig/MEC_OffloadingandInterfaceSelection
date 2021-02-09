function E_delay = delaySystem(k,N,beta,gamma,Tcoll,Tsucc,CWmin,CWmax)
    E_delay =0;
    CW = (2.^(0:k))*CWmin;
    CW(CW>CWmax) = CWmax;
    b_mean = CW/2;
    Pa = 1-((1-beta)^N);
    Ps = ((N-1)*beta*(1-beta)^(N-2))/Pa;
    
    Trc = (1-beta)^(N-1) + Pa*Ps*Tsucc + Pa*(1-Ps)*Tcoll;
    for i=0:k
        E_delay = E_delay + (sum(b_mean(1:i+1)*Trc + i*Tcoll + Tsucc))*(gamma^i)*(1-gamma);
    end
end