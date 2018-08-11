#include<stdio.h>
#include<stdint.h>
#include<string.h>

int sbox[16][16], sbox1d[256]; // 2D and 1D sbox

/*Function to reverse a string*/
char *strrev(char *str)
{
      char *p1, *p2;

      if (! str || ! *str)
            return str;
      for (p1 = str, p2 = str + strlen(str) - 1; p2 > p1; ++p1, --p2)
      {
            *p1 ^= *p2;
            *p2 ^= *p1;
            *p1 ^= *p2;
      }
      return str;
}

/* Converts binary string "bin" to a decimal integer "num" */
int bin2dec(char bin[]){ 
	int num = 0;
	for(int i=0;i<strlen(bin);i++)
		num = 2*num + bin[i]-'0';	
	return num;	
}
/* Converts a decimal integer "n" to a binary string "bin" */
void dec2bin(int n, char bin[]){
	int i =0;
	while(n != 0){
		bin[i++] = (n % 2)?'1':'0';
		n = n/2;
	}
	bin[i] = '\0';
	strrev(bin);
}

/* XOR multiplication */
/*
int mul(int a, int b) {
    int p = 0; // the product of the multiplication 
  
    while (b) {
        if (b & 1)
            p ^= a; 
        a<<=1;
        b>>=1;      
    }
    return p;
}

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
int sub(int a, int b) {
    return a ^ b;
}

/* Addition two numbers in the GF(2^8) finite field */
int add(int a, int b) {
    return a ^ b;
}
/* Divides(XOR division) two polynomials in GF(2^8)*/
void div(char* r, char* a, char* rem, char* quo){   // r = a * quo + rem
	
	int i = 0;
	for(i=1;i<strlen(a);i++)
			rem[i-1] = (r[i] == a[i])?'0':'1';
		
		rem[i-1] = '\0';
		int q_index = 0;
		quo[q_index++] = '1';
		for(int j=strlen(a);j<strlen(r);j++){
			int len = strlen(rem);
			rem[len] = r[j];
			rem[len+1] = '\0';
			if(rem[0] == '0'){
				for(i=1;i<strlen(a);i++)
					rem[i-1] = (rem[i] == '0')?'0':'1';
				
				rem[i-1] = '\0';
				quo[q_index++] = '0';
			}
			else{
				for(i=1;i<strlen(a);i++)
					rem[i-1] = (rem[i] == a[i])?'0':'1';
				
				rem[i-1] = '\0';
				quo[q_index++] = '1';
			}
		}
		quo[q_index] = '\0';
	
}

/* Finds multiplicative modulo inverse of a polynomial*/
int inverse(int newr, char r[]){

	int t = 0, newt = 1, i = 0, quotient, q_index = 0, len;
	char a[100], rem[100], quo[100];
    if(newr == 0) return 0;
	
	dec2bin(newr, a);	
	do{
		div(r,a,rem,quo);

		// finding index of first occurance of '1'
		for(i=0;i<strlen(rem);i++) 
			if(rem[i] == '1')
				break;
		// removing all the '0' occuring before the first '1'	
		for(int j=i;j<=strlen(rem);j++)
			rem[j-i] = rem[j];	
	
		newr = bin2dec(rem);
		quotient = bin2dec(quo);
		strcpy(r, a);
		strcpy(a, rem);
		int temp = sub(t, mul(quotient, newt));
		t = newt;
		newt = temp;

	}while(newr != 0);
		
	return t;
}

/*Constructing LAT table*/
void lat_table(int LAT[][256]){
	int X[256][8], Y[256][8], inv_num, a_x_coeff[8], b_y_coeff[8], num, final_xor[256], x_xor, y_xor, zero_count, row,col;
	for(int i=0;i<256;i++){
		num = i;
		for(int j=0;j<8;j++){
			X[i][7-j] = num%2;
			num /= 2 ;
		}		
		row = 0; col = 0;
		for(int j=0;j<4;j++)
			row = 2*row + X[i][j];
			
		for(int j=4;j<8;j++)
			col = 2*col + X[i][j];
			
		inv_num = sbox[row][col];
		for(int j=0;j<8;j++){
			Y[i][7-j] = inv_num%2;
			inv_num /= 2 ;
		}
	}	
	for(int i=0;i<256;i++){
		num = i; row = i;
		for(int k=0;k<8;k++){
			a_x_coeff[7-k] = num%2;
			num /= 2 ;
		}
		for(int j=0;j<256;j++){
			num = j; col = j;
			for(int k=0;k<8;k++){
				b_y_coeff[7-k] = num%2;
				num /= 2 ;
			}
			for(int k=0;k<256;k++){
				x_xor = 0; y_xor = 0;
				for(int l=0;l<8;l++){
					x_xor = x_xor ^ (a_x_coeff[l]*X[k][l]);
					y_xor = y_xor ^ (b_y_coeff[l]*Y[k][l]);
				}
				final_xor[k] = x_xor ^ y_xor; 
			}
			zero_count = 0;
			for(int k=0;k<256;k++)
				if(final_xor[k] == 0)
					zero_count++;
					
			LAT[row][col] = zero_count;
		}
	}
}
/*Constructing DT table*/
void dt_table(int DT[][256]){
	for(int i=0;i<256;i++){
		for (int j = 0; j < 256; j++){
			for(int k=0;k<256;k++){
				if((i^j)== k){
					for(int n=0;n<256;n++){
						if (n == (sbox1d[i]^sbox1d[j]))
							DT[k][sbox1d[i]^sbox1d[j]]++;
						}
				}
			}
		}
	}
}

/*Evaluating Balancedness Property */
void balancedness(){
    int row,col,flag = 0;
    int Balance[256]= {0};
	for(row=0;row<16;row++)
		for(col=0;col<16;col++)
			Balance[sbox[row][col]]++;
	printf("------------------------------BALANCEDNESS-------------------------------\n");
	for(int i=0;i<256;i++)
		if(Balance[i] > 2) flag = 1; 
	if(flag == 0) printf("It does satisfies balanceness property\n");
	else printf("It does not satisfies balanceness property\n");
}

/*Evaluating Fixed Point Property*/
void fixed_point(){
	int same_ip_op = 0,row,col,num;
	for(row=0;row<16;row++){
		for(col=0;col<16;col++){
			num = row*16 + col;
			if(num == sbox[row][col])
				same_ip_op++;
		}
	}
	printf("\n------------------------------FIXED POINT-------------------------------\n");
	if(same_ip_op == 0) printf("It does satisfies fixed point property\n");
	else printf("It does not satisfies fixed point property\n");
}

/*Evaluating SAC Property*/	
void sac(){
	int x, y;
	float SAC[16][16];
	for(int i=0;i<16;i++){
		 for(int j=0;j<16;j++){
		 	x = i*16 + j;
		 	y = sbox1d[x];
		 	float count_one = 0;
		 	for(int k=1;k<256;k *= 2){
		 		int flip_x = x ^ k;
		 		int flip_y = sbox1d[flip_x];
		 		int xor_flip_y = y ^ flip_y;		 	
		 		for(int l=0;l<8;l++){
		 			count_one += (xor_flip_y & 1)?1.0:0.0;
		 			xor_flip_y = xor_flip_y >> 1;
			 	}
		 	}
		 	SAC[i][j] = count_one/64;
		 }
	}
	printf("\n------------------------------SAC-------------------------------\n");
	float SAC_avg = 0;
	for(int i=0;i<16;i++){
		for(int j=0;j<16;j++){
			SAC_avg += SAC[i][j];
			printf("%.2f ",SAC[i][j] );
		}
		printf("\n");
	}
	printf("\nAverage of SAC table is: %.2f\n",SAC_avg/256 );
}
/*Evaluating Non Linearity Property*/	
void non_lin(int LAT[][256]){	
	int max_hd = 0, num;
	for(int i=1;i<256;i++){
		for(int j=1;j<256;j++){
			num = LAT[i][j]-128;
			num = num<0?(-1*num):num;
			if(max_hd < num) {
				max_hd = num;
			}
		}
	}
	printf("\n------------------------------Non Linearity-------------------------------\n");
	printf("%d ",128-max_hd);
}

int main(){  
	char poly[] = "111001111"; // Our poly
	char c[] = "10001101"; // constant c our
	char affine_str[] = "11100011"; //our
	//char poly[] = "100011011"; // AES std poly	
	//char c[] = "11000110"; //AES	
	//char affine_str[] = "11110001"; //AES
	
	int row,col,inv[16][16],num,affine_mat[8][8],LAT[256][256];
	char r[100],b[100],inv_bin[9];
	int DT[256][256]={0};
	//printf("\n--------------------------INVERSE TABLE---------------------------------\n");
	for(row=0;row<16;row++){
		for(col=0;col<16;col++){
			num = row*16 + col;
			strcpy(r, poly);
			inv[row][col] = inverse(num, r);
			//printf("%d ",inv[row][col]);
		}
		//printf("\n");
	}
	/* creating Affine matrix */
	for(int i=0;i<8;i++)
		affine_mat[0][i] = affine_str[i]-'0';
	for(int i=1;i<8;i++){
		int last_bit = affine_mat[i-1][0];
		for(int j=1;j<8;j++)
			affine_mat[i][j-1] = affine_mat[i-1][j];		
		affine_mat[i][7] = last_bit;
	}
	printf("\n---------------------------------SBOX------------------------------------\n");
	for(row=0;row<16;row++){
		for(col=0;col<16;col++){
			num = inv[row][col];
			strcpy(inv_bin, "00000000");
			int i = 0;
			while(num != 0){
				inv_bin[i++] = (num % 2)?'1':'0';
				num = num/2;
			}
			inv_bin[8] = '\0';
			strrev(inv_bin);			
			for(i=0;i<8;i++){
				num = 0;
				for(int j=0;j<8;j++)
					num = num + affine_mat[i][j] * (inv_bin[j]-'0');
				
				num += (c[i]-'0');
				b[i] = '0' + (num%2);
			}			
			b[i] = '\0';
			strrev(b);			
			
			num = bin2dec(b);
							
			sbox[row][col] = num; //2D Sbox
			sbox1d[row*16+col] = num; //1D Sbox
			printf("0x%02X ",sbox[row][col]);
		}
		printf("\n");
	}
	/* --------------------SBOX costruction ends----------------------- */			
	
	
	balancedness();
	fixed_point();
	sac();	
	lat_table(LAT);
	non_lin(LAT);	
	dt_table(DT);
	
	return 0;
}

