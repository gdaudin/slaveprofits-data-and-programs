# -*- coding: utf-8 -*-
"""
Created on Fri Jun  4 11:52:40 2021

@author: Hannah
"""

Bisex=[]
notbisex=[]
annee=1
while annee<=2020:
    
    bissextile = False
 
    if annee % 4 == 0:
        bissextile = True
    elif annee % 100 == 0:
        bissextile = True
    elif annee % 400 == 0:
        bissextile = True
    else:
        bissextile = False
 
    if bissextile == True:
        Bisex.append(annee)
    else:
        notbisex.append(annee)
    annee=+1
print(Bisex)

