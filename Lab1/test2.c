#include <stdio.h>

int main (){

    int a,b,c,d,e,f;

    scanf("%d %d %d %d %d %d",&a,&b,&c,&d,&e,&f);

    if(a*e==b*d){

        if(a*f==c*d){
            printf("Too many\n");
        }
        else{
            printf("No answer\n");
        }
    }
    else{
        double x,y;
        y=(double)(c*d-a*f)/(double)(b*d-a*e);
        x=(double)(c*e-f*b)/(double)(a*e-d*b);
        printf("x=%.2lf\n",x);
        printf("y=%.2lf\n",y);
    }
    return 0;
}
