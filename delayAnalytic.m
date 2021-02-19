function [E_delay] = delayAnalytic(k,N,beta,gamma,Tcoll,Tsucc,CWmin,CWmax)
    % delayAnalytic : Returns the average delay value experienced by a user
    % Parameters :
    %   k : Maximum number of attempts allowed for a pacjet by a user
    %   N : Number of contending users
    %   beta : transmission probability
    %   gamma : Conditional collision probability
    %   Tcoll : Time the channel is occupied during a collision
    %   Tsucc : Time the channel is occupied during successfull tr
    %   CWmin : Minimum contention window size
    %   CWmax : Maximum contention window size
    % Return Variables :
    %   E_Delay = Average Delay for an user in the above system
    
    E_delay =0; % Initialising the average delay variable for a selected user
    CW = (2.^(0:k))*CWmin;  % Creating the CW vector for all the k attempts
    CW(CW>CWmax) = CWmax; % Capping the maximum valye at CWmax
    b_mean = (CW)./(2); % Initialising the mean value vector
    Pa = 1-((1-beta)^(N-1)); % Probability of attemoting to trasmit for N-1 users
    Ps = ((N-1)*beta*(1-beta)^(N-2))/Pa; % Successfull tr prob for the N-1 users
    
    Trc = (1-beta)^(N-1) + Pa*Ps*(Tsucc) + Pa*(1-Ps)*(Tcoll); % Renewal time for a particular selected user
    for i=0:k % For all the attempts
        E_delay = E_delay + (sum(b_mean(1:i+1))*Trc + i*(Tcoll) + (Tsucc))*(gamma^i)*(1-gamma);  % Delay expression 
    end
    
end