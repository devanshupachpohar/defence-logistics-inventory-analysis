import pandas as pd

equipment = pd.read_csv("02_dataset/02_Equipment_clean.csv")

print("===== EQUIPMENT ANALYSIS =====")

print("\nTotal Equipment:")
print(len(equipment))

print("\nMost Expensive Equipment:")
print(equipment.loc[equipment["Unit_Cost"].idxmax()])

print("\nCheapest Equipment:")
print(equipment.loc[equipment["Unit_Cost"].idxmin()])

print("\nAverage Unit Cost:")
print(equipment["Unit_Cost"].mean())