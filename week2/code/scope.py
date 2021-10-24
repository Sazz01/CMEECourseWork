#!/usr/bin/env python3


"""Shows how global and local values are used"""

__appname__ = ['scope.py']
__author__ = 'Sarah Dobson (sld21@ic.ac.uk)'
__version__ = '0.0.1'



_a_global = 10 # a global variable

if _a_global >= 5:
    _b_global = _a_global + 5 # also a global variable
    
print("Before calling a_function, outside the function, the value of _a_global is", _a_global)
print("Before calling a_function, outside the function, the value of _b_global is", _b_global)

def a_function():

    """this shows how global and local functions are used"""
    _a_global = 4 # a local variable
    
    if _a_global >= 4:
        _b_global = _a_global + 5 # also a local variable
    
    _a_local = 3
    
    print("Inside the function, the value of _a_global is", _a_global)
    print("Inside the function, the value of _b_global is", _b_global)
    print("Inside the function, the value of _a_local is", _a_local)
    


#if you assign a variable outside a function, it is available inside it despite being assigned outside that function:

_a_global = 10


def a_function():

    """a variable assigned outside a function is still available inside"""
    _a_local = 4
    
    print("Inside the function, the value _a_local is", _a_local)
    print("Inside the function, the value of _a_global is", _a_global)
    
a_function()

print("Outside the function, the value of _a_global is", _a_global)



#to assign a global variable from inside a function, you can use the global keyword:

a_global = 10

print("Before calling a_function, outside the function, the value of _a_global is", _a_global)

def a_function():

    """assigning a global variable from inside a function"""
    global _a_global
    _a_global = 5
    _a_local = 4
    
    print("Inside the function, the value of _a_global is", _a_global)
    print("Inside the function, the value _a_local is", _a_local)
    
a_function()

print("After calling a_function, outside the function, the value of _a_global now is", _a_global)




#global and local functions nested


def a_function():

    """showing the use of nested local and global functions"""
    _a_global = 10

    def _a_function2():
        global _a_global
        _a_global = 20
    
    print("Before calling a_function2, value of _a_global is", _a_global)

    _a_function2()
    
    print("After calling a_function2, value of _a_global is", _a_global)
    
a_function()

print("The value of a_global in main workspace / namespace now is", _a_global)


#a global keyword inisde a_function2() changes the value of a_global to 20 wihtin the workspace but not inside a_function()

_a_global = 10

def a_function():
    """a global keyword inisde a_function2() changes the value of a_global to 20 wihtin the workspace but not inside a_function()"""

    def _a_function2():
        global _a_global
        _a_global = 20
    
    print("Before calling a_function2, value of _a_global is", _a_global)

    _a_function2()
    
    print("After calling a_function2, value of _a_global is", _a_global)

a_function()

print("The value of a_global in main workspace / namespace is", _a_global)