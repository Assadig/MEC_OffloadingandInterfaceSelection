function E_delaysim = succDelay(succTime)

N = size(succTime,2);
E_delaysim = zeros(1,N);
for i =1:N
    x = succTime(:,i);
    x=x(x~=0);
    E_delaysim(i) = mean(diff(x));
end
end