#include <iostream>
#include <cstring>
#include <cstdlib>
// thalia aragon sala, johan andres paz barrantes//
using namespace std;

struct Pelicula {
    char nombre[100];
    int año;
    char genero[50];
    float recaudacion;
    struct Pelicula* izq;
    struct Pelicula* der;
};

struct Pelicula* raiz = NULL;
struct Pelicula* aux;

// Función para crear un nuevo nodo
struct Pelicula* crearNodo() {
    aux = (struct Pelicula*) malloc(sizeof(struct Pelicula));
    aux->izq = aux->der = NULL;
    
    cout << "Nombre de la película: ";
    cin.ignore();
    cin.getline(aux->nombre, 100);
    
    cout << "Año de realización: ";
    cin >> aux->año;
    
    cout << "Género: ";
    cin.ignore();
    cin.getline(aux->genero, 50);
    
    cout << "Dinero recaudado (en millones): ";
    cin >> aux->recaudacion;
    
    return aux;
}

// Función para insertar en el árbol
void insertar(struct Pelicula* nueva, struct Pelicula* actual) {
    if(nueva->año < actual->año || (nueva->año == actual->año)) {
        if(actual->izq == NULL) {
            actual->izq = nueva;
        } else {
            insertar(nueva, actual->izq);
        }
    } else {
        if(actual->der == NULL) {
            actual->der = nueva;
        } else {
            insertar(nueva, actual->der);
        }
    }
}

void adicionarPelicula() {
    struct Pelicula* nueva = crearNodo();
    if(raiz == NULL) {
        raiz = nueva;
    } else {
        insertar(nueva, raiz);
    }
}

// Recorridos
void inorden(struct Pelicula* nodo) {
    if(nodo == NULL) return;
    inorden(nodo->izq);
    cout << nodo->nombre << " (" << nodo->año << ") - " << nodo->genero << " - $" << nodo->recaudacion << "M\n";
    inorden(nodo->der);
}

void preorden(struct Pelicula* nodo) {
    if(nodo == NULL) return;
    cout << nodo->nombre << " (" << nodo->año << ") - " << nodo->genero << " - $" << nodo->recaudacion << "M\n";
    preorden(nodo->izq);
    preorden(nodo->der);
}

void posorden(struct Pelicula* nodo) {
    if(nodo == NULL) return;
    posorden(nodo->izq);
    posorden(nodo->der);
    cout << nodo->nombre << " (" << nodo->año << ") - " << nodo->genero << " - $" << nodo->recaudacion << "M\n";
}

// Buscar por nombre
void buscarPorNombre(struct Pelicula* nodo, const char* nombre) {
    if(nodo == NULL) return;
    if(strcmp(nodo->nombre, nombre) == 0) {
        cout << "Película encontrada:\n";
        cout << nodo->nombre << " (" << nodo->año << ") - " << nodo->genero << " - $" << nodo->recaudacion << "M\n";
    }
    buscarPorNombre(nodo->izq, nombre);
    buscarPorNombre(nodo->der, nombre);
}

// Mostrar por género
void mostrarPorGenero(struct Pelicula* nodo, const char* genero) {
    if(nodo == NULL) return;
    mostrarPorGenero(nodo->izq, genero);
    if(strcmp(nodo->genero, genero) == 0) {
        cout << nodo->nombre << " (" << nodo->año << ") - " << nodo->genero << " - $" << nodo->recaudacion << "M\n";
    }
    mostrarPorGenero(nodo->der, genero);
}

// Guardar nodos en array para ordenarlos
void guardarNodos(struct Pelicula* nodo, struct Pelicula** lista, int* index) {
    if(nodo == NULL) return;
    guardarNodos(nodo->izq, lista, index);
    lista[*index] = nodo;
    (*index)++;
    guardarNodos(nodo->der, lista, index);
}

// Mostrar los 3 fracasos
void mostrarFracasos(struct Pelicula* raiz) {
    struct Pelicula* lista[100];
    int total = 0;
    guardarNodos(raiz, lista, &total);

    // Bubble sort por recaudación
    for(int i = 0; i < total - 1; i++) {
        for(int j = 0; j < total - i - 1; j++) {
            if(lista[j]->recaudacion > lista[j+1]->recaudacion) {
                struct Pelicula* temp = lista[j];
                lista[j] = lista[j+1];
                lista[j+1] = temp;
            }
        }
    }

    cout << "3 Fracasos Taquilleros:\n";
    for(int i = 0; i < 3 && i < total; i++) {
        cout << lista[i]->nombre << " (" << lista[i]->año << ") - $" << lista[i]->recaudacion << "M\n";
    }
}

// Menú principal
int main() {
    int opcion;
    char nombreBuscado[100];
    char generoBuscado[50];

    do {
        cout << "\n--- MENÚ ---\n";
        cout << "1. Agregar película\n";
        cout << "2. Mostrar Inorden\n";
        cout << "3. Mostrar Preorden\n";
        cout << "4. Mostrar Posorden\n";
        cout << "5. Buscar película por nombre\n";
        cout << "6. Mostrar películas por género\n";
        cout << "7. Mostrar 3 fracasos taquilleros\n";
        cout << "0. Salir\n";
        cout << "Opción: ";
        cin >> opcion;

        switch(opcion) {
            case 1: adicionarPelicula(); break;
            case 2: inorden(raiz); break;
            case 3: preorden(raiz); break;
            case 4: posorden(raiz); break;
            case 5:
                cout << "Ingrese el nombre de la película a buscar: ";
                cin.ignore();
                cin.getline(nombreBuscado, 100);
                buscarPorNombre(raiz, nombreBuscado);
                break;
            case 6:
                cout << "Ingrese el género: ";
                cin.ignore();
                cin.getline(generoBuscado, 50);
                mostrarPorGenero(raiz, generoBuscado);
                break;
            case 7:
                mostrarFracasos(raiz);
                break;
        }

    } while(opcion != 0);

    return 0;
}