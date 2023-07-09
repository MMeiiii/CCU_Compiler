int sum(int a){

	int b;
	b = 5 * a;
	
	return b;
}

int main(void){

	int c = 10;
	int d;
	
	while(c > 3){
	
		c = c -2;
	
	}
	
	d = sum(c);
	
	switch(c){
	
		case 0:
			d = sum(c);
			break;
		case 1:
			d = sum(c);
			break;
		case 2:
			d = sum(c);
			break;
	}
	
	printf("value = %d, ans = %d\n", c, d);

}
