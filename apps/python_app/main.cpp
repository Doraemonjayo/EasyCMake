#include <Python.h>

int main() {
    Py_Initialize();
    PyRun_SimpleString(
        "print('Hello! from Python.')"
    );
    Py_Finalize();
    return 0;
}