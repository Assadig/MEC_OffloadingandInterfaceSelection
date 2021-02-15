% Plot Settings
m= {'+','o','*','x','v','d','^','s','>','<','o'};
plot=0;

% Slot settings for each case
DIFS=5;      % Distributed InterFrame Spacing
tColl = 10;  % Number Of Slots Collision b/w stations take up 
tPacket = 20;% Average duration of each packet, same for all stations
tSim = 10^7; % Total simulation time in slots
timeColl = 0;% Counter for succesfull tr channel busy duration
timeSucc = 0;% Counter for collision on channel busy duration

%E_Delay = cell(10,2);
%E_DelaySim = cell(10,2);
%errE_delay = cell(10,2);
%for N = 10:10:100
%for k = [7 100]
%plot = plot+1;

N=30;% Number of Contending Users
k=10;% Maximum number of attempts for a particular packet

channel_busy = 0; % Indication of channel stae 0:idle, 1:coll, 2:succ
attemptTransmit = zeros(tSim,N); %Transmission attempt of each user for all time
backOff = -1*ones(1,N);

CWmin = 16;
CWmax = 1024;
CW= repmat(CWmin,1,N);

nSuccColl = zeros(1,N); % Variable that keeps track of successive coll for all users
totColl = zeros(1,N);   % Total number of collisions
succTime = zeros(1,N);  % Time at which successful tr happened

countSucc = 0;
bCount = 0;
[beta,gamma] = sys_param(k,N);

for i=1:tSim
%  n = mod(i,10^6);
%  if(n == 0)
%      n=1;
%  end
 n=i;
 if(channel_busy == 0)
     bCount = bCount + 1;
   for j=1:N
       if(backOff(j) == -1)
           backOff(j) = randi([0 CW(j)]);
       elseif(backOff(j) ~= 0)
           backOff(j) = backOff(j)-1;
       elseif(backOff(j)==0)
           attemptTransmit(n,j) = 1;
       end
    end
 end
   
   if(channel_busy == 1)
       timeColl = timeColl-1;
       if(timeColl == 0)
           channel_busy=0;
       end
   elseif(channel_busy == 2)
       timeSucc = timeSucc-1;
       if(timeSucc == 0)
           channel_busy=0;
       end
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
    channel_busy = 2;
    timeSucc = (tPacket + DIFS);
    CW(attemptTransmit(n,:)==1)= CWmin;
    succTime(countSucc,:)= (attemptTransmit(n,:))*i ;
    backOff(attemptTransmit(n,:)==1) = randi([0 CWmin]);
   end
end

% Transmission Attempt
totTransmitAttempt =sum(attemptTransmit,1);
betaSim = sum(attemptTransmit,1)./bCount;
errBeta = ((beta-betaSim)./beta)*100 ;

% Conditional Collision Probability
collSim = totColl/bCount;
gammaSim = collSim./betaSim;
errGamma = ((gamma-gammaSim)./gamma)*100;

% Avergae Delay Of System
%E_DelaySim{floor(N/10),plot} = succDelay(succTime);
%E_Delay{floor(N/10),plot} = delaySystem(k,N,beta,gamma,tColl + DIFS,tSucc + DIFS,CWmin,CWmax);
%errE_delay{floor(N/10),plot} = ((E_Delay{floor(N/10),plot}-E_DelaySim{floor(N/10),plot})./E_Delay{floor(N/10),plot})*100;
E_Delay = delaySystem(k,N,beta,gamma,tColl + DIFS,tPacket + DIFS,CWmin,CWmax);
E_DelaySim = succDelay(succTime);
errE_delay = ((E_Delay-E_DelaySim)./E_Delay)*100;


% System ThroughPut 
S_sim = countSucc/tSim;
S = throughPutSys(N,beta,tPacket,tPacket+DIFS,tColl+DIFS);


%end
%plot = 0;
%end


