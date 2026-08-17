import pandas as pd

transactions = pd.read_csv(
    "02_dataset/04_Transactions_clean.csv"
)


print(transactions.shape)
print(transactions.head())

total_procurement_cost = transactions["Procurement_Cost"].sum()

print(total_procurement_cost)

base_procurement = (
    transactions
    .groupby("Base_ID")["Procurement_Cost"]
    .sum()
    .sort_values(ascending=False)
    .head(1)
)

print(base_procurement)

# Question 3: Equipment with highest Procurement Cost
equipment_procurement = (
    transactions
    .groupby("Equipment_ID")["Procurement_Cost"]
    .sum()
    .sort_values(ascending=False)
    .head(1)
)

print(equipment_procurement)

supplier_procurement = (
    transactions
    .groupby("Supplier_ID")["Procurement_Cost"]
    .sum()
    .sort_values(ascending=False)
    .head(1)
)

print(supplier_procurement)

average_delivery_days = transactions["Delivery_Days"].mean()

print("average delivery days :",average_delivery_days)

delivery_status_percentage = (
    transactions["Delivery_Status"]
    .value_counts(normalize= True)*100
)

print(delivery_status_percentage)

weather_delivery = (
    transactions
    .groupby(["Weather", "Delivery_Status"])
    .size()
)

print(weather_delivery)

supplier_transaction_count = (
    transactions["Supplier_ID"]
    .value_counts()
)

print(supplier_transaction_count)


base_stock = (
    transactions
    .groupby("Base_ID")["Current_Stock"]
    .sum()
    .sort_values(ascending=False)
    .head(1)
)

print(base_stock)

base_low_stock = (

    transactions
    .groupby("Base_ID")["Current_Stock"]
    .sum()
    .sort_values(ascending=True)
    .head(1)
)

print(base_low_stock)

emergency_requests = (
    transactions["Emergency_Request"]
    .value_counts()
)

print(emergency_requests)

emergency_percentage = (
    transactions["Emergency_Request"]
    .value_counts(normalize=True)
    * 100
)

print(emergency_percentage)

transaction_status_percentage = (
    transactions["Status"]
    .value_counts(normalize=True)
    * 100
)

print(transaction_status_percentage)

inspection_percentage = (
    transactions["Inspection_Result"]
    .value_counts(normalize=True)
    * 100
)

print(inspection_percentage)

priority_percentage = (
    transactions["Priority"]
    .value_counts(normalize=True)
    * 100
)

print(priority_percentage)
