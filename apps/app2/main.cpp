#include <iostream>
#include <Python.h>
#include "module1/module1.hpp"
#include "app2.hpp"

int main(int argc, char const *argv[])
{
    app_message();
    module1_message();

    Py_Initialize();
    PyRun_SimpleString("print('Hello! from Python.')");
    Py_Finalize();
    return 0;
}
