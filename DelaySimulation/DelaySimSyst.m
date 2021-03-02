function [S,S_sim,E_Delay,E_DelaySim,beta,betaSim,gamma,gammaSim] = DelaySimSyst(k,N,tSim)

% Function which calculates the system parameters by taking in :
% Arguments-
% k : Maximum number of collision attempts for a packet
% N : Number of Users
% tSim : Simulation in slots
% Returns-
% S : Analytical throughput
% S_sim : Simulated throughput
% E_DelaySim : Array of simulated average delay for each user
% E_Delay : Analytical delay
% beta : Analytical solution for transmission probability
% betaSim : Array of attempt probability for all users
% gamma : Analytical solution for conditional collision probability
% gammaSim : Array of collision probability for all users


DIFS=5;      % Distributed InterFrame Spacing
tColl = 10;  % Number Of Slots Collision b/w stations take up 
tPacket = 20;% Average duration of each packet, same for all stations

channel_status = 0; % Indication of channel stae 0:idle, 1:coll, 2:succ
attemptTransmit = zeros(1,N); %Transmission attempt of each user for all time

n=0; % Time indice
c=0; % Variable to keep track of indices of succTime
d=0; % Variable to keep track of indices of discardTime

CWmin = 16; % Minimum size of contention window
CWmax = 1024; % Maximum size of contention window
CW= repmat(CWmin,1,N); % Intialising contention window for all users
backOff = randi([0 CWmin],1,N); % Random uniform selection of backoff from CW

nSuccColl = zeros(1,N); % Variable that keeps track of successive coll for all users
totColl = zeros(1,N);   % Total number of collisions for all users
succTime = zeros(1,N);  % Time at which successful tr happened
succFlag = zeros(1,N);  % Flag variable for each user to indicate succ tr
discardTime = zeros(1,N); % Matrix to store time at which packets are discarded for each user
discardFlag = zeros(1,N); % Flag variable for each user to indicate discarded packet

countSucc = 0; % Total number of successful transmisions in the system
bCount = zeros(1,N); % Variable that stores the total time the system is in backoff
b = zeros(1,N); % backOff time for a particular packet
R_packet = zeros(1,N); % Number of attempts for a particular packet
R = zeros(1,N);% Total number of attempts for all the packets

[beta,gamma] = sys_param(k,N); % Analytical solution for transmission prob and collision prob


while n <= (tSim-(tPacket+DIFS)) % While time indice is lesser than maximum tSim
 n= n+1; % Update time slot indice after each loop
 attemptTransmit = zeros(1,N); % Refresh attempt variable for each user
 if(channel_status == 0) % Checking if channel is idle
   
   for j=1:N % For each user
       if(succFlag(j)==1 || discardFlag(j) == 1) % If a particular packet has been succ tr or discarded then
           bCount(j) = bCount(j) + b(j); % Update the total backoff counter
           R(j) = R(j) + R_packet(j); % Update the total number of attempts
           b(j)=0; % Reset backoff counter for new packet
           R_packet(j) =0; % Reset attempt counter for new attempt
           succFlag(j) = 2; % Change succFlag to a different number other than zero so that it doesnt enter this loop,its not set to zero since that happens during a collsion
           discardFlag(j) = 0;% Reset discardFlag since bCount and R has been updated for that packet
       end
       if(backOff(j) ~= 0) % If the backOff counter is not zero
           backOff(j) = backOff(j)-1; % Decrement counter  by one
           b(j) = b(j) + 1; % Backoff for each packet for all users
       elseif(backOff(j)==0) % If backOff counter is zero
           attemptTransmit(j) = 1; % Then attempt transmission
           R_packet(j) = R_packet(j) +1; % Increase attempt for that packet for that particular user
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
    [nSuccColl,CW,discardTime,d,discardFlag] = succColl(k,attemptTransmit,nSuccColl,succFlag,n,CW,CWmin,discardTime,d,discardFlag); % Updating the successive collision number for all users
    succFlag(attemptTransmit==1) = 0; % Resetting succFlag for those users since the latest packet has encountered a collison
    CW(nSuccColl==(k-1)) = CWmin; % If k successive collisions have happened then the packet is discarded and CW 
                                  % for that user is reset to CWmin
    for l = find(attemptTransmit==1) % For all those users who have collided
        backOff(l) = randi([0 CW(l)]); % Uniformly sample the backOff window from the new CW size
    end
    
   elseif(sum(attemptTransmit) == 1) % If only one user has attempted 
    countSucc = countSucc+tPacket; % Then update successfull transmitted slots
    succFlag(attemptTransmit == 1) = 1; % Update the succFlag for that user since latest packet has succesfully transferred
    c = c+1; % Update the succTime indice
    channel_status = 2; % Update the channel status to tr succesfull busy
    CW(attemptTransmit==1)= CWmin; % Reset the CW to CWmin
    succTime(c,:)= (attemptTransmit)*n ; % Record the time indice in which succesfull tr happened
    backOff(attemptTransmit==1) = randi([0 CWmin]); % Sample new backOff window from the updated CW which is CWmin
   end
end

% Transmission Attempt
betaSim = R./bCount; % (Mean value of R / Mean value of bCount) but since both are being divided by the same number of samples
                     % We can directly write the total sum for both which is R/bCount
% Conditional Collision Probability
gammaSim  = totColl./R; % Defined as out of how many attempts have I encountered collisions ?

% Avergae Delay Of System

E_DelaySim = succDelay(succTime,discardTime); % Time between two successive packet transmissions provided no packet has been discarded in the middle
E_Delay = delayAnalytic(k,N,beta,gamma,tColl + DIFS,tPacket + DIFS,CWmin,CWmax); % Analytical solution with the above assumption 


% System ThroughPut 

S_sim = countSucc/n; % Out of the total slots which was simulated how many of those were used for actual packet tr
S = throughPutSys(N,beta,tPacket,tPacket+DIFS,tColl+DIFS); % Analytical solution for the throughput
end
