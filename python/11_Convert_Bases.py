import pandas as pd

bases = pd.read_excel(
    "02_Dataset/01_Bases.xlsx"
)

bases.to_csv(
    "02_Dataset/01_Bases_clean.csv",
    index=False,
    encoding="utf-8"
)

print("CSV Created successfully")



# Convert Equipment
equipment = pd.read_excel(
    "02_Dataset/02_Equipment.xlsx"
)

equipment.to_csv(
    "02_Dataset/02_Equipment_clean.csv",
    index=False,
    encoding="utf-8"
)

print("Equipment CSV created successfully")



suppliers = pd.read_excel(
    "02_Dataset/03_Suppliers.xlsx"
)

suppliers.to_csv(
    "02_Dataset/03_Suppliers_clean.csv",
    index=False,
    encoding="utf-8-sig"
)

print("Suppliers CSV created successfully")



import pandas as pd

# Read original transaction Excel file
transactions = pd.read_excel(
    "02_Dataset/04_Transactions.xlsx"
)

print("Original records:", len(transactions))
print("Original columns:", len(transactions.columns))


# Create unique Transaction IDs
transactions["Transaction_ID"] = [
    f"TXN{i:06d}" for i in range(1, len(transactions) + 1)
]


# Convert Transaction_Date to MySQL-compatible format
transactions["Transaction_Date"] = pd.to_datetime(
    transactions["Transaction_Date"],
    dayfirst=True,
    errors="coerce"
).dt.strftime("%Y-%m-%d")


# Check for invalid dates
print(
    "Invalid dates:",
    transactions["Transaction_Date"].isna().sum()
)


# Check Transaction_ID uniqueness
print(
    "Unique Transaction IDs:",
    transactions["Transaction_ID"].nunique()
)


# Create clean CSV
transactions.to_csv(
    "02_Dataset/04_Transactions_clean.csv",
    index=False,
    encoding="utf-8-sig"
)


print("Transactions CSV created successfully")
print("Final records:", len(transactions))
