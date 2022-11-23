-- 1. List the names (first and last name) of all the sales persons with their email addresses 
select
	p.FirstName,
	p.Lastname,
	e.EmailAddress,
	p.PersonType
from person.person p
join person.EmailAddress e on p.BusinessEntityID = e.BusinessEntityID
where p.PersonType = 'SP'

-- 2. Display all the orders (number and order date) for the customer James Hendergart, from the most recent order to the oldest ones 
select
	p.FirstName,
	p.LastName,
	soh.OrderDate
from Person.Person p
join Sales.Customer sc on p.BusinessEntityID = sc.PersonID
join Sales.SalesOrderHeader soh on sc.CustomerID = soh.CustomerID
where p.FirstName = 'James' and p.LastName = 'Hendergart'
order by soh.OrderDate desc

-- 3. List all the orders for the customers whose last name begins with B and display their last name 
select
	SC.CustomerID,
	p.LastName,
	SOH.SalesOrderID
from Person.Person p
join Sales.Customer sc on p.BusinessEntityID = sc.PersonID
join Sales.SalesOrderHeader soh on sc.CustomerID = soh.CustomerID
where p.LastName like 'B%'

-- 4. List the number of products by subcategory. Display only the subcategories whose category is “Bikes” 
select
	Count(*) NrProdSub,
	ps.ProductSubcategoryID
from Production.Product pp
join Production.ProductSubcategory ps on pp.ProductSubcategoryID = ps.ProductSubcategoryID
join Production.ProductCategory pc on ps.ProductCategoryID = pc.ProductCategoryID
where pc.Name = 'Bikes'
group by ps.ProductSubcategoryID


-- 5. List ALL the products and their related product model name 
select
	p1.ProductID,
	p1.Name,
	p2.Name as ModelName
from Production.Product p1
join Production.ProductModel p2 on p1.ProductModelID = p2.ProductModelID

-- 6. List the total price by orders (by summing the line prices, without using the LineTotal column), ordered by price descending. Display the order number. 
select
	sod.UnitPrice * (1 - sod.UnitPriceDiscount) * sod.OrderQty as TotalPrice,
	soh.SalesOrderNumber
from Sales.SalesOrderDetail sod
join Sales.SalesOrderHeader soh on sod.SalesOrderID = soh.SalesOrderID
order by TotalPrice desc

-- 7. List the average of the discounts by order for the orders having more than one product. Also display the number of distinct products. 
-- Sort the result starting from the highest average discount 




-- 8. Display the order with the biggest total price (including Tax and Freight). Also display the territory name in which the sale was made. 
select
	top 1 max(soh.TotalDue) as maxim,
	st.Name
from Sales.SalesOrderHeader soh
join Sales.SalesTerritory st on soh.TerritoryID = st.TerritoryID
group by st.Name
order by max(soh.TotalDue) desc


-- 9. Display the first name and last name and the country region name for every person who is not employee and who does not live in a country region which name ends with 'a' 
select
	p.FirstName,
	p.LastName,
	pc.CountryRegionCode,
	pc.Name
from person.person p
join person.BusinessEntityAddress pb on p.BusinessEntityID = pb.BusinessEntityID
join person.Address pa on pb.AddressID = pa.AddressID
join person.StateProvince ps on pa.StateProvinceID = ps.StateProvinceID
join person.CountryRegion pc on ps.CountryRegionCode = pc.CountryRegionCode
where pc.Name not like '%a' and p.PersonType <> 'EM'

-- 10. Display every job title which has both male and female employees. Display only one row for each job title
select distinct
	JobTitle,
	Gender
from HumanResources.Employee


-- 11. For each product, print a column which displays “Cheap” when the product price is smaller than 100, “Average” when the price is smaller than 300, 
-- and “Expensive” if it is bigger. Do not include products with price equal to 0.    
select
	Production.product.Name,
	CASE
          WHEN ListPrice < 100 THEN 'Cheap'
		  WHEN ListPrice < 300 THEN 'Average'
		  ELSE 'Expensive'
		      END AS Price
from Production.Product 
where ListPrice>0

-- 12. Display all products with their category name. Display categories in alphabetical order, then product names 
select
	pp.Name ProductName,
	pc.Name CategoryName
from Production.Product pp
join production.ProductSubcategory ps on pp.ProductSubcategoryID = ps.ProductSubcategoryID
join Production.ProductCategory pc on ps.ProductCategoryID = pc.ProductCategoryID
order by pc.Name, pp.Name

-- 13. Display all the products except the ones that are red 
select
	Production.Product.ProductID,
	Production.Product.Name,
	Production.Product.Color
from production.Product
where Color <> 'Red'

-- 14. Rank ALL the products according to the number of times they have been ordered (number of times they appear in an order, no matter the quantity). 
SELECT
	PP.ProductID,
	CASE
		WHEN Count(POD.ProductID) < 20 then 'Not popular'
		WHEN Count(POD.ProductID) < 60 then 'Popular'
		ELSE 'Very popular'
	END AS Popularity
FROM Production.Product as PP
JOIN Purchasing.PurchaseOrderDetail AS POD ON PP.ProductID = POD.ProductID
GROUP BY PP.ProductID


select
	pp.Name,
	count(sod.ProductID),
	case 
		when count(sod.ProductID) = 0 then 'never ordered'
		when count(sod.ProductID) < 20 then 'not popular'
		when count(sod.ProductID) < 60 then 'popular'
		else 'very popular'
	end as rank_product
from production.Product pp
left join sales.SalesOrderDetail sod on pp.ProductID = sod.ProductID
group by pp.Name













