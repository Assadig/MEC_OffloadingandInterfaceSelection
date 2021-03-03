N = 50;
k=7;
p=0.1;
tSim = 10^6;

tLocal = 60;
tPacket = 20;
DIFS = 5;
tColl = 10;
CWmin = 16;
CWmax = 1024;
packetProc = zeros([1,N]);
obsUser = 5;

insert = @(a, x, n)cat(2,  x(1:n), a, x(n+1:end));
offloadDec=rand(1,N);
offloadDec(offloadDec<p) = 1;
offloadDec(offloadDec~=1) =0;
N_cont = sum(offloadDec);

CW = CWmin*(ones(1,N_cont));
backOff = randi([0 CWmin],1,N_cont);
succFlag = zeros(1,N_cont);
nSuccColl = zeros(1,N_cont);
discardFlag = zeros(1,N_cont);
discardTime = zeros(1,N_cont);
attemptTransmit=zeros(1,N_cont);

timeColl = 0;
timeSucc = 0;
succUser=0;
channel_status=0;
d=0; % Variable that controls the indice for discardTime
c=0;
n=0;

N_local=N-N_cont;
tLocal_N = ones(1,N_local)*tLocal;

while n<=tSim
n = n+1;

[backOff,CW,channel_status,succFlag,discardFlag,discardTime,d,nSuccColl,succUser,timeColl,timeSucc] = WiFiSyst(CWmin,CWmax,backOff,CW,succFlag,discardFlag,n,N_cont,k,channel_status,d,discardTime,nSuccColl,tPacket,tColl,DIFS,timeColl,timeSucc,succUser);
tLocal_N = tLocal_N-1;

exitUsers_Wifi = [find(discardFlag),find(succFlag)];
exitUsers_Local = find(~tLocal_N);

if(sum(succFlag)==1 || sum(exitUsers_Local)==1)
    c=c+1;
    succTime(c)=n;
end

CW(exitUsers_Wifi) = [];
backOff(exitUsers_Wifi)=[];
succFlag(exitUsers_Wifi) = [];
discardFlag(exitUsers_Wifi) = [];
nSuccColl(exitUsers_Wifi) = [];
tLocal_N(exitUsers_Local) = [];

N_cont = N_cont - length(exitUsers_Wifi);
if(~isempty([exitUsers_Wifi, exitUsers_Local]))
for i=[exitUsers_Wifi, exitUsers_Local]
    x=rand;
    if(x<p)
        offloadDec(i) = 1;
    else
        offloadDec(i) = 0;
    end
    if(offloadDec(i) == 1)
        CW = [CW CWmin];
        backOff =[backOff randi([0 CWmin])];
        succFlag = [succFlag 0];
        discardFlag = [discardFlag 0];
        nSuccColl = [nSuccColl 0];
        N_cont = N_cont+1;
    else
        tLocal_N = [tLocal_N tLocal];
    end
end
end
end
