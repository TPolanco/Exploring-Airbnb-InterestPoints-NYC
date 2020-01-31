import pyodbc, creds
from sqlalchemy import create_engine
import urllib

conn = pyodbc.connect('Driver=' + creds.cred['Driver'] + ';' \
                      'Server=' + creds.cred['Server'] + ';' \
                      'Database=' + creds.cred['Database'] + ';' \
                      'Trusted_Connection=' + creds.cred['Trusted_Connection'])

params = urllib.parse.quote_plus(r'Driver={};Server={};Database={};Trusted_Connection={}'.format(creds.cred['Driver'],\
                                                                                                creds.cred['Server'],\
                                                                                                creds.cred['Database'],\
                                                                                                creds.cred['Trusted_Connection']))
conn_str = 'mssql+pyodbc:///?odbc_connect={}'.format(params)
engine = create_engine(conn_str)