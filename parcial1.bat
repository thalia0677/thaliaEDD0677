#include <iostream>

using namespace std;

struct nodo {
    int id;
    char nombre[30];
    int edad;
    char genero;
    char motivo[50];
    nodo* sig;
};

nodo* top = NULL;     // Cola (FIFO) - Clientes en espera
nodo* historial = NULL; // Pila (LIFO) - Historial de atenciones
nodo* aux = NULL;
nodo* aux2 = NULL;

// Función para agregar un cliente (FIFO)
void agregarCliente() {
    aux = (struct nodo *) malloc (sizeof(nodo));
    cout << "ID: ";
    cin >> aux->id;
    cin.ignore();
    cout << "Nombre: ";
    cin.getline(aux->nombre, 30);
    cout << "Edad: ";
    cin >> aux->edad;
    cout << "Genero (M/F): ";
    cin >> aux->genero;
    cin.ignore();
    cout << "Motivo: ";
    cin.getline(aux->motivo, 50);
    aux->sig = NULL;

    if (!top) {
        top = aux;
    } else {
        aux2 = top;
        while (aux2->sig != NULL) {
            aux2 = aux2->sig;
        }
        aux2->sig = aux;
    }

    cout << "Cliente agregado a la cola de espera.\n";
}

// Función para mostrar clientes en espera
void mostrarClientes() {
    aux = top;
    if (!aux) {
        cout << "No hay clientes en espera.\n";
        return;
    }

    cout << "\nClientes en espera:\n";
    while (aux != NULL) {
        cout << "ID: " << aux->id << ", Nombre: " << aux->nombre << ", Edad: " << aux->edad
             << ", Genero: " << aux->genero << ", Motivo: " << aux->motivo << endl;
        aux = aux->sig;
    }
}

// Función para contar clientes en espera
void contarClientes() {
    int contador = 0;
    aux = top;

    while (aux != NULL) {
        contador++;
        aux = aux->sig;
    }

    cout << "Clientes en espera: " << contador << endl;
}

// Función para registrar un cliente en el historial (pila LIFO)
void registrarHistorial(nodo* cliente) {
    cliente->sig = historial;
    historial = cliente;
}

// Función para mostrar el historial de clientes atendidos
void mostrarHistorial() {
    aux = historial;
    if (!aux) {
        cout << "No hay clientes en el historial.\n";
        return;
    }

    cout << "\nHistorial de clientes atendidos:\n";
    while (aux != NULL) {
        cout << "ID: " << aux->id << ", Nombre: " << aux->nombre << ", Edad: " << aux->edad
             << ", Genero: " << aux->genero << ", Motivo: " << aux->motivo << endl;
        aux = aux->sig;
    }
}

// Función para atender el siguiente cliente (FIFO)
void atenderCliente() {
    if (!top) {
        cout << "No hay clientes para atender.\n";
        return;
    }

    aux = top;
    cout << "Atendiendo a: " << aux->nombre << " (ID: " << aux->id << ")\n";
    top = top->sig;
    
    // Registrar el cliente atendido en el historial
    registrarHistorial(aux);
}

// Función para deshacer la última atención realizada
void deshacerUltimaAtencion() {
    if (!historial) {
        cout << "No hay atenciones previas para deshacer.\n";
        return;
    }

    // Extraer el último cliente atendido del historial (pila LIFO)
    aux = historial;
    historial = historial->sig;

    // Reinsertar al cliente al frente de la cola (FIFO)
    aux->sig = top;
    top = aux;

    cout << "Se deshizo la última atención. Cliente reintegrado a la cola.\n";
}

// Menú principal
int main() {
    int opcion;

    do {
        cout << "\nMenu\n";
        cout << "1. Agregar cliente a la cola\n";
        cout << "2. Mostrar clientes en espera\n";
        cout << "3. Contar clientes en espera\n";
        cout << "4. Atender siguiente cliente\n";
        cout << "5. Mostrar historial de atenciones\n";
        cout << "6. Deshacer última atención\n";
        cout << "7. Salir\n";
        cout << "Opcion: ";
        cin >> opcion;

        switch (opcion) {
            case 1:
                agregarCliente();
                break;
            case 2:
                mostrarClientes();
                break;
            case 3:
                contarClientes();
                break;
            case 4:
                atenderCliente();
                break;
            case 5:
                mostrarHistorial();
                break;
            case 6:
                deshacerUltimaAtencion();
                break;
            case 7:
                cout << "Saliendo...\n";
                break;
            default:
                cout << "Opcion invalida. Intente de nuevo.\n";
        }
    } while (opcion != 7);

    return 0;
}
