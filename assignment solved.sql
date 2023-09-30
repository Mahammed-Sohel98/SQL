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



