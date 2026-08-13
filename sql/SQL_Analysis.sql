USE mission_selection;


-- STEP 1: Check transaction records

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT Transaction_ID) AS unique_ids
FROM transactions;


-- STEP 2: Check total records in each table

SELECT
    (SELECT COUNT(*) FROM bases) AS total_bases,
    (SELECT COUNT(*) FROM equipment) AS total_equipment,
    (SELECT COUNT(*) FROM suppliers) AS total_suppliers,
    (SELECT COUNT(*) FROM transactions) AS total_transactions;


-- STEP 3: Overall transaction summary

SELECT
    MIN(Transaction_Date) AS earliest_transaction,
    MAX(Transaction_Date) AS latest_transaction,
    SUM(Procurement_Cost) AS total_procurement_cost,
    SUM(Quantity) AS total_quantity
FROM transactions;


-- STEP 4: Supplier transaction analysis

SELECT
    s.Supplier_ID,
    s.Supplier_Name,
    COUNT(t.Transaction_ID) AS transaction_count,
    SUM(t.Quantity) AS total_quantity,
    SUM(t.Procurement_Cost) AS total_procurement_cost
FROM suppliers s
JOIN transactions t
    ON s.Supplier_ID = t.Supplier_ID
GROUP BY
    s.Supplier_ID,
    s.Supplier_Name
ORDER BY total_procurement_cost DESC;


-- STEP 5: Average procurement cost by supplier

SELECT
    s.Supplier_ID,
    s.Supplier_Name,
    COUNT(t.Transaction_ID) AS transaction_count,
    SUM(t.Procurement_Cost) AS total_procurement_cost,
    ROUND(AVG(t.Procurement_Cost), 2) AS avg_procurement_cost
FROM suppliers s
JOIN transactions t
    ON s.Supplier_ID = t.Supplier_ID
GROUP BY
    s.Supplier_ID,
    s.Supplier_Name
ORDER BY avg_procurement_cost DESC;


-- STEP 6: Supplier delivery performance

SELECT
    s.Supplier_ID,
    s.Supplier_Name,
    COUNT(t.Transaction_ID) AS total_transactions,

    ROUND(
        SUM(CASE
            WHEN t.Delivery_Status = 'On Time' THEN 1
            ELSE 0
        END) * 100.0 / COUNT(t.Transaction_ID),
        2
    ) AS on_time_percentage,

    ROUND(
        SUM(CASE
            WHEN t.Delivery_Status = 'Delayed' THEN 1
            ELSE 0
        END) * 100.0 / COUNT(t.Transaction_ID),
        2
    ) AS delayed_percentage,

    ROUND(
        SUM(CASE
            WHEN t.Delivery_Status = 'Critical Delay' THEN 1
            ELSE 0
        END) * 100.0 / COUNT(t.Transaction_ID),
        2
    ) AS critical_delay_percentage

FROM suppliers s
JOIN transactions t
    ON s.Supplier_ID = t.Supplier_ID
GROUP BY
    s.Supplier_ID,
    s.Supplier_Name
ORDER BY on_time_percentage DESC;


-- STEP 7: Weather and delivery status analysis

SELECT
    Weather,
    Delivery_Status,
    COUNT(*) AS transaction_count,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (PARTITION BY Weather),
        2
    ) AS percentage

FROM transactions
GROUP BY
    Weather,
    Delivery_Status
ORDER BY
    Weather,
    percentage DESC;


-- STEP 8: Base transaction analysis

SELECT
    b.Base_ID,
    b.Base_Name,
    b.Region,
    b.State,
    COUNT(t.Transaction_ID) AS transaction_count,
    SUM(t.Quantity) AS total_quantity,
    SUM(t.Procurement_Cost) AS total_procurement_cost
FROM bases b
JOIN transactions t
    ON b.Base_ID = t.Base_ID
GROUP BY
    b.Base_ID,
    b.Base_Name,
    b.Region,
    b.State
ORDER BY total_procurement_cost DESC;


-- STEP 9: Average procurement cost by base

SELECT
    b.Base_ID,
    b.Base_Name,
    b.Region,
    COUNT(t.Transaction_ID) AS transaction_count,
    SUM(t.Procurement_Cost) AS total_procurement_cost,
    ROUND(AVG(t.Procurement_Cost), 2) AS avg_procurement_cost
FROM bases b
JOIN transactions t
    ON b.Base_ID = t.Base_ID
GROUP BY
    b.Base_ID,
    b.Base_Name,
    b.Region
ORDER BY avg_procurement_cost DESC;


-- STEP 10: Current stock by base

SELECT
    b.Base_ID,
    b.Base_Name,
    b.Region,
    b.State,
    SUM(t.Current_Stock) AS total_current_stock
FROM bases b
JOIN transactions t
    ON b.Base_ID = t.Base_ID
GROUP BY
    b.Base_ID,
    b.Base_Name,
    b.Region,
    b.State
ORDER BY total_current_stock DESC;


-- STEP 11: Find latest transaction for each base

SELECT
    Base_ID,
    Transaction_ID,
    Transaction_Date,
    Current_Stock,

    ROW_NUMBER() OVER (
        PARTITION BY Base_ID
        ORDER BY Transaction_Date DESC, Transaction_ID DESC
    ) AS row_num

FROM transactions;


-- STEP 12: Latest stock + emergency requests

WITH latest_stock AS (
    SELECT
        Base_ID,
        Current_Stock,
        ROW_NUMBER() OVER (
            PARTITION BY Base_ID
            ORDER BY Transaction_Date DESC, Transaction_ID DESC
        ) AS rn
    FROM transactions
),

emergency_analysis AS (
    SELECT
        Base_ID,
        COUNT(*) AS total_transactions,

        SUM(CASE
            WHEN Emergency_Request = 'Yes' THEN 1
            ELSE 0
        END) AS emergency_requests

    FROM transactions
    GROUP BY Base_ID
)

SELECT
    e.Base_ID,
    b.Base_Name,
    l.Current_Stock AS latest_stock,
    e.total_transactions,
    e.emergency_requests,

    ROUND(
        e.emergency_requests * 100.0 /
        e.total_transactions,
        2
    ) AS emergency_rate

FROM emergency_analysis e
JOIN latest_stock l
    ON e.Base_ID = l.Base_ID
    AND l.rn = 1
JOIN bases b
    ON e.Base_ID = b.Base_ID

ORDER BY emergency_rate DESC;


-- STEP 13: Equipment procurement analysis

SELECT
    e.Equipment_ID,
    e.Equipment_Name,
    COUNT(t.Transaction_ID) AS transaction_count,
    SUM(t.Quantity) AS total_quantity,
    SUM(t.Procurement_Cost) AS total_procurement_cost,
    ROUND(AVG(t.Unit_Cost), 2) AS avg_unit_cost
FROM equipment e
JOIN transactions t
    ON e.Equipment_ID = t.Equipment_ID
GROUP BY
    e.Equipment_ID,
    e.Equipment_Name
ORDER BY total_procurement_cost DESC;


-- STEP 14: Equipment and supplier analysis

SELECT
    s.Supplier_ID,
    s.Supplier_Name,
    e.Equipment_ID,
    e.Equipment_Name,
    COUNT(t.Transaction_ID) AS transaction_count,
    SUM(t.Quantity) AS total_quantity,
    SUM(t.Procurement_Cost) AS total_procurement_cost,
    ROUND(AVG(t.Unit_Cost), 2) AS avg_unit_cost
FROM transactions t
JOIN suppliers s
    ON t.Supplier_ID = s.Supplier_ID
JOIN equipment e
    ON t.Equipment_ID = e.Equipment_ID
GROUP BY
    s.Supplier_ID,
    s.Supplier_Name,
    e.Equipment_ID,
    e.Equipment_Name
ORDER BY total_procurement_cost DESC;


-- STEP 15: Supplier delivery time

SELECT
    s.Supplier_ID,
    s.Supplier_Name,
    COUNT(t.Transaction_ID) AS total_transactions,
    ROUND(AVG(t.Delivery_Days), 2) AS avg_delivery_days,
    MIN(t.Delivery_Days) AS minimum_delivery_days,
    MAX(t.Delivery_Days) AS maximum_delivery_days
FROM suppliers s
JOIN transactions t
    ON s.Supplier_ID = t.Supplier_ID
GROUP BY
    s.Supplier_ID,
    s.Supplier_Name
ORDER BY avg_delivery_days DESC;


-- STEP 16: Priority analysis

SELECT
    Priority,
    COUNT(*) AS transaction_count,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage

FROM transactions
GROUP BY Priority
ORDER BY transaction_count DESC;


-- STEP 17A: Inspection result analysis

SELECT
    Inspection_Result,
    COUNT(*) AS transaction_count,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage

FROM transactions
GROUP BY Inspection_Result
ORDER BY transaction_count DESC;


-- STEP 17B: Transaction status analysis

SELECT
    Status,
    COUNT(*) AS transaction_count,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage

FROM transactions
GROUP BY Status
ORDER BY transaction_count DESC;


-- STEP 18: Final combined base analysis

WITH latest_stock AS (
    SELECT
        Base_ID,
        Current_Stock,

        ROW_NUMBER() OVER (
            PARTITION BY Base_ID
            ORDER BY Transaction_Date DESC, Transaction_ID DESC
        ) AS rn

    FROM transactions
),

base_analysis AS (
    SELECT
        Base_ID,
        COUNT(*) AS total_transactions,
        SUM(Procurement_Cost) AS total_procurement_cost,
        ROUND(AVG(Delivery_Days), 2) AS avg_delivery_days,

        SUM(CASE
            WHEN Emergency_Request = 'Yes' THEN 1
            ELSE 0
        END) AS emergency_requests

    FROM transactions
    GROUP BY Base_ID
)

SELECT
    b.Base_ID,
    b.Base_Name,
    b.Region,
    a.total_transactions,
    a.total_procurement_cost,
    l.Current_Stock AS latest_stock,
    a.emergency_requests,

    ROUND(
        a.emergency_requests * 100.0 /
        a.total_transactions,
        2
    ) AS emergency_rate,

    a.avg_delivery_days

FROM base_analysis a
JOIN latest_stock l
    ON a.Base_ID = l.Base_ID
    AND l.rn = 1
JOIN bases b
    ON a.Base_ID = b.Base_ID

ORDER BY emergency_rate DESC;


-- STEP 19A: Supplier performance view

CREATE OR REPLACE VIEW vw_supplier_performance AS

SELECT
    s.Supplier_ID,
    s.Supplier_Name,

    COUNT(t.Transaction_ID) AS total_transactions,
    SUM(t.Procurement_Cost) AS total_procurement_cost,
    ROUND(AVG(t.Procurement_Cost), 2) AS avg_procurement_cost,
    ROUND(AVG(t.Delivery_Days), 2) AS avg_delivery_days,

    SUM(CASE
        WHEN t.Delivery_Status = 'On Time' THEN 1
        ELSE 0
    END) AS on_time_transactions,

    ROUND(
        SUM(CASE
            WHEN t.Delivery_Status = 'On Time' THEN 1
            ELSE 0
        END) * 100.0 / COUNT(t.Transaction_ID),
        2
    ) AS on_time_rate,

    SUM(CASE
        WHEN t.Delivery_Status = 'Delayed' THEN 1
        ELSE 0
    END) AS delayed_transactions,

    ROUND(
        SUM(CASE
            WHEN t.Delivery_Status = 'Delayed' THEN 1
            ELSE 0
        END) * 100.0 / COUNT(t.Transaction_ID),
        2
    ) AS delayed_rate,

    SUM(CASE
        WHEN t.Delivery_Status = 'Critical Delay' THEN 1
        ELSE 0
    END) AS critical_delay_transactions,

    ROUND(
        SUM(CASE
            WHEN t.Delivery_Status = 'Critical Delay' THEN 1
            ELSE 0
        END) * 100.0 / COUNT(t.Transaction_ID),
        2
    ) AS critical_delay_rate

FROM suppliers s
JOIN transactions t
    ON s.Supplier_ID = t.Supplier_ID
GROUP BY
    s.Supplier_ID,
    s.Supplier_Name;


SELECT *
FROM vw_supplier_performance;


-- STEP 19B: Base performance view

CREATE OR REPLACE VIEW vw_base_performance AS

WITH latest_stock AS (
    SELECT
        Base_ID,
        Current_Stock,

        ROW_NUMBER() OVER (
            PARTITION BY Base_ID
            ORDER BY Transaction_Date DESC, Transaction_ID DESC
        ) AS rn

    FROM transactions
),

base_analysis AS (
    SELECT
        Base_ID,
        COUNT(*) AS total_transactions,
        SUM(Procurement_Cost) AS total_procurement_cost,
        ROUND(AVG(Delivery_Days), 2) AS avg_delivery_days,

        SUM(CASE
            WHEN Emergency_Request = 'Yes' THEN 1
            ELSE 0
        END) AS emergency_requests

    FROM transactions
    GROUP BY Base_ID
)

SELECT
    b.Base_ID,
    b.Base_Name,
    b.Region,
    a.total_transactions,
    a.total_procurement_cost,
    l.Current_Stock AS latest_stock,
    a.emergency_requests,

    ROUND(
        a.emergency_requests * 100.0 /
        a.total_transactions,
        2
    ) AS emergency_rate,

    a.avg_delivery_days

FROM base_analysis a
JOIN latest_stock l
    ON a.Base_ID = l.Base_ID
    AND l.rn = 1
JOIN bases b
    ON a.Base_ID = b.Base_ID;


SELECT *
FROM vw_base_performance;


-- STEP 19C: Equipment performance view

CREATE OR REPLACE VIEW vw_equipment_performance AS

SELECT
    e.Equipment_ID,
    e.Equipment_Name,

    COUNT(t.Transaction_ID) AS total_transactions,
    SUM(t.Quantity) AS total_quantity,
    SUM(t.Procurement_Cost) AS total_procurement_cost,
    ROUND(AVG(t.Unit_Cost), 2) AS avg_unit_cost,
    ROUND(AVG(t.Delivery_Days), 2) AS avg_delivery_days

FROM equipment e
JOIN transactions t
    ON e.Equipment_ID = t.Equipment_ID

GROUP BY
    e.Equipment_ID,
    e.Equipment_Name;


SELECT *
FROM vw_equipment_performance;