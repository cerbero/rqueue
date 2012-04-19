
#include <sys/types.h>
#include <time.h>
#include <stdio.h>
#include <unistd.h>


long getWallTime()
{
	long t;
	t = time(NULL);
	return t;


}

double getCpuTime(){
	double c;
	c = clock();
	return c;
}


long calcWallTime(long t0,long t1){
    long cp ;
    cp = (long) (t1 - t0);
    return cp;

}

double calCpuTime(double c0, double c1){
	double wt;
//        wt = (float) (c1 - c0)/CLOCKS_PER_SEC;
        wt = c1-c0;
	return wt;

}

void main (){
	long w1,w2,rc;
	double c1,c2,r,r2;
	w1=getWallTime();
	c1=getCpuTime();
	sleep(60);
	w2=getWallTime();
	c2=getCpuTime();	
	r = calCpuTime(c1,c2);
	rc = calcWallTime(w1,w2);
	r2=r/CLOCKS_PER_SEC;
	printf("%f\n",r);
	printf("%f\n",r2);
	printf("%li\n",rc);
}
