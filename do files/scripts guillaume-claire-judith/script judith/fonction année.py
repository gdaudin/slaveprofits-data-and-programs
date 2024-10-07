# -*- coding: utf-8 -*-
"""
Created on Fri Jun  4 10:52:00 2021

@author: Hannah
"""

#print a list with all the bissextine year untill 2020:
bissex=[]
notbissex=[]
a=1
g=['100','200','300','500','600','700','900','1000','1100','1300','1400','1500','1700','1800','1900']

print(g)
while a<=2020:
    if a % 4 == 0:
        bissex.append(a)
        a=+1
    else:
        notbissex.append(a)
        a=+1
bissex.remove(100)
print (bissex)

#function to get the date in a normal format

#def date(n):
#    l=[0,4,6,9,11]
#    h=[1,3,5,7,8,10,12]
#   day=1
 #   month=1
 #   year=1
  #  if year in biss:  
#        if 
#    else:
#        if day+12*month+year!=n:
#            if month in l:
#                if day <30:
#                    day=day+1
#                else:
#                    month=month+1
#                elif:
#                    if year=