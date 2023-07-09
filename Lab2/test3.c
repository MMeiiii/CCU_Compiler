#include <stdio.h>

void main()
{
	int a = 20;
	int b;
	b = 20 % 2;
	switch(b){
	
		case 0:
			printf("even");
			break;
		case 1:
			printf("odd");
			break;
		default:
			printf("Wrong");
			break;
	
	}
	return 0;
}
