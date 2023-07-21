# SQL data upload

import pypyodbc as odbc
import pandas as pd
from datetime import datetime

df = pd.read_csv('vehicles.csv')
print(df)

#df['id'] = pd.to_numeric(df['id'], errors='coerce')
df.drop(columns=['url', 'region_url', 'image_url', 'description'], inplace=True)
df['price'] = pd.to_numeric(df['price'], errors='coerce')
df['year'] = pd.to_numeric(df['year'], errors='coerce')
df['odometer'] = pd.to_numeric(df['odometer'], errors='coerce')
df['lat'] = pd.to_numeric(df['long'], errors='coerce')
df['long'] = pd.to_numeric(df['long'], errors='coerce')
df['posting_date'] = pd.to_datetime(df['posting_date'])
df.fillna('NULL', inplace=True)


print(df.dtypes)

columns = df.columns
print(columns)

records = df.values.tolist()
print(records[:10])

DRIVER = 'SQL Server'
SERVER_NAME = 'DESKTOP-JVL8NV0\MSSQLSERVER04'
DATABASE_NAME = 'Projects'

def connection_string(driver, server_name, database_name):
    conn_string = f"""
        DRIVER={{{driver}}};
        SERVER={server_name};
        DATABASE={database_name};
        Trust_Connection=yes;
    """
    return conn_string

print(connection_string(DRIVER, SERVER_NAME, DATABASE_NAME))

try:
    conn = odbc.connect(connection_string(DRIVER, SERVER_NAME, DATABASE_NAME))
except odbc.DatabaseError as e:
    print('Database Error:')
    print(str(e.value[1]))
except odbc.Error as e:
    print('Connection Error:')
    print(str(e.value[1]))

    print(conn)

sql_insert = '''
    INSERT INTO craiglist_used_cars
    VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
    '''
try:
    cursor = conn.cursor()
    cursor.executemany(sql_insert, records)
    cursor.commit();
except Exception as e:
    cursor.rollback()
    print(str(e))
finally:
    print('Task is complete.')
    cursor.close()
    conn.close()
