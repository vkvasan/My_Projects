# Readme - 'Block_LU_Inversion'


## Steps for project execution : 
1. Install Vitis HLS\
We have implemented the entire architecture using Vitis HLS tool. Coding in C helped us save significant time in Design and Development of the entire project. Vitis HLS(formerly called Vivado HLS ) is available for free and is installed along with Vivado Design Suite. The link to download is provided here : 

https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vitis.html

Additionally, for guidance ,follow the instructions provided in this website (link given below ) to install Vitis HLS.

https://imperix.com/doc/help/vivado-design-suite-installation

Note: In this project we have used the Vitis HLS 2020.2 version . 

2. Clone and Create a project in Vitis HLS 
```sh
git clone https://github.com/vkvasan/Block_LU_Inversion.git
```	

To open any project in Vitis HLS , type the following command in terminal - 
```sh
source /tools/Xilinx/Vitis_HLS/2020.2/settings64.sh 
```

Following that type

```sh	
vitis_hls
```
Now create a new project and add the source file as 'BLock_LU_Inversion.cpp' . Set the top level function as BLock_LU_Inversion. Addtionally add the testbench file i.e 'BLock_LU_Inversion_tb.cpp'.
Choose the frequency, uncertainity of clock and also your target device for execution ( Details given below in Project Description )
	
2. Run Simulation\
The option to choose ‘run simulation ‘ is present above in the toolbar. The simulations are inherently run by the gcc compiler in Vitis HLS. Make sure that you have that installed in your computer before clicking on -Run Simulation.
	
3. Run Synthesis\ 
For synthesis, choose the option - ‘run synthesis’ from the toolbar menu.

4. Run Co-simulation\
For Co-simulation, choose the option - ‘run synthesis’ from the toolbar menu.

5. Run Export RTL( also mention the Changes to be incorporated )\
For versions ranging from 2014.x through 2021.2, there needs to be an additional path installed to run co-simulation. 

Follow the instructions given in the solutions tab of the following link of Xilinx official website to install the patch : 
 
https://support.xilinx.com/s/article/76960?language=en_US

Note: Make sure you give read and write permissions while copying the files during the installation procedure. 

After the patch is installed, choose ‘Export RTL’ command from the toolbar menu . 
This will result in a zip file containing .xml . 

The Zip file is also present in the repository for reference. 


## Project Description : 

### Configurational Parameters : 
		Clock period : 10ns
		Uncertainty :  2.7ns 
		Product family : virtexuplus
		Board chosen : xcvu11p-flga2577-1-e
### Algorithm : 
In this project , we invert the given matrix using Block LU inversion algorithm. We have written our algorithm based on the Pseudo Algorithm 2 given in paper[1].  

For reference, we have coded our algorithm in Matlab at first .The Matlab code for Block LU based inversion is attached with the 'BlockLUMatlab' zip file of this repository. All intermediate products mentioned in the Matlab file are also synthesized by our Hardware module. 

The entire hardware design consists broadly of two entities - 

a) LUDecompose - This is the IP core responsible for inverting a given Block Matrix . It  is used by the ‘BlockLUInversion’ module in our design. ‘LUDecompose’ module inverts a Block Matrix of size 16 in our design although it could be extended till 30 if needed. 

b) BlockLUInversion - This module is the control unit taking in and using the Inverse results from the ‘LUDecompose’ IP core. Therefore the IP core is called multiple times by this module to completely invert the given input matrix . 

#### Note : 
During the process of invertion ,our hardware design multiplies very large Matrices . So we consider a block based approach. With Block Matrix Multiplication, the total DRAM transfers invovled in multiplying the entire matrix is much smaller than in the case of Non-Blocked Matrix Multiplication. ( Here B is the size of Block )

| Type of Multiplication | Internal Memory | DRAM transfer |
| --------------- | --------------- | --------------- |
| Blocked | 0 | 2*N^3 |
| Non-Blocked | B^2 | 2*N^3/B |

In Block Matrix Multiplication, loop ordering is crucial in conserving the internal memory of FPGA- 
 
For Matrix Multiplication => A*B = C ( A,B,C are Matrices of order N each) 
( Note : Here b depicts the block size ) 

| Loop ordering | Reuse distance of each element of A | Reuse distance of each element of B |
| --------------- | --------------- | --------------- |
| k->i->j | 1 | b |
| k->j->i | b | 1 |
| i->j->k | b | b^2 |



k->i->j and k->j->i use the same amount of memory . But k->i->j accesses the memory row wise whereas the latter accesses column wise. So it's preferred to use k->i->j ordering. 
#### Note : 
There are no interface protocols followed for data transfer between BlockLUinversion and LUDecompose modules. They are internally connected within the FPGA fabric . 

#### Note : 
In our hardware design , we have saved memory space by storing the variable ‘S’ with partially occupying the memory of the input variable  ‘inA’. 

### Interface ports : 

We have kept the ports of input variable - ‘inA’ and output variable ‘INV’ to be of AXI-4 interface.Port 'size_A_original' has an interface of AXI-4 Lite interface. Additionally, intermediate arrays used in Matrix inversion are by default assigned an ‘ap_memory’ interface by the HLS tool.   
### References : 
[1] https://web.njit.edu/~ansari/papers/16IEEEAccess.pdf




