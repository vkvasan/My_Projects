#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>



#define size_A_max 500
#define size_B 16
#define	N size_A_max/size_B
#define size_U1_y  size_B *2


void BLock_LU_Inversion( float INV[size_A_max][size_A_max], float inA[size_A_max][size_A_max],  float Linv[size_A_max][size_A_max],  float Uinv[size_A_max][size_A_max], int P_whole[size_A_max][size_A_max], float L1inv[N-1][size_B][size_B], float U1inv[N-1][size_B][size_B], float T[N-1][size_B][size_B], int P[N-1][size_B][size_B], float Sbar[size_A_max][size_B], float temp1[size_A_max][size_B], float temp[size_A_max][size_A_max], float S[size_A_max][size_B], float M2_U3inv[size_B][size_A_max], float TEMP_result[size_A_max][size_A_max], int size_A_original);


int main(void)
{
	int size_A_original = 8;
	float INV[size_A_max][size_A_max];
	float inA[size_A_max][size_A_max];
	float Linv[size_A_max][size_A_max];
	float Uinv[size_A_max][size_A_max];
	int P_whole[size_A_max][size_A_max];
	float L1inv[N-1][size_B][size_B];
	float U1inv[N-1][size_B][size_B];
	float T[N-1][size_B][size_B];
	int P[N-1][size_B][size_B];
	float Sbar[size_A_max][size_B];
	float temp1[size_A_max][size_B];
	float temp[size_A_max][size_A_max];
	float S[size_A_max][size_B];
	float M2_U3inv[size_B][size_A_max];
	float TEMP_result[size_A_max][size_A_max];


for ( int i =0; i< size_A_original; i++)
{
	for ( int j =0; j< size_A_original ; j++)
	{
		inA[i][j] = int(rand())%100;
		//A[i][j] = 0;
	}
}

for ( int i =0; i< size_A_original; i++)
{
	for ( int j =0; j< size_A_original ; j++)
	{
		printf("%f,",inA[i][j]);
		//A[i][j] = 0;
	}
	printf("\n");
}


BLock_LU_Inversion( INV,inA, Linv, Uinv,P_whole,L1inv,U1inv, T,P,Sbar,temp1,temp,S,M2_U3inv,TEMP_result,size_A_original);


printf("\n");
printf("\n Start of Inverse of IP");
printf("\n");

for ( int i =0; i< size_A_original; i++)
{
	for ( int j =0; j< size_A_original ; j++)
	{
		printf("%f,",INV[i][j]);
		//A[i][j] = 0;
	}
	printf("\n");
}

printf("\n END of Inverse of IP");

    return 0;
}
