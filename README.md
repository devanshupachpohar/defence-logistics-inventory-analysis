# Defence Logistics & Inventory Analytics

## Project Overview

An end-to-end data analytics project designed to analyze defence logistics, inventory, procurement, supplier performance, and operational readiness across multiple military bases.

The project uses a synthetic defence logistics dataset and combines **SQL, Python, Excel, and Power BI** to transform raw operational data into actionable business insights.

## Business Problem

A defence logistics organization needs to monitor inventory levels, procurement expenditure, supplier performance, delivery efficiency, and operational readiness across multiple bases.

This project provides an analytical solution to identify inventory risks, procurement patterns, supplier performance issues, and delivery-related operational challenges.

## Objectives

- Analyze inventory and stock levels across defence bases
- Identify low-stock and replenishment requirements
- Analyze procurement costs and spending patterns
- Evaluate supplier delivery performance
- Analyze delivery delays and operational factors
- Monitor emergency requests and inspection results
- Build an executive-level Power BI dashboard
- Generate data-driven business insights

## Dataset

The project uses a synthetic dataset containing:

- **15 Defence Bases**
- **100 Equipment Items**
- **10 Suppliers**
- **20,000 Inventory Transactions**

### Main Tables

| Table | Records | Description |
|---|---:|---|
| Bases | 15 | Defence base and warehouse information |
| Equipment | 100 | Equipment master data and minimum stock |
| Suppliers | 10 | Supplier information and ratings |
| Transactions | 20,000 | Inventory, procurement and delivery transactions |

## Tools & Technologies

- **Python** – Data generation, validation and analysis
- **Pandas** – Data processing and analysis
- **MySQL** – Database analysis and business queries
- **Microsoft Excel** – Data analysis and reporting
- **Power BI** – Interactive dashboards and visualization
- **Git & GitHub** – Version control and project documentation

## Key Analysis

### Inventory Analytics
- Stock levels by defence base
- Low-stock identification
- Equipment availability
- Equipment category analysis
- Inventory replenishment requirements

### Supplier Analytics
- Supplier procurement value
- Delivery performance
- Average delivery time
- Delayed and on-time deliveries
- Supplier performance comparison

### Procurement Analytics
- Total procurement expenditure
- Base-wise procurement cost
- Equipment-wise procurement cost
- Supplier-wise procurement spending

### Operational Analytics
- Emergency requests
- Delivery status
- Weather impact on deliveries
- Inspection results
- Transaction status
- Priority distribution

## Key Project Metrics

- **20,000** inventory transactions
- **₹451.66 Billion** total procurement value
- **7.96 days** average delivery time
- **3,042** emergency requests
- **33.65%** on-time deliveries
- **33.21%** delayed deliveries
- **33.14%** critical delays
- **80.21%** inspection pass rate

## Power BI Dashboard

The Power BI dashboard contains three analytical pages:

1. **Executive Dashboard**
   - Total transactions
   - Total procurement cost
   - Emergency requests
   - Delivery performance
   - Base-wise procurement analysis

2. **Supplier Analysis**
   - Supplier procurement value
   - Delivery performance
   - Average delivery time
   - Supplier comparison

3. **Equipment Analysis**
   - Equipment procurement cost
   - Equipment quantity
   - Transaction volume
   - Average delivery time

## Project Structure

```text
defence-logistics-inventory-analysis/
│
├── 02_dataset/
│   ├── 01_Bases_clean.csv
│   ├── 02_Equipment_clean.csv
│   ├── 03_Suppliers_clean.csv
│   └── 04_Transactions_clean.csv
│
├── documentation/
│   ├── 01_Project_requirements.docx
│   ├── 02_Data_Dictionary.xlsx
│   ├── 03_Database_Schema.docx
│   └── 04_Business_Questions.docx
│
├── excel/
│   └── Defence_Losgistics_Inventory_Analysis.xlsx
│
├── powerbi/
│   └── Defence Logistics & Inventory Analytics Dashboard.pbix
│
├── python/
│   ├── 01_Test_Setup.py
│   ├── 02_Read_Bases.py
│   ├── 03_Read_Equipment.py
│   ├── 04_Read_Suppliers.py
│   ├── 05_Equipment_Analysis.py
│   ├── 06_transaction_Analysis.py
│   ├── 08_Generate_Transactions_V2.py
│   ├── 09_Validate_Transactions.py
│   ├── 10_Transaction_Analysis.py
│   └── 11_Convert_Bases.py
│
└── sql/
    └── SQL_Analysis.sql
