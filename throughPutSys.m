function S = throughPutSys(N,beta,tPacket,tSucc,tColl)
    
    Pa = 1-((1-beta)^(N));
    Ps = ((N)*beta*(1-beta)^(N-1))/Pa;
    
    S = (Ps*Pa*tPacket)/(1 + Ps*Pa*tSucc + Pa*(1-Ps)*tColl);
end