function [S,S_sim,E_Delay,E_DelaySim,beta,betaSim,gamma,gammaSim] = DelaySimSyst(k,N,tSim)

%N=50;% Number of Contending Users
%k=7;% Maximum number of attempts for a particular packet
%tSim = 10^6; % Simulation time for the entire system
DIFS=5;      % Distributed InterFrame Spacing
tColl = 10;  % Number Of Slots Collision b/w stations take up 
tPacket = 20;% Average duration of each packet, same for all stations

channel_status = 0; % Indication of channel stae 0:idle, 1:coll, 2:succ
attemptTransmit = zeros(1,N); %Transmission attempt of each user for all time

n=0; % Time indice
c=0; % Variable to keep track of indices of succTime

CWmin = 16; % Minimum size of contention window
CWmax = 1024; % Maximum size of contention window
CW= repmat(CWmin,1,N); % Intialising contention window for all users
backOff = randi([0 CWmin],1,N); % Random uniform selection of backoff from CW

nSuccColl = zeros(1,N); % Variable that keeps track of successive coll for all users
totColl = zeros(1,N);   % Total number of collisions for all users
succTime = zeros(1,N);  % Time at which successful tr happened
succFlag = zeros(1,N);

countSucc = 0; % Total number of successful transmisions in the system
bCount = zeros(1,N); % Variable that stores the total time the system is in backoff
b = zeros(1,N);
R_packet = zeros(1,N);
R = zeros(1,N);

[beta,gamma] = sys_param(k,N); % Analytical solution for transmission prob and collision prob


while n <= (tSim-(tPacket+DIFS)) % While time indice is lesser than maximum tSim
 n= n+1; % Update time slot indice after each loop
 attemptTransmit = zeros(1,N);
 if(channel_status == 0) % Checking if channel is idle
   
   for j=1:N % For each user
       if(succFlag(j)==1 || nSuccColl(j)==(k-1))
           bCount(j) = bCount(j) + b(j);
           R(j) = R(j) + R_packet(j);
           b(j)=0;
           R_packet(j) =0;
           succFlag(j) = 2;
       end
       if(backOff(j) ~= 0) % If the backOff counter is not zero
           backOff(j) = backOff(j)-1; % Decrement counter  by one
           b(j) = b(j) + 1; % Backoff for each packet for all users
       elseif(backOff(j)==0) % If backOff counter is zero
           attemptTransmit(j) = 1; % Then attempt transmission
           R_packet(j) = R_packet(j) +1;
       end
    end
 end
   
   if(channel_status == 1) % If the channel is busy due to collison
      n = n+(tColl+DIFS-1);% Fast forward time indice by Tcoll slots
      channel_status=0; % Set channel status to idle again
   elseif(channel_status == 2)% If the channel is busy due to successfull tr
      n = n+(tPacket+DIFS-1); % Fast forward time indice by Tsucc slots
      channel_status=0; % Set the channel status to idle again
   end
   
   if(sum(attemptTransmit(:))>1) % If more than one person has attempted to tr
    channel_status = 1; % Collision has occured hence channel status is set to 1
    
    CW(attemptTransmit==1) = 2*CW(attemptTransmit==1); % Change the size of CW to twice the prev size
    CW(CW>CWmax) = CWmax; % Set maximum size of CW to CWmax
    
    totColl(attemptTransmit==1) = totColl(attemptTransmit==1) + 1; % Increment total collison for those users by one
    nSuccColl = succColl(k,attemptTransmit,nSuccColl,succFlag); % Updating the successive collision number for all users
    succFlag(attemptTransmit==1) = 0;
    CW(nSuccColl==(k-1)) = CWmin; %If k successive collisions have happened then the packet is discarded and CW 
                              %for that user is reset to CWmin
    for l = find(attemptTransmit==1) % For all those users who have collided
        backOff(l) = randi([0 CW(l)]); % Uniformly sample the backOff window from the new CW size
    end
    
   elseif(sum(attemptTransmit) == 1) % If only one user has attempted 
    countSucc = countSucc+tPacket; % Then update successfull transmitted slots
    succFlag(attemptTransmit == 1) = 1;
    c = c+1; % Update the succTime indice
    channel_status = 2; % Update the channel status to tr succesfull busy
    CW(attemptTransmit==1)= CWmin; % Reset the CW to CWmin
    succTime(c,:)= (attemptTransmit)*n ; % Record the time indice in which succesfull tr happened
    backOff(attemptTransmit==1) = randi([0 CWmin]); % Sample new backOff window from the updated CW which is CWmin
   end
end

% Transmission Attempt
%totTransmitAttempt =sum(attemptTransmit,1);

% betaSim = sum(attemptTransmit,1)./bCount;
% errBeta = ((beta-betaSim)./beta)*100 ;

betaSim = R./bCount;


% Conditional Collision Probability
%collSim = totColl./bCount;

%gammaSim = collSim./betaSim;
%errGamma = ((gamma-gammaSim)./gamma)*100;

gammaSim  = totColl./R;

% Avergae Delay Of System

E_DelaySim = succDelay(succTime);
E_Delay = delayAnalytic(k,N,beta,gamma,tColl + DIFS,tPacket + DIFS,CWmin,CWmax);


% System ThroughPut 

S_sim = countSucc/n;
S = throughPutSys(N,beta,tPacket,tPacket+DIFS,tColl+DIFS);
end
