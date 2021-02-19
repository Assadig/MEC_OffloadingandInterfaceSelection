function nSuccColl = succColl(k,attemptTransmit,nSuccColl,succFlag)
    userColl = find(attemptTransmit);
    for j = userColl
        if(succFlag(j) == 0)
            if(nSuccColl(j) < k)
                nSuccColl(j) = nSuccColl(j) + 1;
            else
                nSuccColl(j) = 0;
            end
        else
            nSuccColl(j) = 0;
        end
    end
end