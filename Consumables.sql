SELECT 
    i.name AS "Item Code",  
    i.item_name AS "Item Name",
    i.item_group AS "Item Group",
    i.stock_uom AS "UOM",
    idd.company AS "Company",
    idd.default_warehouse AS "Default Warehouse",
    idd.expense_account AS "Expense Account",
    itt.item_tax_template AS "Item Tax Template"
FROM 
    `tabItem` AS i
LEFT JOIN 
    `tabItem Default` AS idd ON idd.parent = i.name
LEFT JOIN 
    `tabItem Tax` AS itt ON itt.parent = i.name
WHERE 
    i.item_group IN (
        SELECT name 
        FROM `tabItem Group` 
        WHERE parent_item_group = 'Consumable'
    )
    AND i.has_variants = 0;
