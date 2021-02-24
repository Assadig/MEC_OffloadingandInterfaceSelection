function [nSuccColl,CW,discardTime,d,discardFlag] = succColl(k,attemptTransmit,i,nSuccColl,CW,CWmin,discardTime,d,discardFlag)
    currColl = attemptTransmit(i,:);
    userColl = find(currColl);
    for j = userColl
        prevInd = flip(find(attemptTransmit(1:i,j)));
        if(length(prevInd)>1)
            collFlag = (sum(attemptTransmit(prevInd(2),:))>1);
            if(collFlag == 1)
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
        else
            nSuccColl(j)=0;
        end
    end
end