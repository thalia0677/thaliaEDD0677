#include <iostream>     // Permite usar entrada/salida como cout y cin
#include <string>       // Permite usar el tipo de dato string
using namespace std;    // Para evitar escribir std:: en cada línea

//thalia aragon sala, liceth yailineth riascos escobar, dylan andres arboleda ferrin//

// Enumeración que define los dos colores posibles para un nodo en el árbol Rojo-Negro
enum Color { ROJO, NEGRO };

// Estructura que representa un nodo del árbol, es decir, una película
struct Pelicula {
    string titulo;          // Título de la película
    string genero;          // Género de la película
    float presupuesto;      // Presupuesto de la película
    Color color;            // Color del nodo: ROJO o NEGRO
    Pelicula* izquierda;    // Puntero al hijo izquierdo
    Pelicula* derecha;      // Puntero al hijo derecho
    Pelicula* padre;        // Puntero al nodo padre
};

// Función que crea un nuevo nodo (película) y lo inicializa
Pelicula* crearNodo(string titulo, string genero, float presupuesto) {
    Pelicula* nuevoNodo = new Pelicula(); // Se reserva memoria para el nodo
    nuevoNodo->titulo = titulo;           // Se asigna el título
    nuevoNodo->genero = genero;           // Se asigna el género
    nuevoNodo->presupuesto = presupuesto; // Se asigna el presupuesto
    nuevoNodo->color = ROJO;              // Por defecto, se asigna color ROJO (regla del RBT)
    nuevoNodo->izquierda = nullptr;       // No tiene hijo izquierdo aún
    nuevoNodo->derecha = nullptr;         // No tiene hijo derecho aún
    nuevoNodo->padre = nullptr;           // No tiene padre aún
    return nuevoNodo;                     // Se retorna el nuevo nodo creado
}

// Función que realiza rotación a la izquierda alrededor del nodo x
void rotacionIzquierda(Pelicula*& raiz, Pelicula*& x) {
    Pelicula* y = x->derecha;             // y es el hijo derecho de x
    x->derecha = y->izquierda;            // Se mueve el subárbol izquierdo de y como hijo derecho de x
    if (y->izquierda != nullptr)          // Si el nuevo hijo derecho de x no es nulo
        y->izquierda->padre = x;          // Se actualiza el padre del nuevo hijo

    y->padre = x->padre;                  // y toma el lugar de x como hijo de su padre

    if (x->padre == nullptr)              // Si x era la raíz
        raiz = y;                         // y se convierte en la nueva raíz
    else if (x == x->padre->izquierda)    // Si x era hijo izquierdo
        x->padre->izquierda = y;          // y pasa a ser el hijo izquierdo del padre
    else
        x->padre->derecha = y;            // o el hijo derecho

    y->izquierda = x;                     // x pasa a ser hijo izquierdo de y
    x->padre = y;                         // y se convierte en padre de x
}

// Función que realiza rotación a la derecha alrededor del nodo y
void rotacionDerecha(Pelicula*& raiz, Pelicula*& y) {
    Pelicula* x = y->izquierda;           // x es el hijo izquierdo de y
    y->izquierda = x->derecha;            // El subárbol derecho de x pasa a ser el hijo izquierdo de y
    if (x->derecha != nullptr)            // Si no es nulo
        x->derecha->padre = y;            // Se actualiza su padre

    x->padre = y->padre;                  // x toma el lugar de y como hijo de su padre

    if (y->padre == nullptr)              // Si y era la raíz
        raiz = x;                         // x se convierte en la nueva raíz
    else if (y == y->padre->izquierda)    // Si y era hijo izquierdo
        y->padre->izquierda = x;          // x pasa a ser el hijo izquierdo
    else
        y->padre->derecha = x;            // o el derecho

    x->derecha = y;                       // y pasa a ser hijo derecho de x
    y->padre = x;                         // x se convierte en padre de y
}

// Función que corrige el árbol luego de una inserción para mantener propiedades Rojo-Negro
void arreglarInsercion(Pelicula*& raiz, Pelicula*& nodo) {
    Pelicula* padre = nullptr;
    Pelicula* abuelo = nullptr;

    // Mientras el nodo no sea la raíz, su color sea rojo y el padre también sea rojo
    while (nodo != raiz && nodo->color == ROJO && nodo->padre->color == ROJO) {
        padre = nodo->padre;             // Se guarda el padre
        abuelo = padre->padre;           // Se guarda el abuelo

        // Caso 1: el padre es hijo izquierdo del abuelo
        if (padre == abuelo->izquierda) {
            Pelicula* tio = abuelo->derecha;  // El tío es el hijo derecho del abuelo

            // Caso 1.1: El tío es rojo => recolorear
            if (tio != nullptr && tio->color == ROJO) {
                abuelo->color = ROJO;
                padre->color = NEGRO;
                tio->color = NEGRO;
                nodo = abuelo;               // Se sigue verificando desde el abuelo
            } else {
                // Caso 1.2: nodo es hijo derecho => rotación izquierda
                if (nodo == padre->derecha) {
                    rotacionIzquierda(raiz, padre);
                    nodo = padre;
                    padre = nodo->padre;
                }
                // Caso 1.3: nodo es hijo izquierdo => rotación derecha y recoloración
                rotacionDerecha(raiz, abuelo);
                swap(padre->color, abuelo->color);  // Intercambiar colores
                nodo = padre;
            }
        } else { // Caso 2: el padre es hijo derecho del abuelo
            Pelicula* tio = abuelo->izquierda;

            if (tio != nullptr && tio->color == ROJO) {
                abuelo->color = ROJO;
                padre->color = NEGRO;
                tio->color = NEGRO;
                nodo = abuelo;
            } else {
                if (nodo == padre->izquierda) {
                    rotacionDerecha(raiz, padre);
                    nodo = padre;
                    padre = nodo->padre;
                }
                rotacionIzquierda(raiz, abuelo);
                swap(padre->color, abuelo->color);
                nodo = padre;
            }
        }
    }

    raiz->color = NEGRO;  // La raíz siempre debe ser negra
}

// Función que inserta un nuevo nodo en el árbol Rojo-Negro
void insertarRBT(Pelicula*& raiz, string titulo, string genero, float presupuesto) {
    Pelicula* nuevoNodo = crearNodo(titulo, genero, presupuesto); // Se crea un nuevo nodo
    Pelicula* y = nullptr;     // Padre del nodo actual
    Pelicula* x = raiz;        // Comenzamos desde la raíz

    // Búsqueda del lugar apropiado para insertar según el presupuesto
    while (x != nullptr) {
        y = x;
        if (nuevoNodo->presupuesto < x->presupuesto)
            x = x->izquierda;       // Ir a la izquierda si es menor
        else
            x = x->derecha;        // Ir a la derecha si es mayor o igual
    }

    nuevoNodo->padre = y;          // Se establece el padre

    // Inserta el nodo como hijo izquierdo o derecho
    if (y == nullptr)
        raiz = nuevoNodo;          // Árbol vacío, se convierte en raíz
    else if (nuevoNodo->presupuesto < y->presupuesto)
        y->izquierda = nuevoNodo;
    else
        y->derecha = nuevoNodo;

    // Llama a la función para arreglar el árbol Rojo-Negro
    arreglarInsercion(raiz, nuevoNodo);
}

// Función para recorrer el árbol en preorden (raíz, izquierda, derecha)
void preorden(Pelicula* raiz) {
    if (raiz != nullptr) {
        cout << "[";                         // Imprime el color del nodo
        cout << (raiz->color == ROJO ? "R" : "N") << "] ";
        cout << "Título: " << raiz->titulo
             << ", Género: " << raiz->genero
             << ", Presupuesto: " << raiz->presupuesto << endl;

        preorden(raiz->izquierda);          // Visita hijo izquierdo
        preorden(raiz->derecha);            // Visita hijo derecho
    }
}

// Función principal: punto de entrada del programa
int main() {
    Pelicula* raiz = nullptr;  // Inicialmente el árbol está vacío

    // Insertamos varias películas
    insertarRBT(raiz, "Inception", "Ciencia Ficción", 160.0);
    insertarRBT(raiz, "El Padrino", "Crimen", 6.0);
    insertarRBT(raiz, "El Caballero de la Noche", "Acción", 185.0);
    insertarRBT(raiz, "Tiempos Violentos", "Drama", 8.0);

    // Muestra el árbol en recorrido preorden
    cout << "Contenido del árbol Rojo-Negro (preorden):" << endl;
    preorden(raiz);

    return 0;
}