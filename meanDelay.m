function meanD = meanDelay(attemptTransmit)

succIndices = find(sum(attemptTransmit,2)==1);

succTransmit = attemptTransmit(succIndices,:);
meanD = zeros(1,size(attemptTransmit,2));

for i= 1:size(succTransmit,2)
    succTransmit_timeSlots = succIndices(succTransmit(:,i)==1);
    delay = diff(succTransmit_timeSlots);
    meanD(i) = mean(delay);
end