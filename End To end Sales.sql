#Use the sales database
use sales;

#Get the count products whose sales amount is less than one
select count(product_code) ,market_code,sales_amount from products
inner join transactions t  on products.p_code= t.product_code
where sales_amount <1 ;

#Check for the revenue trend Annually 
select extract(year from order_date) as order_year, 
sum(sales_amount) as Revenue from transactions t
group by order_year
order by order_year; 

#Check for the revenue trend monthly 
select extract(month from order_date) as order_month, 
sum(sales_amount) as Revenue from transactions t
group by order_month
order by order_month; 


#Customer Distribution across Zones 
select count(distinct t.customer_code) as no_of_customers ,m.zone from transactions t  inner join markets m on t.market_code=m.markets_code group by zone ;

#Top Performing Products:
select p.p_code, 
sum(t.sales_qty) as Total_quantity_sold,
sum(t.sales_amount) as Total_revenue
 from transactions t 	
 join products p on p.p_code = t.product_code 
 group by product_code
 order by Total_revenue DESC
LIMIT 10;


#Customer Lifetime Value
select c.custmer_name,c.customer_type,
sum(t.sales_amount) as CLV
from transactions t 
join customers c on t.customer_code = c.customer_code 
group by c.custmer_name 
order by CLV desc 
limit 10;

#Performance on each market segment
select m.zone,
sum(t.sales_amount) as Total_Revenue
from transactions t 
join markets m on m.markets_code = t.market_code 
group by m.`zone` 
order by Total_Revenue desc;



#Customer Repeat
WITH customer_orders AS (
    SELECT
        customer_code,
        COUNT(DISTINCT EXTRACT(month FROM order_date)) AS order_months
    FROM
        transactions t    
    GROUP BY
        customer_code
)
SELECT
    c.customer_code,  
    COALESCE(SUM(t.sales_amount), 0) AS total_revenue,
    COALESCE(SUM(t.sales_qty), 0) AS total_quantity,
    COALESCE(co.order_months, 0) AS order_monthz
FROM
    customers c
LEFT JOIN
    transactions t ON c.customer_code = t.customer_code
LEFT JOIN
    customer_orders co ON c.customer_code = co.customer_code
GROUP BY
    c.customer_code,  co.order_months DESC
HAVING
    order_months 
ORDER BY
    total_revenue DESC;
   
   
   
   
#Average order value
select extract(year from order_date) as sales_year,
sum(sales_amount)/ count(distinct t.id) as Average_Sales
from transactions t 
group by sales_year desc
order by Average_Sales desc;
  


#Customer Churn#

#Tables
select * from date;
select * from customers;
select * from markets m ;
select * from transactions t ; 
select * from products p ;