import pandas as pd

transactions = pd.read_csv("02_dataset/04_Transactions_clean.csv")

print("=" * 50)
print("TRANSACTION ANALYSIS")
print("=" * 50)

print("\nFirst 5 Transactions")
print(transactions.head())

print("\nTotal Transactions")
print(len(transactions))

print("\nTotal Quantity")
print(transactions["Quantity"].sum())

print("\nAverage Quantity")
print(transactions["Quantity"].mean())

print("\nHighest Quantity Transaction")
print(transactions.loc[transactions["Quantity"].idxmax()])

print("\nLowest Quantity Transaction")
print(transactions.loc[transactions["Quantity"].idxmin()])