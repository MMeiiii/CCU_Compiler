#include <stdio.h>

#define width 80

typedef unsigned char mail;

struct ans{

	int a;

};

void main()
{
	int *a = 1;
	int b = 6;
	int c = 2;
	int d;
	double A[10];
	
	scanf("%d", &d); //input
	
	for(int i = 1; i < 5; i ++){
		a = a * i;
	}
	
	do{
		a = a * b; /* a bigger */
		b ++;
		c--; 
	}while(a < 300);
	
	a = a * (5+20*3/5) + 20;
	
	printf("%d", a);
	
	for(;;){ }
	
	if(a < 100){
	
		printf("nothing");
	}
	
	return 0;

}
