function [backOff,CW,channel_status,succFlag,discardFlag,discardTime,d,nSuccColl,succUser,timeColl,timeSucc] = WiFiSyst(CWmin,CWmax,backOff,CW,succFlag,discardFlag,n,N,k,channel_status,d,discardTime,nSuccColl,tPacket,tColl,DIFS,timeColl,timeSucc,succUser)
attemptTransmit = zeros(1,N); % Refresh attempt variable for each user
if(channel_status == 0) % Checking if channel is idle   
    for j=1:N % For each user
       if(backOff(j) ~= 0) % If the backOff counter is not zero
           backOff(j) = backOff(j)-1; % Decrement counter  by one
       elseif(backOff(j)==0) % If backOff counter is zero
           attemptTransmit(j) = 1; % Then attempt transmission
       end
    end
end
   
if(channel_status == 1) % If the channel is busy due to collison
  timeColl = timeColl-1;% Decrease timecoll variable by one slots
  if(timeColl == 0)
    channel_status=0; % Set channel status to idle 
  end
elseif(channel_status == 2)% If the channel is busy due to successfull tr
  timeSucc = timeSucc-1;% Decrease timeSucc variable by one slots
  if(timeSucc == 0)
    channel_status=0; % Set channel status to idle again
    succFlag(succUser) = 1; % Update the succFlag for that user since latest packet has succesfully transferred
  end
end

if(sum(attemptTransmit(:))>1) % If more than one person has attempted to tr
channel_status = 1; % Collision has occured hence channel status is set to 1
timeColl= tColl+DIFS;

CW(attemptTransmit==1) = 2*CW(attemptTransmit==1); % Change the size of CW to twice the prev size
CW(CW>CWmax) = CWmax; % Set maximum size of CW to CWmax

[nSuccColl,CW,discardTime,d,discardFlag] = succColl(k,attemptTransmit,nSuccColl,succFlag,n,CW,CWmin,discardTime,d,discardFlag); % Updating the successive collision number for all users

for l = find(attemptTransmit==1) % For all those users who have collided
    backOff(l) = randi([0 CW(l)]); % Uniformly sample the backOff window from the new CW size
end

elseif(sum(attemptTransmit) == 1) % If only one user has attempted 
channel_status = 2; % Update the channel status to tr succesfull busy
timeSucc= tPacket+DIFS;
succUser = find(attemptTransmit);
end