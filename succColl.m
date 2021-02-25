function [nSuccColl,CW,discardTime,d,discardFlag] = succColl(k,attemptTransmit,nSuccColl,succFlag,i,CW,CWmin,discardTime,d,discardFlag)
    userColl = find(attemptTransmit);
    for j = userColl
        if(succFlag(j) == 0)
            if(nSuccColl(j) < (k-1))
                nSuccColl(j) = nSuccColl(j) +1;
                if(nSuccColl(j) == (k-1))
                    nSuccColl(j) = 0;
                    CW(j) = CWmin;
                    d=d+1;
                    discardTime(d,j) = i; 
                    discardFlag(j) = 1;
                end
            end
        else
            nSuccColl(j) = 0;     
        end
    end
end