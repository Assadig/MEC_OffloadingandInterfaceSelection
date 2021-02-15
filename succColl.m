function nSuccColl = succColl(k,attemptTransmit,i,nSuccColl)
    currColl = attemptTransmit(i,:);
    userColl = find(currColl);
    for j = userColl
        prevInd = flip(find(attemptTransmit(1:i,j)));
        if(length(prevInd)>1)
            collFlag = (sum(attemptTransmit(prevInd(2),:))>1);
            if(nSuccColl(j) < (k-1))
                if(collFlag == 1)
                    nSuccColl(j) = nSuccColl(j) +1;
                else
                    nSuccColl(j) = 0;
                end
            else
                nSuccColl(j) = 0;
            end
        else
            nSuccColl(j)=0;
        end
    end
end