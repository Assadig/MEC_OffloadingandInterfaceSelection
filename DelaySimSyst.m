timeColl = 0;% Counter for succesfull tr channel busy duration
timeSucc = 0;% Counter for collision on channel busy duration
c=0; % Variable to keep track of indices of succTime
N=50;% Number of Contending Users
k=7;% Maximum number of attempts for a particular packet

channel_busy = 0; % Indication of channel stae 0:idle, 1:coll, 2:succ
attemptTransmit = zeros(tSim,N); %Transmission attempt of each user for all time


CWmin = 16;
CWmax = 1024;
CW= repmat(CWmin,1,N);
backOff = randi([0 CWmin],1,N);
nSuccColl = zeros(1,N); % Variable that keeps track of successive coll for all users
totColl = zeros(1,N);   % Total number of collisions
succTime = zeros(1,N);  % Time at which successful tr happened

countSucc = 0;
bCount = 0;
%[beta,gamma] = sys_param(k,N);

[beta,gamma] = sys_param(k,N);

while n <= (tSim-(tPacket+DIFS))
 n= n+1;
 if(channel_busy == 0)
   bCount = bCount + 1;
   
   for j=1:N
       if(backOff(j) ~= 0)
           backOff(j) = backOff(j)-1;
       elseif(backOff(j)==0)
           attemptTransmit(n,j) = 1;
       end
    end
 end
   
   if(channel_busy == 1)
      n = n+(timeColl-1); 
      channel_busy=0;
   elseif(channel_busy == 2)
      n = n+(timeSucc-1); 
      channel_busy=0;
   end
   
   if(sum(attemptTransmit(n,:))>1)
    channel_busy = 1;
    timeColl= (tColl + DIFS);
    CW(attemptTransmit(n,:)==1) = 2*CW(attemptTransmit(n,:)==1);
    CW(CW>1024) = 1024;
    totColl(attemptTransmit(n,:)==1) = totColl(attemptTransmit(n,:)==1) + 1;
    
    nSuccColl = succColl(k,attemptTransmit,n,nSuccColl);
    CW(nSuccColl==k) = CWmin;
    for l = find(attemptTransmit(n,:)==1)
        backOff(l) = randi([0 CW(l)]);
    end
   elseif(sum(attemptTransmit(n,:)) == 1)
    countSucc = countSucc+tPacket;
    c = c+1;
    channel_busy = 2;
    timeSucc = (tPacket + DIFS);
    CW(attemptTransmit(n,:)==1)= CWmin;
    succTime(c,:)= (attemptTransmit(n,:))*n ;
    backOff(attemptTransmit(n,:)==1) = randi([0 CWmin]);
   end
end

% Transmission Attempt
totTransmitAttempt =sum(attemptTransmit,1);

% betaSim = sum(attemptTransmit,1)./bCount;
% errBeta = ((beta-betaSim)./beta)*100 ;

betaSim = sum(attemptTransmit,1)./bCount;


% Conditional Collision Probability
collSim = totColl/bCount;

%gammaSim = collSim./betaSim;
%errGamma = ((gamma-gammaSim)./gamma)*100;

gammaSim  = collSim./betaSim{floor(N/10),plotVar};

% Avergae Delay Of System

E_DelaySim = succDelay(succTime);
E_Delay = delayAnalytic(k,N,beta{floor(N/10),plotVar},gamma{floor(N/10),plotVar},tColl + DIFS,tPacket + DIFS,CWmin,CWmax);
% errE_delay{floor(N/10),plot} = ((E_Delay{floor(N/10),plot}-E_DelaySim{floor(N/10),plot})./E_Delay{floor(N/10),plot})*100;

% E_Delay = delaySystem(k,N,beta,gamma,tColl + DIFS,tPacket + DIFS,CWmin,CWmax);
% E_DelaySim = succDelay(succTime);
% errE_delay = ((E_Delay-E_DelaySim)./E_Delay)*100;


% System ThroughPut 

% S_sim = countSucc/n;
% S = throughPutSys(N,beta,tPacket,tPacket+DIFS,tColl+DIFS);

S_sim = countSucc/n;
S = throughPutSys(N,beta{floor(N/10),plotVar},tPacket,tPacket+DIFS,tColl+DIFS);
