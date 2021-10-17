#!/bin/bash
#Author: Sarah Dobson sld21@ic.ac.uk
#script: variables.sh
#description: shows how variables in scripts can be used by 
#(1) declaring how many arguments the script was called with, the name of the script 
#and the name of any arguments suppied.
#(2) reassigning a value to a string 
#(3) reading multiple values inputted by the user 
#(4) creating a command to sum the values together, then printing that number
#Arguments: MY_VAR -> an expression that will be added to the string; 
#a -> first number; b -> second number; MY_SUM -> the sum of a and b
#Date 9 Oct 2021


#(1)
echo "This script was called with $# parameters"
echo "The script's name is $0"
echo "The arguments are $@"
echo "The first argument is $1"
echo "The second argument is $2"

# (2) 
MY_VAR='some string' 
echo 'the current value of the variable is:' $MY_VAR
echo
echo 'Please enter a new string'
read MY_VAR
echo
echo 'the current value of the variable is:' $MY_VAR
echo

## (3) 
echo 'Enter two numbers separated by space(s)'
read a b
echo
echo 'you entered' $a 'and' $b '; Their sum is:'

## (4) 
MY_SUM=$(expr $a + $b)
echo $MY_SUM