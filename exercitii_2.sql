--2. Folosind AdventureWorks2019 afisati in mod grafic (nu tabel) numarul de produse per categorie. 
select 
	count(pp.ProductID) as NrProducts,
	pc.Name
from production.Product pp
left join production.ProductSubcategory ps on pp.ProductSubcategoryID = ps.ProductSubcategoryID
left join production.ProductCategory pc on ps.ProductCategoryID = pc.ProductCategoryID
group by pc.Name

--3. Folosind AdventureWorks2019 afisati in mod grafic (nu tabel) evolutia in timp la nivel de an a numarului de comenzi facute de clienti 
--precum si a valorii totale datorate de clienti 
select 
	count(soh.SalesOrderID) as NrOrders,
	sc.CustomerID,
	year(soh.orderdate) as Year,
	sum(soh.TotalDue) as TotalDue
from sales.SalesOrderHeader soh
join sales.Customer sc on soh.CustomerID = sc.CustomerID
group by sc.CustomerID, year(soh.orderdate)
order by Year

--4. Folosind AdventureWorks2019 afisati in mod matrice valoarea totala a comenzilor livrate intr-o provincie intr-un an. 
--Matricea va afisa toate provinciile si toti anii in care avem cel putin o comanda client. 

select
	count(soh.SalesOrderID) as NrOrders,
	psp.Name,
	year(soh.OrderDate) as Year
from sales.SalesOrderHeader soh
join sales.SalesTerritory sst on soh.TerritoryID = sst.TerritoryID
join person.StateProvince psp on sst.TerritoryID = psp.TerritoryID
group by psp.Name, year(soh.OrderDate)
order by Year



