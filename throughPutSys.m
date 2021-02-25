function S = throughPutSys(N,beta,tPacket,tSucc,tColl)
    
% Function calculates the system throughput for a given N 

% Arguemnts :
% N : Number Of Contending users
% beta : Transmission probability
% tPacket : Average duration of a packet
% tSucc : Average duration the channel is busy for a successfull tr
% tColl : Duration the channel is busy when a collision occurs

% Return :
% S : Analytical solution for system throughput

    Pa = 1-((1-beta)^(N));
    Ps = ((N)*beta*(1-beta)^(N-1))/Pa;
    
    S = (Ps*Pa*tPacket)/(1 + Ps*Pa*tSucc + Pa*(1-Ps)*tColl);
end