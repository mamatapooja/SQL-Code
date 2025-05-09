SELECT 
    YEAR(Entry_Date) AS Year,
    DATEPART(QUARTER, Entry_Date) AS Quarter,
    COUNT(DISTINCT TagNo) AS TagCount
FROM 
    Item_FinishGood_Master
WHERE 
    Entry_Date IS NOT NULL
GROUP BY 
    YEAR(Entry_Date),
    DATEPART(QUARTER, Entry_Date)
ORDER BY 
    Year, Quarter;
