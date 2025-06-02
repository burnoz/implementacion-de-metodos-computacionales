#include <stdio.h>
#include <pthread.h>

#include <iostream>
#include <cstdlib>

#include <time.h>
//#include <sys/times.h>

#include <unistd.h>
#include <limits.h>
#include <float.h>

using namespace std;


#define ARRAY_SIZE 1000000001
#define NUM_THREADS 4

int *A;
long long totalS;
long long totalP;

// mutex: una bandera para que solo un thread a la vez pueda modificar el dato
pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;

void suma_secuencial ( int *A, int n)
{	int i;
	for (i = 0; i< n ; i++ )
	{	totalS += A[i]; }

	cout << "Total secuencial:\t" << totalS << endl;
}


// La funcion de la suma paralela
void *suma_paralela (void  *id)
{	int threadId = * (int *) id;   

	int chunkSize = ARRAY_SIZE / NUM_THREADS; 
    int startIndex = threadId * chunkSize;
    int endIndex = startIndex + chunkSize;
	
	//	Forzar a que el ultimo thread tome lo que pueda sobrar
    if (threadId == 3)  {	endIndex = ARRAY_SIZE; 	 }
    cout << threadId << " " << startIndex  << " " << endIndex << endl;

    int i;
    long long subtotal = 0;

    // Suma local
    for ( i = startIndex; i < endIndex; i++) 
    {    subtotal += A[i];    }


    // Exclusion mutua usando mutex
    pthread_mutex_lock(&lock);
    	totalP += subtotal;
    pthread_mutex_unlock(&lock);

    pthread_exit(NULL);
}



int main(int argc, char* argv[]) 
{	
	int n = ARRAY_SIZE;
	int i = 0;

	A = (int *) malloc( n * sizeof(int) ) ;	
	for (i = 0; i< n ; i++ )
	{	A[i] = 1; }

	//	Variables para medir el tiempo
	double endTimeSeconds, tiempoSEC = 0.0, tiempoPAR = 0.0;
	struct tms start;
	struct tms end;
	double clockTicksPerSecond;
	double startTimeSeconds;

	//	Inicializa el contador de tiempo       
	clockTicksPerSecond = (double)sysconf(_SC_CLK_TCK);					
	times(&start);														
	startTimeSeconds = start.tms_utime/clockTicksPerSecond;
	
		// Hace la suma secuencial	
		suma_secuencial(A, n);

	// Finaliza el contador de tiempo
	times(&end);
	endTimeSeconds = end.tms_utime/clockTicksPerSecond;
	tiempoSEC = endTimeSeconds - startTimeSeconds;

	cout << "Tiempo secuencial " << tiempoSEC << endl;
	//printf("Tiempo sec. \t%.3f\n", tiempoSEC);


	//	Medicion de tiempo para la version paralela
	clockTicksPerSecond = (double)sysconf(_SC_CLK_TCK);					
	times(&start);														
	startTimeSeconds = start.tms_utime/clockTicksPerSecond;

		//	Creacion de los hilos
		pthread_t threads[NUM_THREADS];      //	crear un arreglo de threads
		int thread_ids[NUM_THREADS]; 		 //	arreglo de ids para los threads

		//	Un ciclo que lanza los hilos
		for ( i = 0; i < NUM_THREADS; i++) 
		{	thread_ids[i] = i;
			int rc = pthread_create(&threads[i], NULL, suma_paralela, &thread_ids[i]) ;  
			if (rc)		//	si no es 0 es error 												
			{	cout << "ERROR CODE: " << rc << endl;  }
		}

		// Los threads terminan y todo vuelve al thread original
		for (i = 0; i < NUM_THREADS; i++) 
	    {	pthread_join(threads[i], NULL);			}
	  	  
	  	cout << "Total paralelo:\t" << totalP << endl; 

	times(&end);
	endTimeSeconds = end.tms_utime/clockTicksPerSecond;
	tiempoSEC = endTimeSeconds - startTimeSeconds;

	cout << "Tiempo secuencial " << tiempoPAR << endl;
	printf("Tiempo sec. \t%.3f\n", tiempoPAR);


  	//	Liberamos 
  	pthread_mutex_destroy(&lock);
	pthread_exit(NULL);

}

