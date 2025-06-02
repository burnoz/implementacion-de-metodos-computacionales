#include <iostream>
#include <thread>
#include <mutex>
#include <chrono>

using namespace std;

const int num_filos = 5;
mutex cubiertos[num_filos];
mutex cout_mutex;

void filosofar(int pos){
    while (true){
        {
            // Bloquea la salida para imprimir un estado a la vez
            lock_guard<mutex> lock(cout_mutex);
            // Imprime el estado y desbloquea la salida al salir del bloque
            cout << "Filosofo " << pos << " pensando" << endl;
        }
        // Mantiene el estado por 1 segundo
        this_thread::sleep_for(chrono::milliseconds(1000));

        // Bloquea los cubiertos a los lados
        cubiertos[(pos + 1) % num_filos].lock(); // Izquierdo
        cubiertos[pos].lock(); // Derecho

        {
            // Bloquea la salida para imprimir un estado a la vez
            lock_guard<mutex> lock(cout_mutex);
            // Imprime el estado y desbloquea la salida al salir del bloque
            cout << "Filosofo " << pos << " comiendo" << endl;
        }
        // Mantiene el estado por 1 segundo
        this_thread::sleep_for(chrono::milliseconds(1000));

        // Desbloquea los cubiertos
        cubiertos[(pos + 1) % num_filos].unlock(); // Izquierdo
        cubiertos[pos].unlock(); // Derecho

        // % num_filos para que se pueda acceder al cubierto 0 con el filosofo 4
    }
}


int main(){
    thread filosofos[num_filos];

    // Hilo para cada filosofo
    for(int i = 0; i < num_filos; i++){
        filosofos[i] = thread(filosofar, i);
    }

    // Une los hilos
    for(int i = 0; i < num_filos; i++){
        filosofos[i].join();
    }
}