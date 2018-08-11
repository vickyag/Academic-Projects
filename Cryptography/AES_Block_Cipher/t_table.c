#include<stdio.h>


int T0[256] = {0},T1[256],T2[256],T3[256];



/* XOR multiplication source: wiki*/
int mul(int a, int b) {
   int p = 0; /* the product of the multiplication */
	while (a && b) {
            if (b & 1) /* if b is odd, then add the corresponding a to p (final product = sum of all a's corresponding to odd b's) */
                p ^= a; /* since we're in GF(2^m), addition is an XOR */

            if (a & 0x80) /* GF modulo: if a >= 128, then it will overflow when shifted left, so reduce */
                a = (a << 1) ^ 0x1cf; /* XOR with the primitive polynomial x^8 + x^4 + x^3 + x + 1 (0b1_0001_1011) – you can change it but it must be irreducible */
            else
                a <<= 1; /* equivalent to a*2 */
            b >>= 1; /* equivalent to b // 2 */
	}
	return p;
}


/* Subtract two numbers in the GF(2^8) finite field */
int add(int a, int b) {
    return a ^ b;
}

int diffusionMat[4][4] = {
		{2, 3, 1, 1},
		{1, 2, 3, 1},
		{1, 1, 2, 3},
		{3, 1, 1, 2}};

int main(){
	int i, j, temp;

	for(i=0;i<256;i++){
		temp = mul(2, i);
		temp <<= 8;
		temp |= mul(1, i);
		temp <<= 8;
		temp |= mul(1, i);
		temp <<= 8;
		temp |= mul(3, i);
		T0[i] = temp;
	}
	for(i=0;i<256;i++){
		temp = mul(3, i);
		temp <<= 8;
		temp |= mul(2, i);
		temp <<= 8;
		temp |= mul(1, i);
		temp <<= 8;
		temp |= mul(1, i);
		T1[i] = temp;
	}
	for(i=0;i<256;i++){
		temp = mul(1, i);
		temp <<= 8;
		temp |= mul(3, i);
		temp <<= 8;
		temp |= mul(2, i);
		temp <<= 8;
		temp |= mul(1, i);
		T2[i] = temp;
	}
	for(i=0;i<256;i++){
		temp = mul(1, i);
		temp <<= 8;
		temp |= mul(1, i);
		temp <<= 8;
		temp |= mul(3, i);
		temp <<= 8;
		temp |= mul(2, i);
		T3[i] = temp;
	}

	

	for(i=0;i<256;i++){
		if(i%4 == 0)
		printf("\n");
		printf("0x%08x, ", T0[i]);
		
	} 
	printf("\n");printf("\n");printf("\n");
	for(i=0;i<256;i++){
		if(i%4 == 0)
		printf("\n");
		printf("0x%08x, ", T1[i]);
	} 
	printf("\n");printf("\n");printf("\n");
	for(i=0;i<256;i++){
		if(i%4 == 0)
		printf("\n");
		printf("0x%08x, ", T2[i]);
		
	} 
	printf("\n");printf("\n");printf("\n");
	for(i=0;i<256;i++){
		if(i%4 == 0)
		printf("\n");
		printf("0x%08x, ", T3[i]);
	} 

	//printf("%x",mul(1,255));

	/* for(i=0;i<4;i++){
		for(j=0;j<4;j++){
			if(i==0)
				state[i][j] = T0[state[0][j]]>>24 ^ T1[state[1][j]]>>24 ^ T2[state[2][j]]>>24 ^ T3[state[3][j]]>>24;
			if(i==1)
				state[i][j] = (T0[state[0][j]]>>16 & 0xff) ^ (T1[state[1][j]]>>16 & 0xff) ^ (T2[state[2][j]]>>16 & 0xff) ^ (T3[state[3][j]]>>16 & 0xff);
			if(i==2)
				state[i][j] = (T0[state[0][j]]>>8 & 0xff) ^ (T1[state[1][j]]>>8 & 0xff) ^ (T2[state[2][j]]>>8 & 0xff) ^ (T3[state[3][j]]>>8 & 0xff);
			if(i==3)
				state[i][j] = (T0[state[0][j]] & 0xff) ^ (T1[state[1][j]] & 0xff) ^ (T2[state[2][j]] & 0xff) ^ (T3[state[3][j]] & 0xff);

		}
	} */

return 0;
	
}
