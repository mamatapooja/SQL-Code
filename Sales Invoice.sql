USE [JwelexERP]
GO
/****** Object:  StoredProcedure [dbo].[Get_SaleInvoice_DataForReport]    Script Date: 5/9/2025 2:38:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Get_SaleInvoice_DataForReport]                       
@SearchParam  VARCHAR(MAX)  = ''                          
AS                          
SET NOCOUNT ON                          
DECLARE @SqlString  NVARCHAR(Max)                          
DECLARE @SqlString1  NVARCHAR(Max)         
DECLARE @SqlString2  NVARCHAR(Max)         
                          
SET @SqlString ='         
SELECT Item_FinishGood_Master.Finish_Id, dbo.Sales_invoice_Item_Master.Sale_ID,Sales_invoice_Item_Master.SaleInvoice_ID,Customer_Approve_Master.Invoice_No AS ApproveNo,        
dbo.Item_FinishGood_Master.TagNo,dbo.Item_FinishGood_Master.StyleBio,SaleDate,MainCustomer.Cust_Code,Branch_Master.Code As Branch_Code,        
MainCustomer.Cust_Name AS MainCustomer,BillNo,Branch_Name,Sales_Invoice_Master.InvoiceNo,        
Nullif(SaleNetwt.MC1_Wt,0) Gold_Wt,Nullif(SaleNetwt.CHMC1_Wt,0) Chain_Wt,NullIf(CONVERT(NUMERIC(18,3),SaleNetwt.Pure_Wt),0)Pure_Wt,Nullif(Diam.Weight,0) DiamWts,Nullif(Diam.Pcs,0) Diam_Pcs,        
Nullif(Stone.Weight,0) Stone_Wt,Nullif(Stone.Pcs,0) Stone_Pcs,Nullif(Other.Weight,0) Other_Wts,        
Category_Name,Sub_Category_Name,dbo.M_Metal.Metal_Type AS Touch        
FROM dbo.Sales_invoice_Item_Master WITH (NOLOCK)        
LEFT JOIN dbo.Sales_Invoice_Master WITH (NOLOCK) ON dbo.Sales_invoice_Item_Master.Sale_ID = dbo.Sales_Invoice_Master.Sale_ID        
LEFT JOIN dbo.Item_FinishGood_Master WITH (NOLOCK) ON dbo.Item_FinishGood_Master.TagNo = dbo.Sales_invoice_Item_Master.TagNo        
LEFT JOIN dbo.M_Customer WITH (NOLOCK) ON dbo.M_Customer.Cust_ID = dbo.Item_FinishGood_Master.Customer_Id            
LEFT JOIN dbo.M_Category WITH (NOLOCK) ON dbo.M_Category.Category_ID = dbo.Item_FinishGood_Master.Category_Id            
LEFT JOIN dbo.M_Sub_Category WITH (NOLOCK) ON dbo.M_Sub_Category.Sub_Category_ID = dbo.Item_FinishGood_Master.Sub_Category_Id            
LEFT JOIN dbo.M_Metal WITH (NOLOCK) ON dbo.M_Metal.Metal_ID = dbo.Item_FinishGood_Master.Metal_ID            
LEFT JOIN dbo.Branch_Master  WITH (NOLOCK) ON dbo.Sales_Invoice_Master.Branch_ID = dbo.Branch_Master.Branch_ID        
LEFT JOIN dbo.M_Customer AS MainCustomer WITH (NOLOCK) ON MainCustomer.Cust_ID = Sales_Invoice_Master.Cust_ID        
LEFT JOIN dbo.Customer_Approve_Master WITH (NOLOCK) ON dbo.Sales_Invoice_Master.Approve_ID = dbo.Customer_Approve_Master.Approve_Id        
Outer Apply (        
Select Sum(MC1_Wt) MC1_Wt,Sum(CHMC1_Wt) CHMC1_Wt, SUM((MC1_Wt*MC1_Touch) + (CHMC1_Wt*CHMC1_Touch)) AS Pure_Wt  from  Sales_Invoice_Rate_Detail with (Nolock)         
Where  Sales_Invoice_Rate_Detail.SaleInvoice_ID = Sales_invoice_Item_Master.SaleInvoice_ID        
) As SaleNetwt        
outer apply (        
Select Sum(Weigth) As Weight,Sum(Pcs) As Pcs from Sales_invoice_Item_Detail where Sales_invoice_Item_Detail.SaleInvoice_ID = Sales_invoice_Item_Master.SaleInvoice_ID         
and Meterial=''Diamond''        
) As Diam         
outer apply (        
Select Sum(Weigth) As Weight,Sum(Pcs) Pcs from Sales_invoice_Item_Detail where Sales_invoice_Item_Detail.SaleInvoice_ID = Sales_invoice_Item_Master.SaleInvoice_ID         
and Meterial=''Stone''        
) As Stone        
outer apply (        
Select Sum(Weigth) As Weight from Sales_invoice_Item_Detail where Sales_invoice_Item_Detail.SaleInvoice_ID = Sales_invoice_Item_Master.SaleInvoice_ID         
and Meterial=''Other''        
) As Other            
        
 '             
         
SET @SqlString1 ='        
SELECT Item_FinishGood_Master.Finish_Id,dbo.Sales_invoice_Item_Master.Sale_ID,Sales_invoice_Item_Master.SaleInvoice_ID,Customer_Approve_Master.Invoice_No AS ApproveNo,        
dbo.Item_FinishGood_Master.TagNo,dbo.Item_FinishGood_Master.StyleBio,SaleDate,MainCustomer.Cust_Code,Branch_Master.Code As Branch_Code,        
MainCustomer.Cust_Name AS MainCustomer,BillNo,Sales_Invoice_Master.FinalGrossAmt,Branch_Name,        
Nullif(Isnull(SaleNetwt.MC1_Wt,0) - Isnull(GoldFinish.Weight,0),0) Gold_Wt,        
Nullif(Isnull(SaleNetwt.CHMC1_Wt,0) - Isnull(ChainFinish.Weight,0),0)  As Chain_Wt,        
Nullif(Isnull(Diam.Weight,0) - Isnull(DiamFinish.Weight,0),0) DiamWts,        
Nullif(Isnull(Diam.Pcs,0) - Isnull(DiamFinish.Pcs,0),0)  Diam_Pcs,        
Nullif(Isnull(Stone.Weight,0) - Isnull(StoneFinish.Weight,0),0)  Stone_Wt,        
Nullif(Isnull(Stone.Pcs,0) - Isnull(StoneFinish.Pcs,0),0)  Stone_Pcs,        
Nullif(Isnull(Other.Weight,0) - Isnull(OtherFinish.Weight,0),0)  Other_Wts,        
Category_Name,Sub_Category_Name,dbo.M_Metal.Metal_Type AS Touch        
FROM dbo.Sales_invoice_Item_Master WITH (NOLOCK)        
LEFT JOIN dbo.Sales_Invoice_Master WITH (NOLOCK) ON dbo.Sales_invoice_Item_Master.Sale_ID = dbo.Sales_Invoice_Master.Sale_ID        
LEFT JOIN dbo.Item_FinishGood_Master WITH (NOLOCK) ON dbo.Item_FinishGood_Master.TagNo = dbo.Sales_invoice_Item_Master.TagNo        
LEFT JOIN dbo.M_Customer WITH (NOLOCK) ON dbo.M_Customer.Cust_ID = dbo.Item_FinishGood_Master.Customer_Id            
LEFT JOIN dbo.M_Category WITH (NOLOCK) ON dbo.M_Category.Category_ID = dbo.Item_FinishGood_Master.Category_Id            
LEFT JOIN dbo.M_Sub_Category WITH (NOLOCK) ON dbo.M_Sub_Category.Sub_Category_ID = dbo.Item_FinishGood_Master.Sub_Category_Id            
LEFT JOIN dbo.M_Metal WITH (NOLOCK) ON dbo.M_Metal.Metal_ID = dbo.Item_FinishGood_Master.Metal_ID            
LEFT JOIN dbo.Branch_Master  WITH (NOLOCK) ON dbo.Sales_Invoice_Master.Branch_ID = dbo.Branch_Master.Branch_ID        
LEFT JOIN dbo.M_Customer AS MainCustomer WITH (NOLOCK) ON MainCustomer.Cust_ID = Sales_Invoice_Master.Cust_ID        
LEFT JOIN dbo.Customer_Approve_Master WITH (NOLOCK) ON dbo.Sales_Invoice_Master.Approve_ID = dbo.Customer_Approve_Master.Approve_Id         
Outer Apply (        
Select Sum(MC1_Wt) MC1_Wt,Sum(CHMC1_Wt) CHMC1_Wt from  Sales_Invoice_Rate_Detail with (Nolock)         
Where  Sales_Invoice_Rate_Detail.SaleInvoice_ID = Sales_invoice_Item_Master.SaleInvoice_ID        
) As SaleNetwt        
outer apply (        
Select Sum(Weigth) As Weight,Sum(Pcs) As Pcs from Sales_invoice_Item_Detail where Sales_invoice_Item_Detail.SaleInvoice_ID = Sales_invoice_Item_Master.SaleInvoice_ID         
and Meterial=''Diamond''        
) As Diam         
outer apply (        
Select Sum(Weigth) As Weight,Sum(Pcs) Pcs from Sales_invoice_Item_Detail where Sales_invoice_Item_Detail.SaleInvoice_ID = Sales_invoice_Item_Master.SaleInvoice_ID         
and Meterial=''Stone''        
) As Stone        
outer apply (        
Select Sum(Weigth) As Weight from Sales_invoice_Item_Detail where Sales_invoice_Item_Detail.SaleInvoice_ID = Sales_invoice_Item_Master.SaleInvoice_ID         
and Meterial=''Other''        
) As Other        
outer apply (        
Select Sum(Cts + Loss + Cust_Return_Weight+Adjust_Weight- AdjustPlus_Weight - Cust_Weight) As Weight,Sum(Pcs - Cust_Pcs) As Pcs         
from Item_FinishGood_Diamond_Detail where Item_FinishGood_Diamond_Detail.Finish_Id = Item_FinishGood_Master.Finish_Id         
) As DiamFinish         
outer apply (        
Select Sum(G_Weight + Loss + Cust_Return_Weight+Adjust_Weight- AdjustPlus_Weight - Cust_Weight) As Weight         
from Item_FinishGood_Gold_Detail where Item_FinishGood_Gold_Detail.Finish_Id = Item_FinishGood_Master.Finish_Id And Metal_Name = ''Metal''         
) As GoldFinish         
outer apply (        
Select Sum(G_Weight + Loss + Cust_Return_Weight+Adjust_Weight- AdjustPlus_Weight - Cust_Weight) As Weight         
from Item_FinishGood_Gold_Detail where Item_FinishGood_Gold_Detail.Finish_Id = Item_FinishGood_Master.Finish_Id And Metal_Name = ''Chain''        
) As ChainFinish         
outer apply (        
Select Sum(Weight + Loss + Cust_Return_Weight+Adjust_Weight- AdjustPlus_Weight - Cust_Weight) As Weight,Sum(Pcs - Cust_Pcs) Pcs         
from Item_FinishGood_Other_Detail where Item_FinishGood_Other_Detail.Finish_Id = Item_FinishGood_Master.Finish_Id         
and Material=''Stone''        
) As StoneFinish        
outer apply (        
Select Sum(Weight + Loss + Cust_Return_Weight+Adjust_Weight- AdjustPlus_Weight - Cust_Weight) As Weight from Item_FinishGood_Other_Detail         
where Item_FinishGood_Other_Detail.Finish_Id = Item_FinishGood_Master.Finish_Id         
and Material<>''Other''        
) As OtherFinish        
        
'           
        
SET @SqlString2 ='        
Select ''Metal'' As Material, M_Metal_Group.Metal_Group_Name As Shape_Name,M_Metal.Metal_Type As Purity_Name,'''' Size_Name,        
Sum(Isnull(SaleGoldNet.MC1_Wt,0) - Isnull(G_Weight + Loss + Cust_Return_Weight+Adjust_Weight- AdjustPlus_Weight - Item_FinishGood_Gold_Detail.Cust_Weight,0)) As Weight        
from Sales_Invoice_Item_Detail with (Nolock)        
left join M_Metal_Group with (Nolock) on M_Metal_Group.MetalGroup_ID = Sales_Invoice_Item_Detail.Category_ID        
left join M_Metal with (Nolock) on M_Metal.Metal_ID = Sales_Invoice_Item_Detail.Purity_ID        
left join Sales_invoice_Item_Master with (Nolock) on Sales_invoice_Item_Master.SaleInvoice_ID = Sales_Invoice_Item_Detail.SaleInvoice_ID        
LEFT JOIN dbo.Sales_Invoice_Master WITH (NOLOCK) ON dbo.Sales_invoice_Item_Master.Sale_ID = dbo.Sales_Invoice_Master.Sale_ID        
Outer Apply (        
Select MC1_Wt  from  Sales_Invoice_Rate_Detail with (Nolock)         
Where  Sales_Invoice_Rate_Detail.SaleInvoice_ID = Sales_invoice_Item_Master.SaleInvoice_ID and MC1_Touch = M_Metal.Metal_Ratio and Metal_Name = ''Metal''        
) As SaleGoldNet        
left join Item_FinishGood_Master with (Nolock) on Item_FinishGood_Master.TagNo = Sales_invoice_Item_Master.TagNo        
left join Item_FinishGood_Gold_Detail with (Nolock) on Item_FinishGood_Gold_Detail.Metal_GroupId = Sales_Invoice_Item_Detail.Category_ID and         
Item_FinishGood_Gold_Detail.Metal_Id = Sales_Invoice_Item_Detail.Purity_ID and Item_FinishGood_Gold_Detail.Finish_Id = Item_FinishGood_Master.Finish_Id         
where Meterial = ''Gold'' and M_Metal.Metal_Name = ''Metal''         
'  + case when @SearchParam = '' then '' else ' AND ' + @SearchParam End +        
' group by M_Metal_Group.Metal_Group_Name,M_Metal.Metal_Type        
having Sum(Isnull(SaleGoldNet.MC1_Wt,0) - Isnull(G_Weight + Loss + Cust_Return_Weight+Adjust_Weight- AdjustPlus_Weight - Item_FinishGood_Gold_Detail.Cust_Weight,0)) <> 0        
union all        
Select ''Metal'' As Material,M_Metal_Group.Metal_Group_Name As Shape_Name,M_Metal.Metal_Type As Purity_Name,'''' Size_Name,        
Sum(Isnull(SaleChainNet.CHMC1_Wt,0) - Isnull(G_Weight + Loss + Cust_Return_Weight+Adjust_Weight- AdjustPlus_Weight - Item_FinishGood_Gold_Detail.Cust_Weight,0)) As Weight        
from Sales_Invoice_Item_Detail with (Nolock)        
left join M_Metal_Group with (Nolock) on M_Metal_Group.MetalGroup_ID = Sales_Invoice_Item_Detail.Category_ID        
left join M_Metal with (Nolock) on M_Metal.Metal_ID = Sales_Invoice_Item_Detail.Purity_ID        
left join Sales_invoice_Item_Master with (Nolock) on Sales_invoice_Item_Master.SaleInvoice_ID = Sales_Invoice_Item_Detail.SaleInvoice_ID        
LEFT JOIN dbo.Sales_Invoice_Master WITH (NOLOCK) ON dbo.Sales_invoice_Item_Master.Sale_ID = dbo.Sales_Invoice_Master.Sale_ID        
Outer Apply (        
Select CHMC1_Wt  from  Sales_Invoice_Rate_Detail with (Nolock)         
Where  Sales_Invoice_Rate_Detail.SaleInvoice_ID = Sales_invoice_Item_Master.SaleInvoice_ID and ChMC1_Touch = M_Metal.Metal_Ratio and Metal_Name = ''Chain''        
) As SaleChainNet        
left join Item_FinishGood_Master with (Nolock) on Item_FinishGood_Master.TagNo = Sales_invoice_Item_Master.TagNo        
left join Item_FinishGood_Gold_Detail with (Nolock) on Item_FinishGood_Gold_Detail.Metal_GroupId = Sales_Invoice_Item_Detail.Category_ID and         
Item_FinishGood_Gold_Detail.Metal_Id = Sales_Invoice_Item_Detail.Purity_ID and Item_FinishGood_Gold_Detail.Finish_Id = Item_FinishGood_Master.Finish_Id         
where Meterial = ''Gold'' and M_Metal.Metal_Name = ''Chain''         
'  + case when @SearchParam = '' then '' else ' AND ' + @SearchParam End +        
' group by M_Metal_Group.Metal_Group_Name,M_Metal.Metal_Type        
having Sum(Isnull(SaleChainNet.CHMC1_Wt,0) - Isnull(G_Weight + Loss + Cust_Return_Weight+Adjust_Weight- AdjustPlus_Weight - Item_FinishGood_Gold_Detail.Cust_Weight,0)) <> 0        
union all        
Select ''Diamond'' As Material,Shape_Name,Purity_Name,Size_Name,        
Sum(Sales_Invoice_Item_Detail.Weigth - (Cts + Loss + Cust_Return_Weight+Adjust_Weight- AdjustPlus_Weight - Item_FinishGood_Diamond_Detail.Cust_Weight)) As Weight        
from Sales_Invoice_Item_Detail with (Nolock)        
left join M_Diamond with (Nolock) on M_Diamond.Diamond_ID = Sales_Invoice_Item_Detail.Category_ID        
left join M_Purity with (nolock) on M_Purity.Purity_ID = Sales_Invoice_Item_Detail.Purity_ID        
left join M_Size with (Nolock) on M_Size.Size_ID = Sales_Invoice_Item_Detail.Size_ID        
left join Sales_invoice_Item_Master with (Nolock) on Sales_invoice_Item_Master.SaleInvoice_ID = Sales_Invoice_Item_Detail.SaleInvoice_ID        
LEFT JOIN dbo.Sales_Invoice_Master WITH (NOLOCK) ON dbo.Sales_invoice_Item_Master.Sale_ID = dbo.Sales_Invoice_Master.Sale_ID        
left join Item_FinishGood_Master with (Nolock) on Item_FinishGood_Master.TagNo = Sales_invoice_Item_Master.TagNo        
left join Item_FinishGood_Diamond_Detail with (Nolock) on Item_FinishGood_Diamond_Detail.Diamond_Id = Sales_Invoice_Item_Detail.Category_ID and         
Item_FinishGood_Diamond_Detail.Purity_Id = Sales_Invoice_Item_Detail.Purity_ID And Item_FinishGood_Diamond_Detail.Size_Id = Sales_Invoice_Item_Detail.Size_ID        
and Item_FinishGood_Diamond_Detail.Finish_Id = Item_FinishGood_Master.Finish_Id         
where Meterial = ''Diamond''         
'  + case when @SearchParam = '' then '' else ' AND ' + @SearchParam End +        
' Group by  Shape_Name,Purity_Name,Size_Name        
Having Sum(Sales_Invoice_Item_Detail.Weigth - (Cts + Loss + Cust_Return_Weight+Adjust_Weight- AdjustPlus_Weight - Item_FinishGood_Diamond_Detail.Cust_Weight)) <> 0        
union all        
Select ''Stone'' As Material,''Stone'' As Shape_Name,'''' Purity_Name,'''' Size_Name,        
Sum(Sales_Invoice_Item_Detail.Weigth - (Weight + Loss + Cust_Return_Weight+Adjust_Weight- AdjustPlus_Weight - Item_FinishGood_Other_Detail.Cust_Weight)) As Weight        
from Sales_Invoice_Item_Detail with (Nolock)        
left join Sales_invoice_Item_Master with (Nolock) on Sales_invoice_Item_Master.SaleInvoice_ID = Sales_Invoice_Item_Detail.SaleInvoice_ID        
LEFT JOIN dbo.Sales_Invoice_Master WITH (NOLOCK) ON dbo.Sales_invoice_Item_Master.Sale_ID = dbo.Sales_Invoice_Master.Sale_ID        
left join Item_FinishGood_Master with (Nolock) on Item_FinishGood_Master.TagNo = Sales_invoice_Item_Master.TagNo        
left join Item_FinishGood_Other_Detail with (Nolock) on Item_FinishGood_Other_Detail.Shape_Id = Sales_Invoice_Item_Detail.Category_ID and         
Item_FinishGood_Other_Detail.Stone_Id = Sales_Invoice_Item_Detail.Purity_ID And Item_FinishGood_Other_Detail.Size_Id = Sales_Invoice_Item_Detail.Size_ID        
And Item_FinishGood_Other_Detail.Code_Id =Sales_Invoice_Item_Detail.Code_Id  and Item_FinishGood_Other_Detail.Finish_Id = Item_FinishGood_Master.Finish_Id         
where Meterial = ''Stone'' And Item_FinishGood_Other_Detail.Material = ''Stone''         
'  + case when @SearchParam = '' then '' else ' AND ' + @SearchParam End +        
' having Sum(Sales_Invoice_Item_Detail.Weigth - (Weight + Loss + Cust_Return_Weight+Adjust_Weight- AdjustPlus_Weight - Item_FinishGood_Other_Detail.Cust_Weight)) <> 0        
        
'        
                  
                          
IF LTRIM ( RTRIM ( @SearchParam ) ) <> ''                          
BEGIN                          
SET @SqlString = @SqlString + ' WHERE ' + @SearchParam                          
SET @SqlString1 = @SqlString1 + ' WHERE ' + @SearchParam         
END            
        
SET @SqlString = @SqlString + ' Order by Sales_Invoice_Master.SaleDate'                                            
SET @SqlString1 = @SqlString1 + ' Order by Sales_Invoice_Master.SaleDate'               
                     
EXECUTE sp_executesql   @SqlString                   
EXECUTE sp_executesql   @SqlString1          
EXECUTE sp_executesql   @SqlString2   