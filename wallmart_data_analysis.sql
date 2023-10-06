#-------creating table data and importing data via csv.-----
create database walmart_analysis;

create table sales(
invoice_id varchar (30) not null,
branch varchar (5) not null,
city varchar (30) not null,
customer_type varchar (30) not null,
gender varchar (10) not null,
product_line varchar (100) not null,
unit_price decimal (10,2) not null,
quantity int not null,
vat float (6,4) not null,
total decimal (12,4) not null,
date datetime not null,
time time not null,
payment_method varchar (100) not null,
cogs decimal (10,2) not null,
gross_margin_pct float (11,9) ,
gross_income decimal (12,4) not null,
rating float (2,1)
);

select * from sales;


#feature engineering

#adding time_of_day column

select time,
(case 
when time between '00:00:00' and '12:00:00'
then "morning"
when time between '12:01:00'and '16:00:00'
then "afternoon"
else "evening" end)
as time_of_day
 from sales ;
 
 # adding time of the day to original data
 
 alter table sales
 add column time_of_day varchar (20);

update sales 
set  time_of_day = (case 
when time between '00:00:00' and '12:00:00'
then "morning"
when time between '12:01:00'and '16:00:00'
then "afternoon"
else "evening" end);


#adding day_name, monthname column.

select  
date, 
dayname(date)
from sales;

alter table sales
add column dayname varchar (10);

update sales
set dayname = dayname(date);

select date , monthname (date)
from sales;

alter table sales
add column month_name varchar(10);

update sales
set month_name = monthname (date);

#exploatory data analysis

# product related questions

#1 how many unique product lines does data have?
select distinct product_line from sales;
select count(distinct product_line) from sales;

#2 whats most common payment method ?
select count(payment_method),payment_method from sales
group by payment_method;


#3 whats the most selling product line
select count(product_line), product_line from sales
group by product_line;

# whats the total revenue by month
select sum(total), month_name from sales
group by month_name ;

# which month had the largest cogs
select sum(cogs) , month_name from sales
group by month_name 
order by sum(cogs) desc
limit 1;

#what product line had the lasrgest revenue?
select sum(total),product_line from sales
group by product_line
order by sum(total) desc
limit 1;


#which branch sold more products than average products sold?
select branch,
sum(quantity) as qty from sales
group by branch
having sum(quantity) > (select avg(quantity) from sales);


# most common product line by gender
select product_line , gender,count(gender) from sales
group by gender , product_line
order by count(gender) desc;


#sales data analysis


# number of sales made in each time of the day per weekday
select count(invoice_id) , time_of_day, dayname from sales
group by dayname, time_of_day;

#which type of customer brings in the most revenue?
select sum(total) , customer_type from sales
group by customer_type 
order by sum(total) desc;

#which  city has largest vat 
select sum(vat) , city from sales
group by city 
order by sum(vat) desc;

#customer analysis

# how many unique customer type does data have?
select distinct ( customer_type) from sales;

#how many unique payment methods does data have
select distinct ( customer_type) from sales;

#whats the most common customer type
select count(customer_type),customer_type from sales
group by customer_type;

#which time of the day do the customers give highest ratings
select avg(rating) , time_of_day from sales
group by time_of_day;

##which time of the day do the customers give highest ratings per branch
select avg(rating) , time_of_day,branch from sales
group by time_of_day, branch
order by avg(rating) desc;

#which day of the week has the best avg rating ?

select avg(rating), dayname from sales
group by dayname;

