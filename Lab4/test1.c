struct RT{
	
	char RT_1;
	int RT_2;
	int RT_3;
};

struct ST{
	int ST_1;
	char ST_2;
	int ST_3;
};

int A, B;
int C = 1;
float D, E, F;
char G, H, I, J, K, L;
int num[5];
int num_1[3] = {1, 2, 3};
int M = -2;

int main (void){

	int a, b, c, d, ans;
	int e = 1, f = 2, m = 10;
	float g, h, i;
	char j, k;
	int num_2[10];
	int num_3[3] = {4, 5, 6};
	int L = -5;
		
	scanf("%d", &a);
	
	if(A == 0){
		ans = ( 2 + 5) * (A + 1);
	}
	
	if(B != 1){
		ans = ans + ans * 2;
	}
	
	if( 0 < C){
		ans = ans / 10;
	}
	
	if(5 > M){
		ans = ans + e - 5;
	}
	
	if(e <= 1){
		ans = ans + (2 + 3) * 2;
	}
	
	if(m >= 10){
		ans = ans - 10;
	}

	
	printf("%d\n", ans);
	
}


