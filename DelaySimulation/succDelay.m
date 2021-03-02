function E_delaysim = succDelay(succTime,discardTime)

N = size(succTime,2);
E_delaysim = zeros(1,N);
for i =1:N
    x = succTime(:,i);
    x=x(x~=0);
    dic1 = discardTime(:,i);
    dic1 = dic1(dic1~=0);
    y=[];
    if(~isempty(dic1))
        for h = 1:length(dic1)
            if(h ==1)
                l=x(x<dic1(h));
            elseif(h== length(dic1))
                l=x(x>dic1(h));
            else
                l = x(x(x<dic1(h+1))>dic1(h));
            end
            y = [y; diff(l)];
        end
    else
        y=diff(x);
    end
    E_delaysim(i) = mean(y);
end
end