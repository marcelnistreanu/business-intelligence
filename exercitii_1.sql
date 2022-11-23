--1. Afisati toate produsele (numele produselor) care nu au fost niciodata comandate

select 
	dp.EnglishProductName, 
	fis.OrderDate
from [dbo].[DimProduct] dp 
left join [dbo].[FactInternetSales] fis on dp.ProductKey = fis.ProductKey
where fis.orderdate is null



--2. Afisati catitatea comandata la nivel de an fiscal, trimestru fiscal si provincie. Provincia va fi afisata in formatul <(Code) Nume>.
--De exemplu, daca o privincie are codul "PROV1" si numele "NUME PROVINCIE 1" atunci rezultatul afisat sa fie (PROV1) NUME PROVINCIE 1

select
	sum(fis.OrderQuantity) as OrderQuantity,
	FiscalYear,
	FiscalQuarter,
	CONCAT('(', StateProvinceCode, ')', ' ', StateProvinceName) as Provincie
from DimDate dd
join FactInternetSales fis on dd.DateKey = fis.OrderDateKey
join DimCustomer dc on fis.CustomerKey = dc.CustomerKey
join DimGeography dg on dc.GeographyKey = dg.GeographyKey
group by FiscalYear, FiscalQuarter, CONCAT('(', StateProvinceCode, ')', ' ', StateProvinceName)


select * from FactInternetSales


--3. Afisati numarul de produse achizitionate intre 25 si 26 decembrie in fiecare an calendaristic. 
--Afisati motivul pentru care au fost achizitionate (DimSalesReason)

select 
	count(fis.OrderDate) as NrOfOrders, 
	year(fis.OrderDate) as Year,
	dsr.SalesReasonName
from FactInternetSales fis
left join FactInternetSalesReason fsr on fsr.SalesOrderNumber = fis.SalesOrderNumber
left join DimSalesReason dsr on fsr.SalesReasonKey = dsr.SalesReasonKey
where month(fis.OrderDate) = 12 and (day(fis.OrderDate) between 25 and 26)
group by year(OrderDate), dsr.SalesReasonName
order by year(OrderDate)


--4. Pentru ziua 30 Iunie 2014 afisati valoarea totala a stocului (cost * balanta) la nivel de categorie si subcategorie. 
--Pentru produsele care nu au asignata subcategorie/categorie sa se afiseze 'N/A'

select 
	(UnitCost * UnitsBalance) as ValTotala,
	case
		when dps.EnglishProductSubcategoryName is null then 'N/A'
		else dps.EnglishProductSubcategoryName
	end as EnglishProductSubcategoryName,
	case
		when dpc.EnglishProductCategoryName is null then 'N/A'
		else dpc.EnglishProductCategoryName
	end as EnglishProductCategoryName
from FactProductInventory fpi
left join DimProduct dp on fpi.ProductKey = dp.ProductKey
left join DimProductSubcategory dps on dp.ProductSubcategoryKey = dps.ProductSubcategoryKey
left join DimProductCategory dpc on dps.ProductCategoryKey = dpc.ProductCategoryKey
where day(MovementDate) = 30 and month(MovementDate) = 6 and year(MovementDate) = 2014

