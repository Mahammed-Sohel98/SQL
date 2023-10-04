use classicmodels;
/* Day 3

1)	Show customer number, customer name, state and credit limit from customers table for below conditions.
Sort the results by highest to lowest values of creditLimit.

●	State should not contain null values
●	credit limit should be between 50000 and 100000 */

select * from customers;

select 	customernumber,customername,state,creditlimit from customers
where state is not null and creditlimit between 50000 and 100000
order by creditlimit desc;


-- 2)	Show the unique productline values containing the word cars at the end from products table.

select * from products;

select distinct productline from products
where productline like '%cars';


/* Day 4

1)	Show the orderNumber, status and comments from orders table for shipped status only. 
If some comments are having null values then show them as “-“. */

select * from orders;

select ordernumber,status,ifnull(comments,'-') from orders
where status = 'shipped';


/* 2)	Select employee number, first name, job title and job title abbreviation from employees table based on following conditions.
If job title is one among the below conditions, then job title abbreviation column should show below forms.
●	President then “P”
●	Sales Manager / Sale Manager then “SM”
●	Sales Rep then “SR”
●	Containing VP word then “VP”  */

select * from employees;

select employeenumber,firstname,jobtitle,case 
												when jobtitle = 'president' then 'P'
                                                when jobtitle like '%sales manager%' then 'SM'
                                                when jobtitle like '%sale manager%' then 'SM'
                                                when jobtitle = 'sales rep' then 'SR'
                                                when jobtitle like '%vp%' then 'VP'
                                                end job_abbr
from employees;



/* Day 5:

1)	For every year, find the minimum amount value from payments table */


select * from payments;

select year(paymentdate) years, min(amount) from payments
group by year(paymentdate)
order by years;

/* 2)	For every year and every quarter, find the unique customers and total orders from orders table. 
Make sure to show the quarter as Q1,Q2 etc. */

select * from orders;

select Count(distinct customernumber) customernumber, year(orderdate) years,concat('Q', quarter(orderdate)) quarters,count(*) totalorder
from orders
group by  years,quarters;


/* 3)	Show the formatted amount in thousands unit (e.g. 500K, 465K etc.) for every month (e.g. Jan, Feb etc.) 
with filter on total amount as 500000 to 1000000. Sort the output by total amount in descending mode */

select * from payments;

select date_format(paymentdate,'%b') months, concat(format(sum(amount)/1000,0),'K') amount
from payments
group by months
order by amount desc;


/* Day 6:

1)	Create a journey table with following fields and constraints.

●	Bus_ID (No null values)
●	Bus_Name (No null values)
●	Source_Station (No null values)
●	Destination (No null values)
●	Email (must not contain any duplicates)   */

create table journey (Bus_ID int not null,Bus_Name varchar(50) not null,Source_Station varchar(50) not null,
Destination varchar(50) not null,Email varchar(50) unique);

insert into journey  values (123,'kunal','cuttack','Sundargarh','bus@gmail.com'),
(124,'Sitaram','Bhubaneswar','Rourkela','rkl@gmail.com'),
(134,'Dolphin','Sambalpur','Hyderabad','hyd@gmail.com');

insert into journey (bus_id,bus_name,source_station,destination) values
(125,'kunal','cuttack','Sundargarh');
select * from journey;

/* 2)	Create vendor table with following fields and constraints.

●	Vendor_ID (Should not contain any duplicates and should not be null)
●	Name (No null values)
●	Email (must not contain any duplicates)
●	Country (If no data is available then it should be shown as “N/A”)  */

create table Vendor (Vendor_ID varchar(30) unique not null, Name varchar(50) not null,
Email varchar(50) unique,Country varchar (40) default 'N/A');


select * from vendor;

insert into vendor values ('ab123','Santosh','sat@gmail.com','India'),
('ac223','Martin','mat@gmail.com','USA'),
('ad423','Tanjiro','tan@gmail.com','Japan');
insert into vendor(vendor_id,name,email) values ('bc123','utopia','utp@gmail.com');
insert into vendor values ('bf123','xusua','xua@gmail.com','');

/* 3)	Create movies table with following fields and constraints.

●	Movie_ID (Should not contain any duplicates and should not be null)
●	Name (No null values)
●	Release_Year (If no data is available then it should be shown as “-”)
●	Cast (No null values)
●	Gender (Either Male/Female)
●	No_of_shows (Must be a positive number)  */

create table Movies (Movie_ID int not null unique,Name varchar(50) not null,
Release_Year varchar(10) default '-',Cast varchar(100) not null ,Gender varchar(20), check (gender = 'Male' or gender ='Female'),
No_of_Show int, check( no_of_show > 0));

insert into movies values (3434,'KGF 2',2022,'Yash','Male',20),
(4545,'Bajigar',2020,'Kajol','Female',10),
(5656,'Jawan',2023,'SRK','Male',30);

insert into movies(movie_id,name,cast,gender,no_of_show) values
(1212,'Bahubali','Prabhash','Male',40),
(5454,'Panga','Kagnaranawat','female',3);

select * from Movies;

select table_name, constraint_name,constraint_type
from information_schema.table_constraints
where table_schema = 'classicmodels' and table_name = 'Movies';

/* 4)	Create the following tables. Use auto increment wherever applicable

a. Product
✔	product_id - primary key
✔	product_name - cannot be null and only unique values are allowed
✔	description
✔	supplier_id - foreign key of supplier table

b. Suppliers
✔	supplier_id - primary key
✔	supplier_name
✔	location

c. Stock
✔	id - primary key
✔	product_id - foreign key of product table
✔	balance_stock  */


create table Product (Product_ID int, Product_Name varchar(50) not null ,
Description varchar(1000),Supplier_ID int,constraint unique_name unique(Product_Name),
primary key (Product_ID),constraint fk_sid foreign key  (supplier_ID) references  Suppliers(Supplier_ID));

Create table Suppliers (Supplier_ID int , Supplier_Name varchar(50), Location varchar(50),
primary key (Supplier_ID));

create table Stock (ID int,Product_ID int, Balance_stock int,
primary key (ID),constraint fk_pid foreign key  (Product_ID) references Product(Product_ID));

select table_name,column_name,constraint_name,referenced_table_name,referenced_column_name
from information_schema.key_column_usage
where table_schema = 'classicmodels' and  table_name = 'Product';

drop table product;
drop table suppliers;
drop table stock;

select table_name,column_name,constraint_name,referenced_table_name,referenced_column_name
from information_schema.key_column_usage
where table_schema  = 'classicmodels' and table_name = 'Suppliers';


select table_name,column_name,constraint_name,referenced_table_name,referenced_column_name
from information_schema.key_column_usage
where table_schema = 'classicmodels' and table_name = 'Stock';


/* Day 7
1)	Show employee number, Sales Person (combination of first and last names of employees), 
unique customers for each employee number and sort the data by highest to lowest unique customers.
Tables: Employees, Customers. */

select * from employees;
select * from customers;
 
Select distinct E.employeenumber,concat(E.firstname,' ',E.lastname) `Sales Person`,count(*) unique_customer from employees E
inner join customers C on e.employeenumber =  c.salesrepemployeenumber
group by E.employeenumber,`Sales Person`
order by unique_customer desc;


/* 2)	Show total quantities, total quantities in stock, left over quantities for each product and each customer. 
Sort the data by customer number.

Tables: Customers, Orders, Orderdetails, Products */

Select * from customers;
select * from orders;
select * from orderdetails;
select * from products;

select C.customernumber,C.customername,p.productcode,p.productname, sum(OD.quantityordered) `total quantities`,
sum(P.quantityinstock) `total quantities  in stock`,
sum(P.quantityinstock) - sum(OD.quantityordered) `left queantities` from customers C 
inner join  orders O on c.customernumber = O.customernumber
inner join  orderdetails OD on O.ordernumber = od.ordernumber
inner join products P on od.productcode =  p.productcode
group by C.customernumber,C.customername,p.productcode,p.productname
order by C.customernumber;


/* 3)	Create below tables and fields. (You can add the data as per your wish)

●	Laptop: (Laptop_Name)
●	Colours: (Colour_Name)
Perform cross join between the two tables and find number of rows. */

create table laptop (laptop_name varchar(30));
create table colours (colour_name varchar(30));
insert into laptop values('Dell'),('HP');
insert into colours values ('Black'),('White'),('Silver');
truncate colours;
select * from laptop;
select * from colours;

select L.laptop_name,C.colour_name from laptop L cross join colours C
order by l.laptop_name;


/* 4)	Create table project with below fields.

●	EmployeeID
●	FullName
●	Gender
●	ManagerID */

create table Project (EmployeeID int primary key, FullName varchar(20),Gender varchar(20),ManagerID int);


INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3),
(2, 'Priyanka', 'Female', 1),
(3, 'Preety', 'Female', NULL),
(4, 'Anurag', 'Male', 1),
(5, 'Sambit', 'Male', 1),
(6, 'Rajesh', 'Male', 3),
(7, 'Hina', 'Female', 3);

select * from project;

-- Find out the names of employees and their related managers

select B.fullname manager_name, A.fullname emp_name from project A right join project B
on A.managerID=B.EmployeeID;

select a.fullname emp_name,b.fullname manger_name from project A join project B
on a.managerid=b.employeeid;










