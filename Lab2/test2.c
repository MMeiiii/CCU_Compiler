#include <stdio.h>

void main(){

	int a = 100, b = 10, c = 90, d = 20;
	int people, average;
	float pass_score = 60.0;
	pepole = 0;
	
	while(people < 4){
	
		if(people == 0){
			printf("a get 100 scores");
			continue;
		}
		else if(people == 1){
			printf("b get 10 scores");
		}
		else if(people == 2){
			printf("c get 90 scores");
		}
		else{
			printf("d get 20 scores");
		}
		if(people == 3){
			break;】
		}
	
	}

	average = (a + b + c + d) / 4;
	
	printf("%d",average);
	
	if(average < pass_score){
		printf("average failed");
	}
	else{
		printf("average pass");
	}
	
	return 0;

}
