//#include <stdio.h>
//#include <iostream>
//#include <fstream>
#define size_A_max 500
#define size_B 16
#define	N size_A_max/size_B
#define size_U1_y  size_B *2


void LUDecompose(float L1Inv[size_B][size_B], float U1Inv[size_B][size_B], int P[size_B][size_B],  float M[size_B][size_B],int size);

void BLock_LU_Inversion( float INV[size_A_max][size_A_max], float inA[size_A_max][size_A_max],  float Linv[size_A_max][size_A_max],  float Uinv[size_A_max][size_A_max], int P_whole[size_A_max][size_A_max], float L1inv[N-1][size_B][size_B], float U1inv[N-1][size_B][size_B], float T[N-1][size_B][size_B], int P[N-1][size_B][size_B], float Sbar[size_A_max][size_B], float temp1[size_A_max][size_B], float temp[size_A_max][size_A_max], float S[size_A_max][size_B], float M2_U3inv[size_B][size_A_max], float TEMP_result[size_A_max][size_A_max], int size_A_original)
{

#pragma HLS INTERFACE m_axi port=INV
#pragma HLS INTERFACE m_axi port=inA
#pragma HLS INTERFACE s_axilite port=size_A_original


	int offset =0;
	int count = 0;
	float M1[size_B][size_B];
	int size_A = size_A_original;

	//Initialization of Uinv .
		for( int i =0; i< size_A_original; i ++)
		{
			for ( int j =0; j < size_A_original; j ++ )
			{
				Uinv[i][j] =0;
			}
		}
	//Initialization of Linv.
		for( int i =0; i< size_A_original; i ++)
		{
			for ( int j =0; j < size_A_original; j ++ )
			{
				Linv[i][j] =0;
			}
		}

	//Initialization of P_whole .
	for( int i =0; i< size_A_original; i ++)
	{
		for ( int j =0; j < size_A_original; j ++ )
		{
			P_whole[i][j] =0;
		}
	}


	while ( size_A > size_B)
	{
		//Assign M1
		for ( int i =0 ; i < size_B ; i++)
		{
#pragma HLS pipeline II=33
			for ( int j = 0; j < size_B ;j++)
			{
				M1[i][j] = inA[i+ offset][j + offset];
                //std::cout<< M1[i][j]<< std::endl;
			}

		}
		// End of Assigning M1

		LUDecompose(L1inv[count],U1inv[count],P[count], M1,size_B);
		float AB_block[size_B][size_B];
		float Bline[size_B];
		int b = size_B;
#pragma HLS ARRAY_RESHAPE variable=AB_block dim=2


	for ( int i_b = 0; i_b < b ; i_b = i_b + b )
	{
		for ( int j_b =0; j_b < b ; j_b = j_b + b)
		{

			for ( int i =0; i < b ; i++) ///ASSIGNMENT TO 0.
			{
				for ( int j = 0; j< b; j++)
				{
					AB_block[i][j] =0;
				}
			}

			for ( int k_b =0; k_b< b ;k_b = k_b +b) ///Innermost Block Multiplication loop.
			{
				for ( int k =0; k< b; k++)
				{
					for ( int j =0; j < b ; j++)
					{
						Bline[j] = L1inv[count][k_b + k][j_b + j];
					}

					for (int i =0; i < b; i++)
					{
						float A_temp = U1inv[count][i_b + i][k_b + k];
						//int A_temp = A[(i_b + i)*n + k_b + k];

#pragma HLS pipeline II=1
						for (int j =0; j < b; j++)
						{
#pragma HLS unroll
							AB_block[i][j] += A_temp * Bline[j];
						}
					}
				}
			}

			for ( int i =0; i < b ; i++) ///ASSIGNMENT TO port C.
			{
#pragma HLS pipeline II=24
				for ( int j = 0; j< b; j++)
				{
					//C[(i_b+i)*p + j_b+ j]= AB_block[i][j];
					T[count][i_b+i][j_b+ j]= AB_block[i][j];
				}
			}
		}
	}


		//float Sbar[size_A_original][size_B];
		for ( int i =0; i< size_A_original; i++)
		{
			for ( int j =0; j< size_B; j++ )
			{
				Sbar[i][j] = 0;
			}
		}

		for ( int i_b = 0; i_b < (size_A-size_B) ; i_b = i_b + b )
			{
				for ( int j_b =0; j_b < size_B ; j_b = j_b + b)
				{

					for ( int i =0; i < b ; i++) ///ASSIGNMENT TO 0.
					{
						for ( int j = 0; j< b; j++)
						{
							AB_block[i][j] =0;
						}
					}

					for ( int k_b =0; k_b< size_B ;k_b = k_b +b) ///Innermost Block Multiplication loop.
					{
						for ( int k =0; k< b; k++)
						{

							for ( int j =0; j < b ; j++)
							{
								Bline[j] = T[count][k_b + k][j_b + j];
							}

							for (int i =0; i < b; i++)
							{
								float A_temp = inA[offset + size_B + i_b + i][k_b + k + offset];
								//int A_temp = A[(i_b + i)*n + k_b + k];

		#pragma HLS pipeline II=1
								for (int j =0; j < b; j++)
								{
		#pragma HLS unroll
									AB_block[i][j] += A_temp * Bline[j];
								}
							}
						}
					}

					for ( int i =0; i < b ; i++) ///ASSIGNMENT TO port C.
					{
		#pragma HLS pipeline II=24
						for ( int j = 0; j< b; j++)
						{
							//C[(i_b+i)*p + j_b+ j]= AB_block[i][j];
							Sbar[i_b + i][j_b + j] = AB_block[i][j];
						}
					}
				}
			}

		for ( int i =0 ; i < (size_A-size_B) ; i++)
		{
#pragma HLS pipeline II=31
			for ( int j = 0; j < size_B ;j++)
			{
				inA[offset + size_B +i][j+ offset] = Sbar[i][j];
			}

		}

		//Sbar * P1 * M2.

	for ( int i_b = 0; i_b < (size_A-size_B) ; i_b = i_b + b )
	{
		for ( int j_b =0; j_b < size_B ; j_b = j_b + b)
		{

			for ( int i =0; i < b ; i++) ///ASSIGNMENT TO 0.
			{
				for ( int j = 0; j< b; j++)
				{
					AB_block[i][j] =0;
				}
			}

			for ( int k_b =0; k_b< size_B ;k_b = k_b +b) ///Innermost Block Multiplication loop.
			{
				for ( int k =0; k< b; k++)
				{

					for ( int j =0; j < b ; j++)
					{
						Bline[j] = P[count][k_b + k][j_b + j];
					}

					for (int i =0; i < b; i++)
					{
						float A_temp = inA[offset +size_B+ i_b + i][k_b + k + offset];
						//int A_temp = A[(i_b + i)*n + k_b + k];

#pragma HLS pipeline II=1
						for (int j =0; j < b; j++)
						{
#pragma HLS unroll
							AB_block[i][j] += A_temp * Bline[j];
						}
					}
				}
			}

			for ( int i =0; i < b ; i++) ///ASSIGNMENT TO port C.
			{
#pragma HLS pipeline II=24
				for ( int j = 0; j< b; j++)
				{
					//C[(i_b+i)*p + j_b+ j]= AB_block[i][j];
					temp1[i_b + i][j_b + j]= AB_block[i][j];
				}
			}
		}
	}

	for ( int i_b = 0; i_b < (size_A-size_B) ; i_b = i_b + b )
		{
			for ( int j_b =0; j_b < (size_A-size_B) ; j_b = j_b + b)
			{

				for ( int i =0; i < b ; i++) ///ASSIGNMENT TO 0.
				{
					for ( int j = 0; j< b; j++)
					{
						AB_block[i][j] =0;
					}
				}

				for ( int k_b =0; k_b< size_B ;k_b = k_b +b) ///Innermost Block Multiplication loop.
				{
					for ( int k =0; k< b; k++)
					{

						for ( int j =0; j < b ; j++)
						{
							Bline[j] = inA[offset +k_b + k][offset + size_B + j_b + j];
						}

						for (int i =0; i < b; i++)
						{
							float A_temp = temp1[i_b + i][k_b +k];
							//int A_temp = A[(i_b + i)*n + k_b + k];

	#pragma HLS pipeline II=1
							for (int j =0; j < b; j++)
							{
	#pragma HLS unroll
								AB_block[i][j] += A_temp * Bline[j];
							}
						}
					}
				}

				for ( int i =0; i < b ; i++) ///ASSIGNMENT TO port C.
				{
	#pragma HLS pipeline II=24
					for ( int j = 0; j< b; j++)
					{
						//C[(i_b+i)*p + j_b+ j]= AB_block[i][j];
						temp[i_b + i][j_b + j]= AB_block[i][j];
					}
				}
			}
		}

	for ( int i_b = 0; i_b < (size_A-size_B) ; i_b = i_b + b )
			{
				for ( int j_b =0; j_b < (size_A-size_B) ; j_b = j_b + b)
				{

					for ( int i =0; i < b ; i++) ///ASSIGNMENT TO 0.
					{
#pragma HLS pipeline II=33
						for ( int j = 0; j< b; j++)
						{
							AB_block[i][j] = inA[offset + size_B +i_b + i][offset + size_B +j_b + j];
						}
					}
					float AB_block_temp[size_B][size_B];
					for ( int i =0; i < b; i++)
					{
#pragma HLS pipeline II=33
						for ( int j =0; j< b; j ++)
						{
							AB_block_temp[i][j] = temp[i_b + i][j_b + j];
						}
					}
					for ( int i = 0; i < b; i++)
					{
#pragma HLS pipeline II=8
						for ( int j=0; j <b ; j++ )
						{
							AB_block[i][j] = AB_block[i][j] - AB_block_temp[i][j];
						}
					}
					for ( int i =0; i < b ; i++) ///ASSIGNMENT TO port C.
					{
		#pragma HLS pipeline II=33
						for ( int j = 0; j< b; j++)
						{
							//C[(i_b+i)*p + j_b+ j]= AB_block[i][j];
							inA[offset + size_B +i_b + i][offset + size_B +j_b + j] = AB_block[i][j];
						}
					}
				}
			}

		offset = offset + size_B;
		count = count +1 ;
		size_A = size_A - size_B;
	}
	int P2[size_B][size_B];
	float L1invfinal[size_B][size_B];
	float U1invfinal[size_B][size_B];
	float Decompfinal[size_B][size_B];

	for ( int i =0; i< size_A; i++)
	{
#pragma HLS pipeline II=33
		for ( int j =0 ; j < size_A ; j++)
		{
			Decompfinal[i][j]= inA[offset + i][offset +j];
		}
	}

	LUDecompose(L1invfinal,U1invfinal,P2, Decompfinal,size_A);
	count = count -1 ;
	while ( size_A < size_A_original )
	{

		//float S[size_A][size_B];
#pragma HLS ARRAY_RESHAPE variable=P2 complete dim=2
		float AB_block[size_B][size_B];
		float Bline[size_B];
		int b = size_B;
		#pragma HLS ARRAY_RESHAPE variable=AB_block dim=2

		for ( int i_b = 0; i_b < size_A ; i_b = i_b + b )
			{
				for ( int j_b =0; j_b < size_B ; j_b = j_b + b)
				{

					for ( int i =0; i < b ; i++) ///ASSIGNMENT TO 0.
					{
						for ( int j = 0; j< b; j++)
						{
							AB_block[i][j] =0;
						}
					}

					for ( int k_b =0; k_b < size_A ;k_b = k_b +b) ///Innermost Block Multiplication loop.
					{
						for ( int k =0; k< b; k++)
						{

							for ( int j =0; j < b ; j++)
							{
								Bline[j] = inA[offset +k_b + k][offset - size_B + j_b + j];
							}

							for (int i =0; i < b; i++)
							{
								float A_temp;
								if ( size_A <= size_B)
									A_temp = P2[i_b + i][k_b + k];
								else
									A_temp = P_whole[offset + i_b + i][offset + k_b + k];
								//int A_temp = A[(i_b + i)*n + k_b + k];
		#pragma HLS pipeline II=1
								for (int j =0; j < b; j++)
								{
		#pragma HLS unroll
									AB_block[i][j] += A_temp * Bline[j];
								}
							}
						}
					}

					for ( int i =0; i < b ; i++) ///ASSIGNMENT TO port C.
					{
		#pragma HLS pipeline II=24
						for ( int j = 0; j< b; j++)
						{
							//C[(i_b+i)*p + j_b+ j]= AB_block[i][j];
							S[i_b + i][j_b + j]= AB_block[i][j];
						}
					}
				}
			}

        //L3inv assignment
		for ( int i = 0; i< size_A; i ++)
		{
			for ( int j = 0; j< size_A; j++)
			{
				if ( size_A <= size_B)//check if this works if inserted before this outer for-loop
                    Linv[offset + i][offset + j] = L1invfinal[i][j];
			}
		}
        //L2inv assignment

			for ( int i_b = 0; i_b < size_A ; i_b = i_b + b )
					{
						for ( int j_b =0; j_b < size_B ; j_b = j_b + b)
						{

							for ( int i =0; i < b ; i++) ///ASSIGNMENT TO 0.
							{
								for ( int j = 0; j< b; j++)
								{
									AB_block[i][j] =0;
								}
							}

							for ( int k_b =0; k_b < size_A ;k_b = k_b +b) ///Innermost Block Multiplication loop.
							{
								for ( int k =0; k< b; k++)
								{

									for ( int j =0; j < b ; j++)
									{
										Bline[j] = -1 * S[k_b + k][j_b + j];
									}

									for (int i =0; i < b; i++)
									{
										float A_temp;
										if ( size_A <= size_B)
											A_temp = L1invfinal[i_b + i][k_b + k];
										else
											A_temp = Linv[offset+i_b + i][offset+k_b + k];
										//int A_temp = A[(i_b + i)*n + k_b + k];
				#pragma HLS pipeline II=1
										for (int j =0; j < b; j++)
										{
				#pragma HLS unroll
											AB_block[i][j] += A_temp * Bline[j];
										}
									}
								}
							}

							for ( int i =0; i < b ; i++) ///ASSIGNMENT TO port C.
							{
				#pragma HLS pipeline II=24
								for ( int j = 0; j< b; j++)
								{
									//C[(i_b+i)*p + j_b+ j]= AB_block[i][j];
									Linv[offset+i_b + i][offset-size_B +j_b + j]= AB_block[i][j];
								}
							}
						}
					}

		float a;
		int temp_var = offset -size_B;
		float storage_temp[size_B][size_B];
        //L1inv assignment
		for ( int i =0; i < size_B ; i ++)
			{
    	#pragma HLS pipeline II=53
				for ( int j = 0 ; j < size_B; j++)
				{

					storage_temp[i][j] = L1inv[count][i][j];
					//a = L1inv[count][i][j];
				}
			}
		for ( int i =0; i < size_B ; i ++)
			{
#pragma HLS pipeline II=53
			for ( int j = 0 ; j < size_B; j++)
				{
					Linv[temp_var+i][temp_var +j] = storage_temp[i][j];

				}
			}



        //U3inv assignment
		for ( int i = 0; i< size_A; i ++)
			{
				for ( int j = 0; j< size_A; j++)
				{
					if( size_A <= size_B)
                        Uinv[offset + i][offset + j] = U1invfinal[i][j];
				}
			}
        //U2inv assignment
		//- T * P1

		float T_P1[size_B][size_B];
		for ( int i_b = 0; i_b < size_B ; i_b = i_b + b )
			{
				for ( int j_b =0; j_b < size_B ; j_b = j_b + b)
				{

					for ( int i =0; i < b ; i++) ///ASSIGNMENT TO 0.
					{
						for ( int j = 0; j< b; j++)
						{
							AB_block[i][j] =0;
						}
					}

					for ( int k_b =0; k_b< size_B ;k_b = k_b +b) ///Innermost Block Multiplication loop.
					{
						for ( int k =0; k< b; k++)
						{

							for ( int j =0; j < b ; j++)
							{
								Bline[j] = P[count][k_b + k][j_b + j];
							}

							for (int i =0; i < b; i++)
							{
								float A_temp =  -1 * T[count][i_b + i][k_b + k];
								//int A_temp = A[(i_b + i)*n + k_b + k];

		#pragma HLS pipeline II=1
								for (int j =0; j < b; j++)
								{
		#pragma HLS unroll
									AB_block[i][j] += A_temp * Bline[j];
								}
							}
						}
					}

					for ( int i =0; i < b ; i++) ///ASSIGNMENT TO port C.
					{
		#pragma HLS pipeline II=24
						for ( int j = 0; j< b; j++)
						{
							//C[(i_b+i)*p + j_b+ j]= AB_block[i][j];
							T_P1[i_b + i][j_b + j]= AB_block[i][j];
						}
					}
				}
			}


				for ( int i_b = 0; i_b < size_B ; i_b = i_b + b )
					{
						for ( int j_b =0; j_b < size_A ; j_b = j_b + b)
						{

							for ( int i =0; i < b ; i++) ///ASSIGNMENT TO 0.
							{
								for ( int j = 0; j< b; j++)
								{
									AB_block[i][j] =0;
								}
							}

							for ( int k_b =0; k_b < size_A ;k_b = k_b +b) ///Innermost Block Multiplication loop.
							{
								for ( int k =0; k< b; k++)
								{
									//float Bline[b];
				//#pragma HLS ARRAY_RESHAPE variable=Bline dim=1
									for ( int j =0; j < b ; j++)
									{
										if( size_A <= size_B)
											Bline[j] = U1invfinal[k_b + k][j_b + j];
										else
											Bline[j] = Uinv[offset + k_b + k][offset + j_b + j];
									}
									for (int i =0; i < b; i++)
									{
										float A_temp;
										A_temp = inA[offset -size_B + i_b + i][offset + k_b + k];
										//int A_temp = A[(i_b + i)*n + k_b + k];
				#pragma HLS pipeline II=1
										for (int j =0; j < b; j++)
										{
				#pragma HLS unroll
											AB_block[i][j] += A_temp * Bline[j];
										}
									}
								}
							}

							for ( int i =0; i < b ; i++) ///ASSIGNMENT TO port C.
							{
				#pragma HLS pipeline II=24
								for ( int j = 0; j< b; j++)
								{
									//C[(i_b+i)*p + j_b+ j]= AB_block[i][j];
									M2_U3inv[i_b + i][j_b + j]= AB_block[i][j];
								}
							}
						}
					}

				for ( int i_b = 0; i_b < size_B ; i_b = i_b + b )
									{
										for ( int j_b =0; j_b < size_A ; j_b = j_b + b)
										{

											for ( int i =0; i < b ; i++) ///ASSIGNMENT TO 0.
											{
												for ( int j = 0; j< b; j++)
												{
													AB_block[i][j] =0;
												}
											}

											for ( int k_b =0; k_b < size_B ;k_b = k_b +b) ///Innermost Block Multiplication loop.
											{
												for ( int k =0; k< b; k++)
												{
													//float Bline[b];
								//#pragma HLS ARRAY_RESHAPE variable=Bline dim=1
													for ( int j =0; j < b ; j++)
													{
															Bline[j] = M2_U3inv[k_b + k][j_b + j];

													}
													for (int i =0; i < b; i++)
													{
														float A_temp;
														A_temp = T_P1[i_b + i][k_b + k];
														//int A_temp = A[(i_b + i)*n + k_b + k];
								#pragma HLS pipeline II=1
														for (int j =0; j < b; j++)
														{
								#pragma HLS unroll
															AB_block[i][j] += A_temp * Bline[j];
														}
													}
												}
											}

											for ( int i =0; i < b ; i++) ///ASSIGNMENT TO port C.
											{
								#pragma HLS pipeline II=24
												for ( int j = 0; j< b; j++)
												{
													//C[(i_b+i)*p + j_b+ j]= AB_block[i][j];
													Uinv[offset -size_B + i_b + i][offset +j_b + j]= AB_block[i][j];
												}
											}
										}
									}


        //U1inv
		for ( int i =0; i < size_B ; i ++)
		{
//#pragma HLS pipeline II=6
#pragma HLS pipeline II=31
			for ( int j = 0 ; j < size_B; j++)
			{
				Uinv[offset-size_B+i][offset-size_B +j] = U1inv[count][i][j];
			}
		}
        //P update
		for ( int i = 0; i< size_B ; i++)
		{
//#pragma HLS pipeline II=6
#pragma HLS pipeline II=33
			for ( int j = 0; j< size_B; j++)
			{
				P_whole[offset - size_B +i][offset - size_B +j] = P[count][i][j];
			}
		}

        for ( int i = 0; i< size_A ; i++)
            {
//#pragma HLS pipeline II=6
                for ( int j = 0; j< size_A; j++)
                {
                	if ( size_A<= size_B)
                	{
                		P_whole[offset  +i][offset +j] = P2[i][j];
                	}
                }
            }

        size_A = size_A + size_B;
		offset = offset - size_B;
		count = count -1 ;
   }
	float AB_block[size_B][size_B];
	float Bline[size_B];
#pragma HLS ARRAY_RESHAPE variable=AB_block dim=2
	int b = size_B;
	for ( int i_b = 0; i_b < size_A_original ; i_b = i_b + b )
		{
			for ( int j_b =0; j_b < size_A_original ; j_b = j_b + b)
			{

				for ( int i =0; i < size_B ; i++) ///ASSIGNMENT TO 0.
				{
					for ( int j = 0; j< b; j++)
					{
						AB_block[i][j] =0;
					}
				}

				for ( int k_b =0; k_b< size_A_original ;k_b = k_b +b) ///Innermost Block Multiplication loop.
				{
					for ( int k =0; k< b; k++)
					{
						//float Bline[b];
	//#pragma HLS ARRAY_RESHAPE variable=Bline dim=1
						for ( int j =0; j < b ; j++)
						{
							if( size_A > size_B)
								Bline[j] = Linv[k_b + k][j_b + j];
						}

						for (int i =0; i < b; i++)
						{
							float A_temp ;
							if( size_A > size_B)
								A_temp = Uinv[i_b + i][k_b + k];
							//int A_temp = A[(i_b + i)*n + k_b + k];

	#pragma HLS pipeline II=1
							for (int j =0; j < b; j++)
							{
	#pragma HLS unroll
							if( size_A > size_B)
								AB_block[i][j] += A_temp * Bline[j];
							}
						}
					}
				}

				for ( int i =0; i < b ; i++) ///ASSIGNMENT TO port C.
				{
	#pragma HLS pipeline II=24
					for ( int j = 0; j< b; j++)
					{
						//C[(i_b+i)*p + j_b+ j]= AB_block[i][j];
						if( size_A > size_B)
							TEMP_result[i_b+i][j_b+ j]= AB_block[i][j];
					}
				}
			}
		}
	for ( int k=0; k< size_A; k++)
	{
		for ( int j =0; j < size_A ; j++)
		{
			if( size_A <= size_B)
				Bline[j] = L1invfinal[k][j];

		}
		for ( int i =0; i< size_A; i++)
		{
			float A_temp ;
			if( size_A <= size_B)
				A_temp = U1invfinal[i][k];
#pragma HLS pipeline II=1
			for ( int j=0; j< size_A; j++)
			{
#pragma HLS unroll
			if( size_A <= size_B)
				TEMP_result[i][j] += A_temp * Bline[j];
			}
		}
	}

	for ( int i_b = 0; i_b < size_A_original ; i_b = i_b + b )
			{
				for ( int j_b =0; j_b < size_A_original ; j_b = j_b + b)
				{

					for ( int i =0; i < size_B ; i++) ///ASSIGNMENT TO 0.
					{
						for ( int j = 0; j< b; j++)
						{
							AB_block[i][j] =0;
						}
					}

					for ( int k_b =0; k_b< size_A_original ;k_b = k_b +b) ///Innermost Block Multiplication loop.
					{

						for ( int k =0; k< b; k++)
						{
							for ( int j =0; j < b ; j++)
							{
								//Bline[j]
								if( size_A > size_B)
									Bline[j] = P_whole[k_b + k][ j_b + j];
							}


							for (int i =0; i < b; i++)
							{
								float A_temp;
								if( size_A > size_B)
									A_temp = TEMP_result[i_b + i][k_b + k];
								//int A_temp = A[(i_b + i)*n + k_b + k];

		#pragma HLS pipeline II=1
								for (int j =0; j < b; j++)
								{
		#pragma HLS unroll
								if( size_A > size_B)
									AB_block[i][j] += A_temp * Bline[j];
								}
							}

						}
					}

					for ( int i =0; i < b ; i++) ///ASSIGNMENT TO port C.
					{
		#pragma HLS pipeline II=24
						for ( int j = 0; j< b; j++)
						{
							//C[(i_b+i)*p + j_b+ j]= AB_block[i][j];
							if( size_A > size_B)
								INV[i_b+i][j_b+ j]= AB_block[i][j];
						}
					}

				}
			}
	for ( int k=0; k< size_A; k++)
		{
			for ( int j =0; j < size_A ; j++)
			{
				if( size_A <= size_B)
					Bline[j] = P2[k][j];

			}
			for ( int i =0; i< size_A; i++)
			{
#pragma HLS pipeline II=18
				float A_temp ;
				if( size_A <= size_B)
					A_temp = TEMP_result[i][k];
//	#pragma HLS pipeline II=1
				for ( int j=0; j< size_A; j++)
				{
//	#pragma HLS unroll
				if( size_A <= size_B)
					INV[i][j] += A_temp * Bline[j];
				}
			}
		}

}
void LUDecompose( float L1Inv[size_B][size_B],  float U1Inv[size_B][size_B], int P[size_B][size_B],  float M[size_B][size_B],int size)
{

	//int m = size_B;
	float A[size_B][size_B];
//#pragma HLS array_partition variable=A dim=0
	int P_temp[size_B][size_B];
//#pragma HLS array_partition variable=P_temp dim=1

	//float * A = M;
	for ( int i = 0; i< size; i ++)
	{
		for ( int j =0; j< size; j++)
		{
			A[i][j] = M[i][j];
			if ( i ==j )
			{
				P_temp[i][j] = 1;
				L1Inv[i][j] =1;
				U1Inv[i][j] =0;
				//L1Inv[i * size_B + j] =1;
				//U1Inv[i * size_B + j] =0;
			}
			else
			{
				P_temp[i][j] = 0;
				L1Inv[i][j] =0;
				U1Inv[i][j] =0;
			}
		}
	}

	for ( int k =0 ;k < size; k++)
	{
		float max;
		max = A[k][k];

		int index = k;
		float swap_row[size_B] ;
#pragma HLS array_partition variable=swap_row dim=0
#pragma HLS array_partition variable=P_temp dim=1
		int swap_row_P[size_B];
		//Swapping /Pivoting
		for( int i = k ; i < size; i++)
		{
			//Finding Maximum value
			if ( A[i][k] > max)
			{
				max = A[i][k];
				index = i;
			}
		}

		for( int j = 0 ; j < size; j++)
		{


			//std::cout << A[index][j];
			swap_row[j] = A[index][j];
			swap_row_P[j] = P_temp[index][j];

			A[index][j] = A[k][j];
			A[k][j] = swap_row[j];

			P_temp[index][j] = P_temp[k][j];
			P_temp[k][j] = swap_row_P[j];
		}
		for ( int i = k+1 ; i < size ; i++)
		{
#pragma HLS unroll
			A[i][k] = A[i][k]/A[k][k];
			for ( int j = k+1 ; j < size; j++ )
			{
#pragma HLS unroll
					A[i][j] = A[i][j] - A[i][k] * A[k][j];
			}
		}

	}
	float U1[size_B][size_U1_y];
	float L1[size_B][size_U1_y];
//#pragma HLS array_partition variable=U1 dim=0

	for ( int i =0; i< size ; i++)
	{
		for ( int j = 0; j < size ; j++)
		{

			if( i==j)
			{
				L1[i][j] = 1;
				U1[i][j] = 0;
			}
			else
			{
				L1[i][j] = 0;
				U1[i][j] = 0;
			}
		}
	}




	for ( int i =0; i< size ; i++)
	{
		for ( int j = 0; j < size ; j++)
		{
			if ( i > j )
			{
				//L1Inv[i*size_B + j] =  - 1 * A[i][j];
				L1[i][j] =  A[i][j];
			}
			else
			{
				U1[i][j] = A[i][j];
			}
		}
	}



	for ( int i =0; i< size ; i++)
	{
		for ( int j = 0; j < size ; j++)
		{
			if (i ==j)
			{
				U1[i][j + size] = 1;
				L1[i][j + size] = 1;
			}
			else
			{
				U1[i][j + size] = 0;
				L1[i][j + size] = 0;
			}
		}

	}


	for ( int i = 0; i< size; i++)
		{
			for ( int k = i+1;k< size; k++ )
			{
#pragma HLS unroll
				for ( int a = i+1; a<(i+size + 1); a++)
				{
#pragma HLS unroll
					  L1[k][a] = L1[k][a] - L1[k][i] * L1[i][a];
				}
				L1[k][i] = 0;
			}
		}


//#pragma HLS array_reshape variable=U1 dim=2
	for ( int i =0; i < size; i++ )
	{
		float temp = U1[i][i];
		for ( int j = ( i + 1 ); j< ( i + 1 +size ) ; j++)
		{
#pragma HLS unroll
			U1[i][j]= U1[i][j] / temp;
		}
		U1[i][i] = 1;
		for ( int k =0; k< i; k++)
		{
#pragma HLS pipeline II=48 // Change here
//#pragma HLS unroll
			for ( int a =0; a<size; a++)
			{
#pragma HLS unroll
				int s = i + 1  + a;
				U1[k][s] = U1[k][s] - U1[k][i] * U1[i][s]; // Change --usage of variable s
			}
			U1[k][i] =0;
		}
	}
	for ( int i =0; i< size ; i++)
		{
			for ( int j = 0; j < size ; j++)
			{
				L1Inv[i][j] = L1[i][size + j];
			}
		}
	//U1inv assignment
	for ( int i =0; i< size ; i++)
	{
		for ( int j = 0; j < size ; j++)
		{
			U1Inv[i][j] = U1[i][size + j];
		}
	}
	//P assignment
		for ( int i =0; i< size ; i++)
		{
#pragma HLS pipeline II=23
			for ( int j = 0; j < size ; j++)
			{
				P[i][j] = P_temp[i][j];
			}
		}
}
