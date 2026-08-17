import pandas as pd

# Read the Bases Excel file
bases = pd.read_csv("02_dataset/01_Bases_clean.csv")

# Display first 5 rows
print("===== Bases Data =====")
print(bases.head())

# Display total number of bases
print("\nTotal Bases:", len(bases))