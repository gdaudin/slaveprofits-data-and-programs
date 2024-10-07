#!/usr/bin/env python
# coding: utf-8

# In[9]:


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import numpy as np

#for algorythme which has to treat the tstd and link missing informations with our database
import requests
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.util.retry import Retry
import time


# In[10]:


##load data


# In[11]:


df_gd_venture=pd.read_csv(r'''C:\Users\Hannah\Documents\stage\slaveprofits2\Venture database GD.csv''')
df_gd_cashflow=pd.read_csv(r'''C:\Users\Hannah\Documents\stage\slaveprofits2\Cash flow database GD.csv''')
df_kr_venture=pd.read_csv(r'''C:\Users\Hannah\Documents\stage\slaveprofits2\Venture database KR - new.csv''')
df_kr_cashflow=pd.read_csv(r'''C:\Users\Hannah\Documents\stage\slaveprofits2\Cash flow database KR - new.csv''')
df_dr_venture=pd.read_csv(r'''C:\Users\Hannah\Documents\stage\slaveprofits2\Venture database DR.csv''')
df_dr_cashflow=pd.read_csv(r'''C:\Users\Hannah\Documents\stage\slaveprofits2\Cash flow database DR.csv''')
#df_gd_venture=pd.read_csv(r'''C:\Users\winer\Documents\judith\slaveprofits\Venture database GD.csv''')
#df_gd_cashflow=pd.read_csv(r'''C:\Users\winer\Documents\judith\slaveprofits\Cash flow database GD.csv''')
##df_kr_venture=pd.read_csv(r'''C:\Users\winer\Documents\judith\slaveprofits\Venture database KR - new.csv''')
#df_dr_venture=pd.read_csv(r'''C:\Users\winer\Documents\judith\slaveprofits\Venture database DR.csv''')
#df_kr_cashflow=pd.read_csv(r'''C:\Users\winer\Documents\judith\slaveprofits\Cash flow database KR - new.csv''')
#df_dr_cashflow=pd.read_csv(r'''C:\Users\winer\Documents\judith\slaveprofits\Cash flow database DR.csv''')
#df_stdt_2019=pd.read_csv(r'''C:\Users\Hannah\Documents\stage\slaveprofits2\STDT.csv''')
df_stdt_2019=pd.read_csv(r'''C:\Users\Hannah\Documents\STDT.csv''',header=None,sep=',,',  engine='python', error_bad_lines=False) 


# ### correcting typo

# In[12]:


df_gd_cashflow['value']=df_gd_cashflow['value'].replace(',','.',regex=True)
df_gd_cashflow.head(3)
# seems perfect!! ^^


# In[13]:


## looking at the missing values


# In[14]:


df_gd_venture.isna().sum()


# In[15]:


#the most ennuying thing is probably when we miss values from "Voyage-ID in TSTD"
#du to the number of value from the slave-variable we miss, I think we won't be able to really treat many questions relative to that.


# In[16]:


df_gd_cashflow.isna().sum()


# In[17]:


#question: could we be able to get some informations about the fateoftransaction in the TSTD?
#


# In[18]:


df_dr_venture.isna().sum()


# In[19]:


df_dr_cashflow.isna().sum()


# In[20]:


df_kr_venture.isna().sum()


# In[21]:


df_dr_cashflow.isna().sum()


# In[22]:


#we will have to download all the data of the TSTD, and to take informations to solve this issue of missing value. 
#I will have to do an algorithme for that. See work of Imrane Boucher


# In[ ]:





# In[23]:


### merging


# In[24]:


# join the three df of the centure
df_venture=pd.concat([df_dr_venture,df_gd_venture, df_kr_venture])
#ok
#join the three df of  the cashflow
df_cashflow=pd.concat([df_dr_cashflow,df_gd_cashflow, df_kr_cashflow])
df_venture.head(3)
#ok


# In[25]:


#l=[intermediarytradingoperation,estimate,dateoftransation, Name of the captain,Place of outfitting ]
#idee! faire une liste des variables que l'on doit retrouver dans la Stdt
#donc: besoin de voir comment elles s'appellent: si nom different, ne rien faire (?), et on ne pourra pas faire algo à boucle
# sinon, remplacer

#def algo_stdt (document):
 #   for each var in df_venture['VentureID']:
        
    


# In[26]:


#merge venture and cashflow
df_total=pd.merge(df_cashflow, df_venture, on="VentureID", how='inner')
df_total.head(45)
#ça m'a l'air d'etre bon!


# In[38]:


a=len(df_stdt_2019.index)
print(a)


# In[27]:


df_total.isna().sum()


# # correction of dates in the STDT

# #define a list with all the bissextine years
# 
# bissex=[]
# notbissex=[]
# a=1582
# g=['100','200','300','500','600','700','900','1000','1100','1300','1400','1500','1700','1800','1900']
# while a<=1970:
#     if a % 4 == 0:
#         bissex.append(a)
#         
# for elem in g: 
#     bissex.remove(elem)
# #we want to know the number of bissextine years between 1582 and 1970:
# print("the number of bissextine years between 1582 and 1970 is", bissex.len() )

# In[40]:



#algo to solve the problem of the year:
#it seems that in this format, the date means a sum of seconds, since 1782-10-14
l=['DATEDEPA','DATEDEPB','DATELAND2','DATELAND3','DDEPAM'] 
#with this list, we will enter here all the date of the variable we want to convert in a normal format
#we will use a function which use the same system as the SPSS one, but since the first january of 1970
#387 ans (dont 93n années bissextiles selon notre algo) et 78 jours: soit 141426 jours (à multiplier par 24*60*60 pour avoir le nombre de secondes)
#for x in l:
#    df_stdt_2019.loc[df_stdt_2019[x] != 'NAN']=df_stdt_2019[x]-203653440*60
for i in range (1,36079):
    if df_stdt_2019.loc[df_stdt_2019[i,'DATEDEPA'] != 'NAN']:
        df_stdt_2019[i,'DATEDEPA']=df_stdt_2019[i,'DATEDEPA']-203653440*60
#expressing dates as number of days since the 01-01-01
df_stdt_2019.head(5)
 
                           ## Algorithme to change sum of days as dates##

