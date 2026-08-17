import pandas as pd

transactions = pd.read_csv("02_dataset/04_Transactions_clean.csv")

print(transactions.shape)
print(transactions.columns)
print(transactions.dtypes)
print(transactions.isnull().sum())
print(transactions.duplicated().sum())