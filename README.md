# R-WMMSE
This is the code implementation for the R-WMMSE algorithm.  
CLick here for the original paper link:  
[Rethinking WMMSE: Can Its Complexity Scale Linearly With the Number of BS Antennas?](https://ieeexplore.ieee.org/document/10054084/)  
# Code Introduction
WMMSE.m : The main function for the [WMMSE algorithm](https://ieeexplore.ieee.org/document/5756489/).  
R-WMMSE.m : The main function for the [R-WMMSE algorithm](https://ieeexplore.ieee.org/document/10054084/).    
find_U1.m : The function for finding the U in each iteration of the WMMSE algorithm.  
find_W1.m : The function for finding the W in each iteration of the WMMSE algorithm.  
find_V1.m : The function for finding the V in each iteration of the WMMSE algorithm.  
sumrate.m : The function for computing the sum rate in the WMMSE algorithm.  
Test_R_WMMSE.m : This is a function used to test R_WMMSE performance, enter the required parameters and the function would return the number of iterations, running time and sum rate information  

find_U.m : The function for finding the U in each iteration of the R-WMMSE algorithm.  
find_W1.m : The function for finding the W in each iteration of the R-WMMSE algorithm.  
find_X.m : The function for finding the X in each iteration of the R-WMMSE algorithm.  
sumrate.m : The function for computing the sum rate in the R-WMMSE algorithm.  
Test_WMMSE.m : This is a function used to test WMMSE performance, enter the required parameters and the function would return the number of iterations, running time and sum rate information  

Test.m : This script is used to access the performance gap between the two algorithms WMMSE and R-WMMSE. The indicators include running time, number of iterations and final sum rate. Currently this script only supports the simulation scenario of a single base station.  
figs : The folder that stores the results in different scenario configurations.  
# Result
Run Test.m in matlab and get the following figures, one for running time and the other for sum rate:  
![Running time comparison](/figs/result1.png)  
![Sum rate comparison](/figs/result2.png)  

# Computer specs：
CPU : 13600K (5.3 GHz, 6 Performance-cores, 8 Efficient-cores)  
Motherboard : ASUS PRIME Z790-P
DRAM : 64G DDR5 6000MHz (KINGBANK)  
Disk : 2T (SHPP41-2000GM)  
GPU : NVIDIA Geforce RTX 4070    
OS : Windows 11 Pro (23H2)  
MATLAB Version : R2023a  

