m= {'k+','ro','b*','gx','v','d','^','s','>','<','o'};

% 802.11n standards
% Using frame structure of A-MPDU
tSlot = 9*1e-6; % seconds
DIFS = 4; %~slots (34 microseconds)
SIFS = 2; %~slots (16 microseconds)
tPhy = 3; %~slots (24 microseconds) time taken to send physical layer header and preamble
data = 1000*8; %bits per subframe
dataRate = 54*1e6; %bits per second
dataAck = 14*8; % bits
h_mac = 34*8; % MAC header for each subframe
delim = 4*8; % Delimiter bits between each subframe
K = 10; % Number of subframes

lenPacket = K*((h_mac+delim) + data); % Length of data packet including MAc header and delim
tData = ceil(lenPacket/(dataRate*tSlot)); % time to transmit uplink data
tAck = ceil(dataAck/(dataRate*tSlot)); % time to send back ack

lenProcPacket = K/2*((h_mac+delim) + data); % Downlink data 
tProcData =  ceil(lenProcPacket/(dataRate*tSlot)); % time to transmit downlink data
tUL = tPhy+tData+SIFS+tPhy+tAck; % Transmission time to send it to AP
tDL = tPhy+tProcData + SIFS + tPhy + tAck; % Downlink transmission time

tColl = tPhy+tData+DIFS;
% Local and MEC computation time 
cpu_loc = 1e8; % local computation speed cycles/sec
cpu_mec = 1e10; % MEC computation speed cycles/sec
procDen = [737.5]; % cycles per bit
totData = data*K; % bits
totCycles = totData * procDen; % total number of cycles

%Computation time
localComp = ceil(totCycles/(cpu_loc*tSlot));
mecComp = ceil(totCycles/(cpu_mec*tSlot));

rho= 0:0.1:1;
%localComp = 100:100:1000 ;
for z = 1:length(localComp)
for h = 1:length(rho)
N = 10;
k=7;
tSim = 10^7;
p = rho(h);

tLocal = localComp(z);

tColl = 5;
CWmin = 16;
CWmax = 1024;
packetProc = zeros([1,N]);
obsUser = 5;

allUsers = 1:N ;
userInterface = cell(2,1);

offloadDec=rand(1,N);
offloadDec(offloadDec<p) = 1;
offloadDec(offloadDec~=1) =0;

userInterface{1,1} = find(offloadDec);
userInterface{2,1} = setdiff(allUsers,userInterface{1,1},'stable');

N_cont = sum(offloadDec);
N_local=N-N_cont;
tLocal_N = ones(1,N_local)*tLocal;

CW = CWmin*(ones(1,N_cont));
backOff = randi([0 CWmin],1,N_cont);
succFlag = zeros(1,N_cont);
nSuccColl = zeros(1,N_cont);
discardFlag = zeros(1,N_cont);
discardTime = zeros(1,N_cont);
attemptTransmit=zeros(1,N_cont);
succTime_WiFi = zeros(1,N);
succTime_local = zeros(1,N);

timeColl = 0;
timeSucc = 0;
succUser=0;
channel_status=0;
d=0; % Variable that controls the indice for discardTime
c=0;
c_local=0;
n=0;

while n<=tSim
n = n+1;

[backOff,CW,channel_status,succFlag,discardFlag,discardTime,d,nSuccColl,succUser,timeColl,timeSucc] = WiFiSyst(CWmin,CWmax,backOff,CW,succFlag,discardFlag,n,N_cont,k,channel_status,d,discardTime,nSuccColl,tUL,tColl,DIFS,timeColl,timeSucc,succUser);
tLocal_N = tLocal_N-1;

exitUsers_Wifi = [find(discardFlag),find(succFlag)];
exitUsers_Local = find(~tLocal_N);

CW(exitUsers_Wifi) = [];
backOff(exitUsers_Wifi)=[];
succFlag(exitUsers_Wifi) = [];
discardFlag(exitUsers_Wifi) = [];
nSuccColl(exitUsers_Wifi) = [];
tLocal_N(exitUsers_Local) = [];

N_cont = N_cont - length(exitUsers_Wifi);
N_local = N_local - length(exitUsers_Local);

temp = [userInterface{1,1}(exitUsers_Wifi),userInterface{2,1}(exitUsers_Local)];

if(~isempty(userInterface{1,1}(exitUsers_Wifi)))
    c=c+1;
    succTime_WiFi(c,userInterface{1,1}(exitUsers_Wifi)) = n; 
end

if(~isempty(userInterface{2,1}(exitUsers_Local)))
    c_local=c_local+1;
    succTime_local(c_local,userInterface{2,1}(exitUsers_Local)) = n; 
end

userInterface{1,1} = setdiff(userInterface{1,1},userInterface{1,1}(exitUsers_Wifi),'stable');
userInterface{2,1} = setdiff(userInterface{2,1},userInterface{2,1}(exitUsers_Local),'stable');

if(~isempty([exitUsers_Wifi, exitUsers_Local]))
for i=temp 
    x=rand;
    
    if(x<p)
        offloadDec(i) = 1;
    else
        offloadDec(i) = 0;
    end
    if(offloadDec(i) == 1)
        userInterface{1,1} = [userInterface{1,1} i];
        CW = [CW CWmin];
        backOff =[backOff randi([0 CWmin])];
        succFlag = [succFlag 0];
        discardFlag = [discardFlag 0];
        nSuccColl = [nSuccColl 0];
        N_cont = N_cont+1;
    else
        userInterface{2,1} = [userInterface{2,1} i];
        tLocal_N = [tLocal_N tLocal];
        N_local = N_local + 1;
    end
end
end
end

for j = 1:N
    y = succTime_local(:,j);
    y=y(y~=0);
    y1 = succTime_WiFi(:,j);
    y1=y1(y1~=0);
    Y = sort([y ;y1]);
    delay(j) = mean(diff(Y));
end

delay_p(z,h) = mean(delay);
end
end

for x = 1:length(localComp)
figure(1)
hold all
plot(rho,delay_p(x,:),append('-',m{x}),'Linewidth',2,'MarkerSize',12);
%legend(append('Local Computation: ',int2str(localComp(x)),' slots'),'FontSize',10,'Location','best')
l{x} = append(texlabel('T_local ='),int2str(localComp(x)),' slots');
title(append('Probabilistic Policy','(N=',int2str(N),')'),'FontSize',16,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
xlabel('Probability of Offloading($p$)','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
ylabel('Average Delay ($E[Delay]$)','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
end

xlim=get(gca,'XLim');
ylim=get(gca,'YLim');
ht = text(0.95*xlim(1)+ 0.98*xlim(2),0.22*ylim(1)+0.25*ylim(2),'All Wifi');
ht1 = text(0.05*xlim(1)+ 0.02*xlim(2),0.75*ylim(1)+0.78*ylim(2),'All Local');
set(ht,'Rotation',90)
set(ht,'FontSize',12)
set(ht1,'Rotation',270)
set(ht1,'FontSize',12)
legend(l,'FontSize',10,'Location','best')
legend show
grid on