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

select * from payments
order by amount desc;
select date_format(paymentDate,'%b') months,concat(format(sum(amount)/1000,0),'K') total from  payments
group by months
having sum(amount) between 500000 and 1000000
order by total desc;


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


/* Day 8
Create table facility. Add the below fields into it.
●	Facility_ID
●	Name
●	State
●	Country

i) Alter the table by adding the primary key and auto increment to Facility_ID column.
ii) Add a new column city after name with data type as varchar which should not accept any null values. */

create table facility (Facility_ID int,Name varchar(30), State varchar(30),Country varchar(30));

alter table facility modify column facility_id int primary key auto_increment;
alter table facility add column city varchar(40)  not null after name;

desc facility;


/* Create table university with below fields.
●	ID
●	Name */

Create table University (ID int, Name varchar(50));
insert into university values 
(1, "       Pune          University     "), 
(2, "  Mumbai          University     "),
(3, "     Delhi   University     "),
(4, "Madras University"),
(5, "Nagpur University");
select * from university;

-- Remove the spaces from everywhere and update the column like Pune University

select ID,length(trim(name)) from university;
select Id,length(name) from university;

select id,right(trim(name), locate(" ",reverse(trim(name)))) second_name from university;
select id,reverse(trim(name)) from university;


select id,concat(trim(left(trim(name),locate(" ",trim(name)))),right(trim(name),locate(" ",reverse(trim(name)))))
full_name from university;


/* Day 9
Create table university with below fields.
●	ID
●	Name
Add the below data into it as it is.
INSERT INTO University
VALUES (1, "       Pune          University     "), 
               (2, "  Mumbai          University     "),
              (3, "     Delhi   University     "),
              (4, "Madras University"),
              (5, "Nagpur University");
Remove the spaces from everywhere and update the column like Pune University etc.
 */
 create table university (id int,name varchar(50));
 select * from university;
 
 select left(trim(name),locate(' ',trim(name))) from university;
 select reverse(left(reverse(trim(name)),locate(' ',reverse(trim(name))))) from university;
 select id,concat(left(trim(name),locate(' ',trim(name))),reverse(left(reverse(trim(name)),locate(' ',reverse(trim(name)))))) name from university;



/* Day 10
Create the view products status. Show year wise total products sold. Also find the percentage of total value for each year. */

select * from products;
select * from orderdetails;
select * from orders;

create view `products status` as
select year(o.orderdate) years,concat(count(*),' ','(',truncate(count(od.productcode)/(select count(*) from orderdetails) * 100,2),'%',')')
 value from orders o left join orderdetails od
using(ordernumber)
left join products p using (productcode)
group by years;
select * from `products status`;



/* Day 11
1)	Create a stored procedure GetCustomerLevel which takes input as customer number and gives the output as either Platinum, 
Gold or Silver as per below criteria.
Table: Customers

●	Platinum: creditLimit > 100000
●	Gold: creditLimit is between 25000 to 100000
●	Silver: creditLimit < 25000 */

select * from customers;

DELIMITER //

create procedure getcustomerlevel( in c_number int, out c_level varchar(30))

begin
select case when creditLimit > 100000 then 'platinum'
when creditlimit between 25000 and 100000 then 'Gold'
when creditlimit < 25000 then 'Silver'
end into c_level  from customers
where customernumber = c_number;
end //
DELIMITER ;
drop procedure getcustomerlevel;
call getcustomerlevel(103,@c_level);
select @c_level;


/* 2)	Create a stored procedure Get_country_payments which takes in year and country as inputs and gives year wise, 
country wise total amount as an output. Format the total amount to nearest thousand unit (K)
Tables: Customers, Payments. */

select * from customers;
select * from payments;

DELIMITER //

create procedure get_country_payments(IN input_year int,out `total amount` varchar(30),in input_country varchar(30))
begin
select  concat(format(sum(p.amount)/1000,2),'K') into `total amount`
from customers C inner join payments p using (customernumber)
where year(p.paymentdate) = input_year and c.country = input_country;

end //
DELIMITER ;
drop procedure get_country_payments;

call get_country_payments(2003,@`total amount` ,'France');
select @`total amount`;


select * from payments;


/* Day 12
1)	Calculate year wise, month name wise count of orders and year over year (YoY) percentage change. 
Format the YoY values in no decimals and show in % sign.
Table: Orders */

select * from orders;


SELECT 
    years,
    months,
    order_count,
    Revenue_previous_year,
    CONCAT(ROUND((order_count - Revenue_previous_year) / Revenue_previous_year * 100), '%') AS yoy_percentage_change
FROM (SELECT 
YEAR(orderdate) AS years,
MONTHNAME(orderdate) AS months,
COUNT(*) AS order_count,
LAG(COUNT(*)) OVER (ORDER BY YEAR(orderdate))  Revenue_previous_year  FROM orders
GROUP BY years, months) AS order2;






/* 2)	Create the table emp_udf with below fields.

●	Emp_ID
●	Name
●	DOB
Add the data as shown in below query.
INSERT INTO Emp_UDF(Name, DOB)
VALUES ("Piyush", "1990-03-30"), ("Aman", "1992-08-15"), ("Meena", "1998-07-28"), ("Ketan", "2000-11-21"), ("Sanjay", "1995-05-21");

Create a user defined function calculate_age which returns the age in years and months (e.g. 30 years 5 months) by accepting DOB column as a parameter. */

create table emp_udf(emp_ID int unique auto_increment,Name varchar(50),DOB date) auto_increment= 100;
insert into emp_udf(name,DOB) values
("Piyush", "1990-03-30"), ("Aman", "1992-08-15"), ("Meena", "1998-07-28"), ("Ketan", "2000-11-21"), ("Sanjay", "1995-05-21");
select * from emp_udf;

DELIMITER //

create function Calculate_age (DOB Date)
returns varchar(50)
deterministic
begin
declare years int;
declare months int;
declare age varchar(50);
set years = timestampdiff(year,dob,curdate());
set months = timestampdiff(month,dob,curdate())-(years*12);
set age = concat(years,' ','years',' ',months,' ','months');
return age;
end //
DELIMITER ;

select calculate_age('1990-03-30') age;

-- other approach 

DELIMITER //
create function cal_age(dob date)
returns varchar(50)
deterministic
begin
declare age varchar(50);
set age = concat(timestampdiff(year,dob,curdate()),' ','years',' ',timestampdiff(month,dob,curdate())-(timestampdiff(year,dob,curdate()) *12),' ','months');
return age;
end //
DELIMITER ;
select cal_age('1990-03-30') age;


/* Day 13
1)	Display the customer numbers and customer names from customers table who have not placed any orders using subquery */

select * from customers;
select * from orders order by customernumber asc;

select customernumber,customername from customers
where customernumber not in (select distinct(customernumber) from orders);

-- 2) Write a full outer join between customers and orders using union and get the customer number, customer name, count of orders for every customer.

select c.customernumber,customername,count(*) total_orders from customers c left join orders o
using (customernumber)
group by c.customernumber,c.customername
union
select o.customernumber,c.customername,count(*) total_orders from orders o left join customers c
using (customernumber)
group by o.customernumber,c.customername;


-- 3)	Show the second highest quantity ordered value for each order number.

select * from orderdetails;
select max(quantityordered*priceeach) max_price from orderdetails
where (quantityordered*priceeach) < (select max(quantityordered*priceeach) from orderdetails);

SELECT orderNumber, MAX(quantityOrdered) AS second_highest_quantity
FROM (SELECT orderNumber, quantityOrdered,
           ROW_NUMBER() OVER (PARTITION BY orderNumber ORDER BY quantityOrdered DESC) AS rn
    FROM orderdetails) AS ranked
WHERE rn = 2
GROUP BY orderNumber;

-- 4) For each order number count the number of products and then find the min and max of the values among count of orders.


select * from orderdetails;

select max(product_count),min(product_count) from (select ordernumber,count(productCode) product_count from orderdetails group by ordernumber) order_details;


/* 5)	Find out how many product lines are there for which the buy price value is greater than the average of buy price value.
 Show the output as product line and its count. */

 select * from productlines;
 select * from products;
 select * from orders;
 
 select productline,count(*) total from products
 where buyprice > (select avg(buyprice)  from products)
 group by productline
 order by total desc;
 
 
 /* Day 14
Create the table Emp_EH. Below are its fields.
●	EmpID (Primary Key)
●	EmpName
●	EmailAddress
Create a procedure to accept the values for the columns in Emp_EH. Handle the error using exception handling concept. 
Show the message as “Error occurred” in case of anything wrong. */

create table Emp_EH (EmpID int,EmpName varchar(50),EmailAddress varchar(50),primary key (EmpID));
select * from emp_eh;
desc emp_eh;

DELIMITER //
create procedure input_data(in EmpID int,in EmpName varchar(50), in EmailAddress varchar(50))
begin
declare exit handler for 1062
begin
SELECT CONCAT('Error occurred: ', EmpID, ',', EmpName, ',', EmailAddress) as message;
end;
insert into Emp_EH values (EmpID,EmpName,EmailAddress);
select * from Emp_EH;
end //
DELIMITER ;
call input_data (1,'nalanda','nalanda@gmail.com');
call input_data (1,'nalanda','nalanda@gmail.com');


/* Day 15
Create the table Emp_BIT. Add below fields in it.
●	Name
●	Occupation
●	Working_date
●	Working_hours

Insert the data as shown in below query.
INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  
 
Create before insert trigger to make sure any new value of Working_hours, if it is negative, 
then it should be inserted as positive. */

create table Emp_BIT(Name varchar(50),Occupaion varchar(50),Working_data date,Working_hours int);
INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);

select * from EMP_BIT;

DELIMITER //
create trigger Input_positivedata
before insert on Emp_BIT for each row
Begin 
if new.Working_hours < 0 then set new.Working_hours = abs(new.Working_hours);
elseif new.Working_hours  is null then set new.working_hours = 0;
end if;
end //
DELIMITER ;
insert into emp_BIT values ('Nalanda', 'Recruiter', '2024-03-01', -6);

 














 

