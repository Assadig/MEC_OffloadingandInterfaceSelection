
micro_sec = 10^-6;
tSlot=20*micro_sec;
DIFS=5;
tColl = 10;
tSucc = 20;
tSim = 10^6;
timeColl = 0;
timeSucc = 0;
N=100; % Number of Contending Users
k=5; % Maximum number of attempts for a particular packet

channel_busy = 0;
attemptTransmit = zeros(tSim,N);
backOff = -1*ones(1,N);
totColl = zeros(1,N);
CWmin = 16;
CWmax = 1024;
CW= repmat(CWmin,1,N);
nSuccColl = zeros(1,N);

[beta,gamma] = sys_param(k,N);
E_Delay = delaySystem(k,N,beta,gamma,tColl + DIFS,tSucc + DIFS,CWmin,CWmax);

for i=1:tSim
 if(channel_busy == 0)
   for j=1:N
       if(backOff(j) == -1)
           backOff(j) = randi([0 CW(j)]);
       elseif(backOff(j) ~= 0)
           backOff(j) = backOff(j)-1;
       elseif(backOff(j)==0)
           attemptTransmit(i,j) = 1;
       end
    end
 end
   
   if(channel_busy == 1)
       if(timeColl == 0)
           channel_busy=0;
       else
           timeColl = timeColl-1;
       end
   elseif(channel_busy == 2)
       if(timeSucc == 0)
           channel_busy=0;
       else
           timeSucc = timeSucc-1;
       end
   end
   
   if(sum(attemptTransmit(i,:))>1)
    channel_busy = 1;
    timeColl= (tColl + DIFS);
    CW(attemptTransmit(i,:)==1) = 2*CW(attemptTransmit(i,:)==1);
    CW(CW>1024) = 1024;
    totColl(attemptTransmit(i,:)==1) = totColl(attemptTransmit(i,:)==1) + 1;
    
    nSuccColl = succColl(attemptTransmit);
    
    for k = find(attemptTransmit(i,:)==1)
        backOff(k) = randi([0 CW(k)]);
    end
   elseif(sum(attemptTransmit(i,:)) == 1)
    channel_busy = 2;
    timeSucc = (tSucc + DIFS);
    CW(attemptTransmit(i,:)==1)= CWmin;
    backOff(attemptTransmit(i,:)==1) = randi([0 CW(attemptTransmit(i,:)==1)]);
   end
end

betaSim = sum(attemptTransmit,1)./tSim;
collSim = totColl/tSim;
gammaSim = collSim./betaSim;

errBeta = ((beta-betaSim)./beta)*100 ;
errGamma = ((gamma-gammaSim)./gamma)*100;

E_DelaySim = meanDelay(attemptTransmit);

errE_delay = ((E_Delay-E_DelaySim)./E_Delay)*100;
