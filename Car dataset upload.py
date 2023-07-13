import pypyodbc as odbc
import pandas as pd

df = pd.read_csv('vehicles.csv')
print(df)
print(df.columns)

columns = df.columns
print(columns)