import pandas as pd

supplier = pd.read_csv("02_dataset/03_Suppliers_clean.csv")

print("===== Suppliers Master =====")
print(supplier.head())

print("\nTotal Suppliers:", len(supplier))

print("\nAverage Supplier Rating:")
print(supplier["Supplier_Rating"].mean())