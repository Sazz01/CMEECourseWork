#!/usr/bin/env python3

"""This script demonstrates how to do numerical integration in python using the scipy package. Which can be used for complicated functions
 that cannot be integrated analytically using anti-derivatives. In this example we use numerocal integration to solve the Lotka-Volterra 
 (LV) model for a predator-prey system in two-dimensional space (e.g., on land)."""

__appname__ = ['LV1.py']
__author__ = 'Sarah Dobson (sld21@imperial.ac.uk)'
__version__ = '0.0.1'

import sys
import numpy as np
import scipy as sc

import scipy.integrate as integrate

def dCR_dt(pops, t=0):

    """ dCR_dt returns the growth rate of consumer and resource population at any given time step."""


    R = pops[0]
    C = pops[1]
    dRdt = r * R - a * R * C 
    dCdt = -z * C + e * a * R * C
    
    return np.array([dRdt, dCdt])

   
type(dCR_dt)

#assign values to parameters

r = 1.
a = 0.1 
z = 1.5
e = 0.75


#Define the time vector from time point 0 to 15, using 1000 sub-divisions of time:
t = np.linspace(0, 15, 1000)

#Set the initial conditions for the two populations (10 resources and 5 consumers per unit area), and convert the two into an array

R0 = 10
C0 = 5 
RC0 = np.array([R0, C0])

pops, infodict = integrate.odeint(dCR_dt, RC0, t, full_output=True) # pops contains the population trajectories


#now to visualise the data
import matplotlib.pylab as p

f1 = p.figure()
# f1 visualises the densities of the prey and predator populations over time
p.plot(t, pops[:,0], 'g-', label='Resource density') # Plot
p.plot(t, pops[:,1]  , 'b-', label='Consumer density')
p.grid()
p.legend(loc='best')
p.xlabel('Time')
p.ylabel('Population density')
p.title('Consumer-Resource population dynamics')


f1.savefig('../results/LV_model.pdf') 

f2 = p.figure()
#f2 visualises the density of the prey population against the density of the predator population
p.plot(pops[:,0], pops[:,1], 'r-') 
p.grid()
p.xlabel('Resource density')
p.ylabel('Consumer density')# Plot
p.title('Consumer-Resource population dynamics')


f2.savefig('../results/LV_model2.pdf')


"""defining the main argument"""

def main(argv):
    pops, infodict = integrate.odeint(dCR_dt, RC0, t, full_output=True) 

if __name__ == "__main__": 
    """Makes sure the "main" function is called from command line"""  
    status = main(sys.argv)
    sys.exit(status)