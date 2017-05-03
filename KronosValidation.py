
# coding: utf-8

# In[62]:

import pandas as pd
import numpy as np
import os
import sqlalchemy as sql
import datetime as dt
import win32com.client
from sqlalchemy import text


# In[85]:

widths = [50,50,50,256,10,10,10]
os.chdir('//epic-fs01/EHR/Reporting/Output/UH/Kronos/Archive')
date = dt.date.today()
date = "{:%Y%m%d}".format(date)
kr = pd.read_fwf('volume_'+date+'.txt',widths=widths)
os.chdir('X:\DBM\!Data\scripts')
query = open('DailyVolume.sql').read()

#TableName = "data"

DB = {
    'drivername': 'mssql+pyodbc',
    'servername': 'EPIC-P-CLARITY',
    'port': '5432',
    'database': 'CLARITY',
    'driver': 'SQL Server Native Client 11.0',
    'trusted_connection': 'yes',
    'legacy_schema_aliasing': False
}

# Create the connection
engine = sql.create_engine(DB['drivername'] + '://' + DB['servername'] +
                       '/' + DB['database'] + '?' + 'driver=' +
                       DB['driver'] + ';' + 'trusted_connection=' +
                       DB['trusted_connection'],
                       legacy_schema_aliasing=DB['legacy_schema_aliasing'])

# Required for querying tables

con = engine.connect()
metadata = sql.MetaData(con)


cl = pd.read_sql(query,con = con)


# In[86]:

kr = [kr.query('FCLTY_NBR == 20')['VOL_QTY'].sum(),kr.query('FCLTY_NBR == 40')['VOL_QTY'].sum()]
cl['Kronos']=kr
cl['Variance']= cl['Clarity']-cl['Kronos']


# In[114]:

date = "{:%m/%d/%Y}".format(dt.date.today())
date
df = cl
email = "{df}"
email = email.format(df=df.to_html())


# In[116]:

olMailItem = 0x0
obj = win32com.client.Dispatch("Outlook.Application")
newMail = obj.CreateItem(olMailItem)
newMail.Subject = "Kronos Volume Reconciliation {dt}".format(dt=date)
newMail.HTMLBody = email
newMail.To = "karen.randa@uhsystem.com; david.mccoy@uhsystem.com"
newMail.Send()
