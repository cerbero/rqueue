
#include <sys/types.h>
#include <time.h>
#include <stdio.h>


long getWallTime()
{
	long t;
	t = time(NULL);
	return t;


}

double getCpuTime(){
	int c;
	c = clock();
	return c;
}


long calcWallTime(long t0,long t1){
    long cp ;
    cp = (long) (t1 - t0);
    return cp;

}

double calCpuTime(int c0, int c1){
	double wt;
        wt = (double) (c1 - c0)/CLOCKS_PER_SEC;
	return wt;

}
