#include <iostream>
#include <sstream>
#include <cstring>
#include <string>

using namespace std;

// class node: un valor y un puntero a otro nodo
template <class T>		//	Esta linea permite que podamos crear listas de cualquier tipo de dato
class Node{	
    public:
		//	Atributos del nodo

		//int value;		// En lugar de que el nodo guarde un entero, guarda algo de tipo T
		T value; 			// valor almacenado

		Node<T> *prev; 	 	//	dir del nodo anterior
		Node<T> *next;		//	dir del nodo siguiente
		
		//	Que deberia recibir el contructor de la clase? 
		//		un valor para guardar en el nodo
		//	Que valores por default deberian tener prev y next? 
		Node(T valor){	
			this->value = valor;
			this->prev = NULL;
			this->next = NULL;
		}
};

//  Clase lista enlazada doble: 
template <class T>
class List{	
    //	Que atributos necesita??

	Node<T> *first;		//	puntero al primer nodo
	Node<T> *last; 	//	puntero al ultimo nodo	
	int size;			//	numero de elementos que tiene la lista

	public:
		//	Que valores deberia tener la lista por default??
		List(){	
            this->first = NULL; 
			this->last = NULL; 
			this->size = 0;
		}
		
		//	Funciones similares a las de la lista simple

		int getSize(){ return size; }	//	Funcion para obtener el numero de elementos
		void showList();				//	Funcion para mostrar la lista
		void showListReverse();			//	Funcion para mostrar la lista en reversa
		
		//	Funciones para insertar elementos
		void insertFirst(T);				//	al principio
		void insertLast(T);					//	al final
		bool insertAtIndex(int, T); 		//	en un indice

		//	Funciones para eliminar elementos
		void deleteFirst();					//	al principio
		void deleteLast();					//	al final				
		void deleteAtIndex(int); 			//	en un indice		

		Node<T>* find(T, int*);			//	Encontrar un valor	
		void update(int, T);			//	Actualizar el valor de un indice
};

// Inserta en un indice especifico
// Complejidad O(n)
template<class T>
bool List<T>::insertAtIndex(int index, T newValue){	
    Node<T> *node = new Node<T> (newValue);  
	
	//	Insertar al inicio 
	if (index == 0){	
        this->insertFirst(newValue); 
		return true;
	}

	// Insertar al final
	if (index == this->size){
        this->insertLast(newValue); 
		return true;
	}

	if(index < size/2){		//	Cuando es mas barato insertar desde el inicio	
        Node<T> *aux = first;
		int i = 0; 

		// Recorre la lista
		while(i < size/2){
			// Verifica si se llego a la posicion anterior al indice dado
            if(i == index - 1){
				// Enlaza el nodo nuevo con la lista
                node->prev = aux;
				node->next = aux->next; 

				node->next->prev = node; 
				aux->next = node;

				// Actualiza el numero de elementos
				this->size++;
				return true;
			}

			// Avanza en la lista
			aux = aux->next;
			i++;
		}
	}

	else{  	//	Cuando es mas barato insertar desde el final 
		Node<T> *aux = last;
		int i = this->size - 1;

		// Recorre la lista (en reversa)
		while(i > size/2){
			// Verifica si se llego al indice
			if(i == index){
				// Enlaza el nodo nuevo con la lista
				node->next = aux;
				node->prev = aux->prev;

				node->prev->next = node;
				aux->prev = node;

				// Actualiza el numero de elementos
				this->size++;
				return true;
			}

			// Retrocede en la lista
			aux = aux->prev;
			i--;
		}
	}

	return false;
}

// Encontrar un valor en la lista
// Complejidad O(n)
template<class T>
Node<T>* List<T>::find(T value, int *index){
	Node<T> *aux = first; // Nodo auxiliar para recorrer la lista
	int i = 0; // Variable contadora

	// Recorre la lista
	while(i < this->size){
		// Verifica si el elemento actual es el que se busca	
		if(aux->value == value){
			// Pasa el valor del indice y el nodo
			*index = i;
			return aux;
		}

		// Avanza en la lista
		aux = aux->next;
		i++;
	}

	// Caso en el que no encuentra el valor
	*index = -1;
	return NULL;
}

// Elimina un elemento en un indice especifico
// Complejidad O(n)
template<class T>
void List<T>::deleteAtIndex(int index){
    // Elimina el primer elemento
    if(index == 0){
        deleteFirst();
        return;
    }

    // Elimina el ultimo elemento
    if (index == this->size - 1){
        deleteLast();
        return;
    }

    Node<T> *aux;	// Nodo auxiliar

    // Cuando es mas barato eliminar desde el inicio
    if (index < size/2){
		// Inicia auxiliar en first
        aux = first;

		// Recorre la lista
        int i = 0;
        while (i < index){
            aux = aux->next;
            i++;
        }
    }

    // Cuando es mas barato eliminar desde el final
    else{
		// Inicia auxiliar en last
        aux = last;

		// Recorre la lista (en reversa)
        int i = size - 1;
        while (i > index){
            aux = aux->prev;
            i--;
        }
    }

    // Conecta los elementos a los lados del nodo a eliminar
    aux->prev->next = aux->next;
    aux->next->prev = aux->prev;

    // Elimina el nodo
    delete aux;

    // Actualiza el numero de elementos
    this->size--;
}

// Elimina el primer elemento
// Complejidad O(1)
template<class T>
void List<T>::deleteFirst(){	
    //  Crear un  auxiliar que guarde la direccion de first
	Node<T> *aux = first;
	
	//	Crear una puntero, llamado segundo, que tome la direccion del nodo siguiente de first
	Node<T> *second = aux->next;
	//  Asigna que el anterior a segundo ahora es last
	second->prev = last; 

	//  Y que el siguiente de last es segundo
	last->next = second;

	// Elimina aux con un delete
	delete aux;	
	
	// Ahora first es segundo
	this->first = second;

	// Disminuye el numero de elementos
	this->size--;	
}

// Elimina el ultimo elemento
// Complejidad O(1)
template<class T>
void List<T>::deleteLast(){	
	// Nodo auxiliar que guarda la direccion de last
	Node<T> *aux = this->last;

	// El penultimo elemento se vuelve el ultimo y lo enlaza con el primero
	this->last = aux->prev;
	this->last->next = first;

	// Elimina el nodo
	delete aux;

	// Actualiza el numero de elementos
	this->size--;
}

// inserta al inicio
// Complejidad O(1)
template<class T>
void List<T>::insertFirst(T newValue){	
    // Crear un nodo nuevo
	// Sintaxis: 
	// Clase<plantilla> *nombre = new Clase<plantilla>(parametros)
	Node<T> *node = new Node(newValue);

	// Crear un puntero auxiliar que guarde la direccion de first
	Node<T> *aux = first;

	// Hacer que el siguiente del nodo nuevo sea el auxiliar
	node->next = aux;
	// Y que el first ahora sea el nodo nuevo
	this->first = node;


	// Si la lista esta vacia
	if(this->size == 0){
		//	el ultimo es tambien el nodo nuevo
		this->last = node;
	}

	// Si no, 
	else{
		// el anterior a aux (viejo first) es ahora el nodo nuevo
		aux->prev = node; 
	}	

	// Para asegurar que la lista es circular
	// El anterior a first es last
	// El siguiente de last es first

	//	Finalmente actualizar el numero de elementos
	this->size++;
}

// inserta al final
// Complejidad O(1)
template<class T>
void List<T>::insertLast(T newValue){	
    // Crear un nodo nuevo
	// Sintaxis: 
	// Clase<plantilla> *nombre = new Clase<plantilla>(parametros)
	Node<T> *node = new Node<T>(newValue);

	// Crear un puntero auxiliar que guarde la direccion de last
	Node<T> *aux = this->last;

	// Hacer que el anterior del nodo nuevo sea el auxiliar (viejo last)
	node->prev = aux;
	// Y que el nuevo last ahora sea el nodo nuevo
	this->last = node;
	

	// Si la lista esta vacia
	if(this->size == 0){
		//	el first es tambien el nodo nuevo
		this->first = node;
	}

	// Si no, 
	else{
		// el siguiente a aux (viejo last) es ahora el nodo nuevo
		aux->next = node; 
	}
	
	// Para asegurar que la lista es circular
	// El anterior a first es last
	// El siguiente de last es first
	
	//	Finalmente actualizar el numero de elementos
	this->size++;
}

// Muestra la lista
// Complejidad O(n)
template<class T>
void List<T>::showList(){	
    // Crea un nodo auxiliar para iterar en la lista
	// auxiliar inicia en first
	Node<T> *aux = this->first;

	// Declara un contador i que inicie en 0
	int i = 0;

	// Imprime el numero de elementos
	cout << this->size << " elementos" << endl;

	// Mientras i sea menor que el numero de elementos
	while(i < this->size){	
        // Imprime el nodo
		cout << "El [" << i << "] elemento es:\t" << aux->value << endl;
		
		// aux avanza a aux->next
		aux = aux->next;

		// i incrementa
		i++;
	}

	cout << endl;
}

// Muestra la lista en reversa
// Complejidad O(n)
template<class T>
void List<T>::showListReverse(){
	// Crea un nodo auxiliar para iterar en la lista
	// auxiliar inicia al final de la lista
	Node<T> *aux = last;

	// Declara un contador i con el numero de elementos en la lista
	int i = this->size - 1;

	while(i >= 0){
		// Imprime el nodo
		cout << "El [" << i << "] elemento es:\t" << aux->value << endl;
		
		// aux retrocede a aux->prev
		aux = aux->prev;

		// i disminuye
		i--;
	}

	cout << endl;
}

// Actualiza un valor en la lista
// Complejidad O(n)
template<class T>
void List<T>::update(int index, T newValue){	
	int i;

	if(index < this->size/2){ // Cuando es mas conveniente actualizar desde el inicio
		Node<T> *aux = this->first; // Nodo auxiliar que inicia en first
		i = 0; // Variable contadora

		// Recorre la lista comenzando desde el inicio
		while(i < this->size/2){
			// Verifica si se llego al indice
			if(i == index){
				// Actualiza el valor
				aux->value = newValue;
			}
			
			// Avanza en la lista
			aux = aux->next;
			i++;
		}
	}

	else{ // Cuando es mas conveniente actualizar desde el final
		Node<T> *aux = this->last; // Nodo auxiliar que inicia en last
		i = this->size - 1; // Variable contadora

		// Recorre la lista comenzando desde el final
		while(i >= this->size/2){
			// Verifica si se llego al indice a actualizar
			if(i == index){
				// Actualiza el valor
				aux->value = newValue;
			}
			
			// Retrocede en la lista
			aux = aux->prev;
			i--;
		}
	}
}


// Clase tokens
template <class T>		//	Esta linea permite que podamos crear listas de cualquier tipo de dato
class Tokens{
    public:
		List<T> lista; // Lista de elementos genericos

        Tokens{
        }

        
};


int main(int argc, char* argv[]) {	

}