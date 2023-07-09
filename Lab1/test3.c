#include <stdio.h>
#include <math.h>

typedef struct data data;
typedef struct link_data link_data;

struct data{

    int nodeID, X_Pos, Y_Pos,visit;
    double dis__,noise;

}node[100000];

struct link_data{

    int link_ID, link_end1, link_end2;

}linker[100000];

int path_num=0,path[100000];

/* input information */
int nodes_num, links_num, basic_noise;
double power;

int judge_node_visit(int link_id){

    if(node[linker[link_id].link_end1].visit==1 || node[linker[link_id].link_end2].visit==1){
        return 1;
    }

    return 0;
}

double distance(int a,int b){

    int x,y;
    x=(node[a].X_Pos-node[b].X_Pos)*(node[a].X_Pos-node[b].X_Pos);
    y=(node[a].Y_Pos-node[b].Y_Pos)*(node[a].Y_Pos-node[b].Y_Pos);
    return sqrt(x+y);
}

void push(int link_id){

    path[path_num]=link_id;
    node[linker[link_id].link_end1].visit=1;
    node[linker[link_id].link_end2].visit=1;
    path_num++;

}

void check (int link_id){

    if (path_num==0){
        double dis=distance(linker[link_id].link_end1,linker[link_id].link_end2);

        if (basic_noise*dis*dis*dis/power >= 1){
            return;
        }
        node[linker[link_id].link_end2].dis__=dis;

        push(link_id);

        return;
    }

    /* other */
    for(int i=0;i<path_num;i++){
        double dl, dll, sum_noise;
        dl=node[linker[path[i]].link_end2].dis__;
        dll=distance(linker[path[i]].link_end2,linker[link_id].link_end1);
        sum_noise=node[linker[path[i]].link_end2].noise+(dl*dl*dl/dll/dll/dll);
        if(sum_noise+basic_noise*dl*dl*dl/power >= 1){
            return;
        }
    }

    /* this linker */
    double sum_noise=0;
    for(int i=0;i<path_num;i++){
        double dl, dll;
        dl=distance(linker[link_id].link_end1,linker[link_id].link_end2);
        dll=distance(linker[link_id].link_end2,linker[path[i]].link_end1);
        sum_noise=sum_noise+(dl*dl*dl)/(dll*dll*dll);
        if(sum_noise+basic_noise*(dl*dl*dl)/power >= 1){
            return;
        }
    }

    /* save other */
    sum_noise=0;
    for(int i=0;i<path_num;i++){
        double dl, dll;
        dl=node[linker[path[i]].link_end2].dis__;
        dll=distance(linker[path[i]].link_end2,linker[link_id].link_end1);
        sum_noise=node[linker[path[i]].link_end2].noise+(dl*dl*dl/dll/dll/dll);
        node[linker[path[i]].link_end2].noise=sum_noise;
    }

    /* save this linker */
    sum_noise=0;
    for(int i=0;i<path_num;i++){
        double dl,dll;
        dl=distance(linker[link_id].link_end1,linker[link_id].link_end2);
        dll=distance(linker[link_id].link_end2,linker[path[i]].link_end1);
        sum_noise=sum_noise+(dl*dl*dl)/(dll*dll*dll);
    }

    node[linker[link_id].link_end2].dis__=distance(linker[link_id].link_end1,linker[link_id].link_end2);
    node[linker[link_id].link_end2].noise=sum_noise;
    push(link_id);
}

int main (){


    /* input */
    scanf("%d %d %lf %d",&nodes_num, &links_num, &power, &basic_noise);

    for(int i=0; i<nodes_num; i++){
        scanf("%d %d %d",&node[i].nodeID, &node[i].X_Pos, &node[i].Y_Pos);
        node[i].visit=0;
        node[i].noise=0;
        node[i].dis__=0;
    }

    for(int i=0;i<links_num;i++){
        scanf("%d %d %d", &linker[i].link_ID, &linker[i].link_end1, &linker[i].link_end2);
    }

    /* function */
    for(int i=0;i<links_num;i++){

        int value;

        value=judge_node_visit(i);

        if(value==0){
            check(i);
        }
    }

    printf("%d\n",path_num);
    for(int i=0;i<path_num;i++){
        printf("%d %d %d\n",path[i],linker[path[i]].link_end1,linker[path[i]].link_end2);
    }

    return 0;
}

