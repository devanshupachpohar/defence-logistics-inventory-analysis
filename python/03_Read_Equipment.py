import pandas as pd

equipment = pd.read_csv("02_dataset/02_Equipment_clean.csv")

print("===== Equipment Master =====")
print(equipment.head())

print("\nTotal Equipment:", len(equipment))

print("\nCategories:")
print(equipment["Category"].value_counts())
