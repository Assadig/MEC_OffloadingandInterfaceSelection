# DelaySimulation

This repository is the simulation of the Channel Sensing Multiple Access / Collision Avoidance (CSMA/CA) protocol with exponential backoff process for the 802.11 WiFi system.
We assume that there is only one Access Point (AP) serving <img src="https://render.githubusercontent.com/render/math?math=N"> users all of which are contending to access the channel. Channel conditions are ideal and probability of erroneous
transmission is zero. Under these assumptions the entire system is simulated and the correspondance of the analytical and simulated model are based on the following system parameters :

1. Transmission Probability <img src="https://render.githubusercontent.com/render/math?math=(\beta)">
1. Conditional Collision Probability <img src="https://render.githubusercontent.com/render/math?math=(\gamma)">
1. System Throughput <img src="https://render.githubusercontent.com/render/math?math=(S)">
1. Average Delay <img src="https://render.githubusercontent.com/render/math?math=(E[Delay])">

The analytical solutions for the above parameters are based on the work by: 
>[1] *A. Kumar, E. Altman, D. Miorandi, and M. Goyal*, **New insights from a fixed point analysis of single cell IEEE 802.11 WLANs,** in Proc. IEEE Infocom, Mar. 2005, pp. 1550–1561  

### Running the code:
```
DelaySim.m
```
This is the main file which creates the plots for the above system parameters for both the analytical and simulated solutions. Two parameters can be varied <img src="https://render.githubusercontent.com/render/math?math=N">, number of contending users and <img src="https://render.githubusercontent.com/render/math?math=k">, maximum number of collsion attempts for a packet before being discarded.
The main file calls `DelaySimSyst.m` for actually computing the above system parameters for every pair of <img src="https://render.githubusercontent.com/render/math?math=N"> and <img src="https://render.githubusercontent.com/render/math?math=k"> values.
