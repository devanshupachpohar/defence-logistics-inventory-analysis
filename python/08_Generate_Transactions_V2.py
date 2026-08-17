import pandas as pd
import random
from datetime import datetime, timedelta

# reading master data 
bases = pd.read_excel("02_Dataset/01_Bases.xlsx")
equipment = pd.read_excel("02_Dataset/02_Equipment.xlsx")
suppliers = pd.read_excel("02_Dataset/03_Suppliers.xlsx")

# telling and giving length of master data
print("Bases:", len(bases))
print("Equipment:", len(equipment))
print("Suppliers:", len(suppliers))

transactions = []
for i in range(20000):

    transaction = {} 
    transaction["Transaction_ID"] = f"TXN{i+1:06d}"

    

    # Select one random base
    random_base = bases.iloc[
        random.randint(0, len(bases) - 1)
    ]

    # Store Base_ID in transaction
    transaction["Base_ID"] = random_base["Base_ID"]

    
    # Select one random equipment
    random_equipment = equipment.iloc[
        random.randint(0, len(equipment) - 1)
    ]

    transaction["Equipment_ID"] = random_equipment["Equipment_ID"]


    # Select one random supplier
    random_supplier = suppliers.iloc[
        random.randint(0, len(suppliers) - 1)
    ]

    transaction["Supplier_ID"] = random_supplier["Supplier_ID"]


    # Generate Quantity
    transaction["Quantity"] = random.randint(20, 150)

    # Read Unit Cost from Equipment Master
    transaction["Unit_Cost"] = random_equipment["Unit_Cost"]

    # Generate Quantity Received
    transaction["Quantity_Received"] = random.randint(
        transaction["Quantity"],
        transaction["Quantity"] + 30
    )

    # Generate Quantity Issued
    transaction["Quantity_Issued"] = random.randint(
        5,
        transaction["Quantity_Received"]
    )

    # Calculate Current Stock
    transaction["Current_Stock"] = (
        transaction["Quantity_Received"]
        - transaction["Quantity_Issued"]
    )

    # Calculate Procurement Cost
    transaction["Procurement_Cost"] = (
        transaction["Quantity_Received"]
        * transaction["Unit_Cost"]
    )


    # Generate Transaction Date
    start_date = datetime(2025, 1, 1)

    transaction["Transaction_Date"] = (
        start_date +
        timedelta(days=random.randint(0, 365))
    ).strftime("%d-%m-%Y")


    # Delivery Days
    transaction["Delivery_Days"] = random.randint(1, 15)


    # Delivery Status
    days = transaction["Delivery_Days"]

    if days <= 5:
        transaction["Delivery_Status"] = "On Time"
    elif days <= 10:
        transaction["Delivery_Status"] = "Delayed"
    else:
        transaction["Delivery_Status"] = "Critical Delay"


    # Priority
    transaction["Priority"] = random.choices(
        ["High", "Medium", "Low"],
        weights=[25, 45, 30]
    )[0]


    # Weather
    transaction["Weather"] = random.choices(
        ["Clear", "Rain", "Fog", "Storm"],
        weights=[50, 25, 15, 10]
    )[0]


    # Emergency Request
    transaction["Emergency_Request"] = random.choices(
        ["Yes", "No"],
        weights=[15, 85]
    )[0]


    # Status
    transaction["Status"] = random.choices(
        ["Completed", "In Progress", "Pending"],
        weights=[70, 20, 10]
    )[0]


    # Inspection Result
    transaction["Inspection_Result"] = random.choices(
        ["Passed", "Failed", "Pending"],
        weights=[80, 10, 10]
    )[0]


    transactions.append(transaction)
print(len(transactions))

transactions_df = pd.DataFrame(transactions)
print(transactions_df.head())

transactions_df.to_excel("02_Dataset/04_Transactions.xlsx",index=False)

print("Transactions file created successfully!__Thank you mentor for feeling me confident enough again and to help me gaining my spark again ")