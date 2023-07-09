#include <stdio.h>

int main (){

    int n,car[50],num=0; // num--> car num , car[]-->store the last one

    scanf("%d",&n);

    for(int i=0;i<n;i++){

        int a,b;

        scanf("%d %d",&a, &b);

        if(i==0){
            car[0]=b;
            num++;
        }
        else{

            for(int j=0;j<num;j++){

                if(car[j]<=a){ // --> change the last number
                    car[j]=b;
                    break;
                }
                if(j==num-1){
                    car[num]=b;
                    num++;
                    break;
                }
            }
        }
    }

    printf("%d\n",num);


    return 0;
}
