int main (void){

	int sum = 0; 
	int i;
	
	for(i = 0; i < 10; i ++){
		sum = sum + i;
	}
	
	printf("%d\n", sum);
	
	if(sum < 50){
		printf("sum is lower than 50!\n");
	}
	else{
		printf("sum is bigger than 50!\n");
	}

}
