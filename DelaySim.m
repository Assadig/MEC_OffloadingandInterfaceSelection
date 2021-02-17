% Plot Settings
m= {'+','o','*','x','v','d','^','s','>','<','o'};
plotVar=0;

% Slot settings for each case
DIFS=5;      % Distributed InterFrame Spacing
tColl = 10;  % Number Of Slots Collision b/w stations take up 
tPacket = 20;% Average duration of each packet, same for all stations
tSim = 5*10^6; % Total simulation time in slots
timeColl = 0;% Counter for succesfull tr channel busy duration
timeSucc = 0;% Counter for collision on channel busy duration
c=0;
n=0;

E_Delay = cell(10,2);
E_DelaySim = cell(10,2);

beta = cell(10,2);
betaSim = cell(10,2);
gamma = cell(10,2);
gammaSim = cell(10,2);

S = zeros(10,2);
S_sim = zeros(10,2);
for N = 10:10:50
for k = [7 100]
plotVar = plotVar+1;

timeColl = 0;% Counter for succesfull tr channel busy duration
timeSucc = 0;% Counter for collision on channel busy duration
c=0;
n=0;
%N=100;% Number of Contending Users
%k=7;% Maximum number of attempts for a particular packet

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

[beta{floor(N/10),plotVar},gamma{floor(N/10),plotVar}] = sys_param(k,N);

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

betaSim{floor(N/10),plotVar} = sum(attemptTransmit,1)./bCount;


% Conditional Collision Probability
collSim = totColl/bCount;

%gammaSim = collSim./betaSim;
%errGamma = ((gamma-gammaSim)./gamma)*100;

gammaSim{floor(N/10),plotVar}  = collSim./betaSim{floor(N/10),plotVar};

% Avergae Delay Of System

E_DelaySim{floor(N/10),plotVar} = succDelay(succTime);
E_Delay{floor(N/10),plotVar} = delaySystem(k,N,beta{floor(N/10),plotVar},gamma{floor(N/10),plotVar},tColl + DIFS,tPacket + DIFS,CWmin,CWmax);
% errE_delay{floor(N/10),plot} = ((E_Delay{floor(N/10),plot}-E_DelaySim{floor(N/10),plot})./E_Delay{floor(N/10),plot})*100;

% E_Delay = delaySystem(k,N,beta,gamma,tColl + DIFS,tPacket + DIFS,CWmin,CWmax);
% E_DelaySim = succDelay(succTime);
% errE_delay = ((E_Delay-E_DelaySim)./E_Delay)*100;


% System ThroughPut 

% S_sim = countSucc/n;
% S = throughPutSys(N,beta,tPacket,tPacket+DIFS,tColl+DIFS);

S_sim(floor(N/10),plotVar) = countSucc/n;
S(floor(N/10),plotVar) = throughPutSys(N,beta{floor(N/10),plotVar},tPacket,tPacket+DIFS,tColl+DIFS);


end
plotVar = 0;
end

plotUser = 10;
N_plot = 10:10:50 ;
lSim = length(N_plot);

E_DelayplotUser = zeros(2,lSim);
E_DelayplotUserSim = zeros(2,lSim);

beta_plotUser = zeros(2,lSim);
beta_plotUserSim = zeros(2,lSim);

gamma_plotUser = zeros(2,lSim);
gamma_plotUserSim = zeros(2,lSim);

for x = 1:2
    for v=1:lSim
        E_DelayplotUserSim(x,v) = E_DelaySim{v,x}(plotUser);
        E_DelayplotUser(x,v) = E_Delay{v,x};
        
        beta_plotUserSim(x,v) = betaSim{v,x}(plotUser);
        beta_plotUser(x,v) = beta{v,x};
        
        gamma_plotUserSim(x,v) = gammaSim{v,x}(plotUser);
        gamma_plotUser(x,v) = gamma{v,x};
    end
end

figure(1)

hold all
grid on
plot(N_plot,S(1:end,1),append('-',m{1},'k'),'Linewidth',2,'MarkerSize',12);
plot(N_plot,S_sim(1:end,1),append('-',m{2},'r'),'Linewidth',2,'MarkerSize',12);
legend('Analytical','Simulation','FontSize',10)
annotation('textbox',[0.65,0.4,0.25,0.07],'String',"K(max attempts)= 7")
title('System Throughput','FontSize',16,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
xlabel('Number Of Contending Stations','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
ylabel('System Throughput','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
legend show

figure(2)

hold all
grid on
plot(N_plot,E_DelayplotUser(1,:),append('-',m{1},'k'),'Linewidth',2,'MarkerSize',12);
hold on
plot(N_plot,E_DelayplotUserSim(1,:),append('-',m{2},'r'),'Linewidth',2,'MarkerSize',12);
annotation('textbox',[0.65,0.4,0.25,0.07],'String',"K(max attempts)= 7")
legend('Analytical','Simulation','FontSize',10,'Location','southeast')
title('Average Delay','FontSize',16,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
xlabel('Number Of Contending Users','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
ylabel('Average Delay($E[Delay]$)','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
legend show

figure(3)

hold all
grid on
plot(N_plot,beta_plotUser(1,:),append('-',m{1},'k'),'Linewidth',2,'MarkerSize',12);
plot(N_plot,beta_plotUserSim(1,:),append('-',m{2},'r'),'Linewidth',2,'MarkerSize',12);
annotation('textbox',[0.65,0.4,0.25,0.07],'String',"K(max attempts)= 7")
legend('Analytical','Simulation','FontSize',10)
title('Transmission Probability','FontSize',16,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
xlabel('Number Of Contending Users','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
ylabel('Transmission Probability($\beta$)','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
legend show

figure(4)

hold all
grid on
plot(N_plot,gamma_plotUser(1,:),append('-',m{1},'k'),'Linewidth',2,'MarkerSize',12);
plot(N_plot,gamma_plotUserSim(1,:),append('-',m{2},'r'),'Linewidth',2,'MarkerSize',12);
annotation('textbox',[0.65,0.4,0.25,0.07],'String',"K(max attempts)= 7")
legend('Analytical','Simulation','FontSize',10,'Location','southeast')
title('Conditional Collision Probability','FontSize',16,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
xlabel('Number Of Contending Users','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
ylabel('Conditional Collision Probability($\gamma$)','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
legend show




