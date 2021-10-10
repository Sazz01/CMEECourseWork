#!/bin/bash
#Author: Sarah Dobson sld21@ic.ac.uk
#script: variables.sh
#description: shows how variables in scripts can be used by (1) assigning a value to a string 
#(2) reading multiple values and adding them together
#Arguments: MyVar -> an expression that wil be added to the string; 
#a -> first number; b -> second number; mysum -> the sum of a and b
#Date 9 Oct 2021

#(1) Assign a value to the following string by overwritng 'some string'
MyVar='some string'
echo 'the current value of the variable is' $MyVar
echo 'Please enter a new string'
read MyVar
echo 'the current value of the variable is' $MyVar

##(2)Reading multiple values and adding them together
echo 'Enter two numbers separated by space(s)'
read a b 
echo 'you entered' $a 'and' $b '. Their sum is:'
mysum=`expr $a + $b`
echo $mysum