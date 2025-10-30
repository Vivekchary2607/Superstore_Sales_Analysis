use `superstore_sales_database`;
CREATE TABLE Customers (
    CustomerID VARCHAR(20) PRIMARY KEY,
    CustomerName VARCHAR(100),
    Segment VARCHAR(50),
    City VARCHAR(50),
    State VARCHAR(50),
    Region VARCHAR(50),
    PostalCode INT
);

CREATE TABLE Products (
    ProductID VARCHAR(20) PRIMARY KEY,
    ProductName VARCHAR(255),
    Category VARCHAR(50),
    SubCategory VARCHAR(50)
);

-- Orders Table
CREATE TABLE Orders (
    OrderID VARCHAR(20) PRIMARY KEY,
    OrderDate DATE,
    ShipDate DATE,
    ShipMode VARCHAR(50),
    CustomerID VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- OrderDetails Table
CREATE TABLE OrderDetails (
    OrderID VARCHAR(20),
    ProductID VARCHAR(20),
    Sales DECIMAL(10, 2),
    Quantity INT,
    Discount DECIMAL(4, 2),
    Profit DECIMAL(10, 2),
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

select  * from customers limit 5;
select  * from products limit 5;
select  * from orders limit 5;
select  * from orderdetails limit 5;

desc customers;
desc products;
desc orders;
desc orderdetails;
--- 1. View all records from the Customers table
select * from customers;
--- 2. Get customer names from "Consumer" segment
select CustomerName from customers where Segment="Consumer";
--- 3. Show first 10 products in the Products table---
select * from products limit 10;
--- 4. Get all orders placed in the year 2016
select * from orders where YEAR(OrderDate)=2016;
--- 5. Get all orders shipped using "Standard Class"
Select * from orders where ShipMode="Standard Class";
--- 6. Show sales and profit for each order detail
select OrderID,ProductID,Sales,Profit from orderdetails;
---  7. Get all orders where discount was more than 20%
select * from orderdetails where Discount>0.20;
---  8. Get top 5 highest-profit order lines
select * from orderdetails order by profit DESC limit 5; 
 ---  9. Get unique product categories
 select DISTINCT productName from products;
 --- 10. Count total number of orders
 select count(*) from orders;
 
 --- GROUP BY AND AGGREGATIONS
 --- 1. Total sales by product category
 select p.Category,sum(od.Sales) as total_sales from
 products as p join orderdetails as od on p.productID=od.ProductID
 group by p.Category;
 ---  2. Average discount per sub-category
 select p.SubCategory,avg(Discount) as AVG_Discount from
 products as p join orderdetails as od on p.productID=od.productID
 group by p.SubCategory;
 --- 3. Total number of orders placed by each customer
 select c.CustomerName,Count(o.OrderID) as no_of_orders from
 customers as c join orders as o on c.CustomerID=o.CustomerID
 group by c.CustomerName;
 --- 4. Total quantity sold per product
 select p.ProductName,sum(od.Quantity) as Total_Quantity from 
 products as p join orderdetails as od on  p.ProductID=od.ProductId
 group by p.ProductName 
 ORDER BY Total_Quantity DESC;
 ---  5. Total profit per region
 select c.Region,sum(od.profit) as Total_profit 
from orderdetails as od join orders as o on od.OrderID=o.OrderID
join customers as c on o.CustomerID=c.CustomerID
group by c.Region
order by Total_profit DESC;
--- 6. Average sales per month
select month(o.OrderDate),avg(od.Sales) as AVG_Sales
from orderdetails as od join orders as o on od.OrderID=o.OrderID
group by month(o.OrderDate)
order by  month(o.OrderDate) ASC;
---  7. Count of products sold per category
select p.Category,count(od.ProductID) as ProductsSold
from orderdetails as od join products as p on od.ProductID=p.ProductID
group by p.Category;
--- 8. Highest and lowest profit per sub-category
select p.SubCategory,max(od.profit) as Maximum_profit,min(od.profit) as Minimum_profit
from products as p join orderdetails as od on p.ProductID=od.ProductID
group by p.SubCategory;


--- GROUP BY + HAVING
---  1. Get sub-categories with total sales over ₹5,000
select p.SubCategory,sum(od.Sales) as Total_sales from
orderdetails as od join products as p on od.ProductID=p.ProductID
group by p.SubCategory
having Total_sales>5000;

--- 2. Regions with average profit above ₹50
select c.Region,avg(od.Profit) as Avg_profit
from orderdetails as od join orders as o on od.OrderID=o.OrderID
join customers as c on o.CustomerID=c.CustomerID
group by c.Region
having Avg_profit>50;


--- Multi-Table JOINs
--- INNER JOIN
SELECT O.OrderID, C.CustomerName, P.ProductName, OD.Sales
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID
JOIN OrderDetails OD ON O.OrderID = OD.OrderID
JOIN Products P ON OD.ProductID = P.ProductID;

--- LEFT JOIN
--- → Returns all rows from the left table + matching rows from the right.
select c.CustomerName,o.OrderID from 
customers as c left join orders as o on c.CustomerID=o.CustomerID;

--- RIGHT JOIN
--- → Returns all rows from the right table + matching rows from the left.
select o.OrderID,od.OrderID from 
orderdetails as od right join orders as o on o.OrderID=od.OrderID;

---  Subqueries & Nested Logic
--- 1. Get products with sales greater than average
select p.ProductName,sum(od.Sales) as Total_sales from
products as p join orderdetails as od on p.ProductID=od.ProductID
group by p.ProductID having Total_sales>(select Avg(Sales) from orderdetails);

--- 2. Customers who placed more than 1 orders
select CustomerID,count(OrderID) as Total_orders
from orders group by CustomerID
having Total_orders>1;
