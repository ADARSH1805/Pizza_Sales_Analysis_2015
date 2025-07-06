CREATE DATABASE pizza_sales_analysis;
USE pizza_sales_analysis;

-- total number of orders placed 
SELECT COUNT(order_id) as total_orders from orders;

-- total revenue of pizza sales 
SELECT ROUND(SUM(order_details.quantity * pizzas.price),2) AS Total_Sales
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id;

/* SELECT order_details.quantity * pizzas.price as TotalSales 
from order_details join pizzas 
on pizzas.pizza_id = order_details.pizza_id; */

-- Check for null values
SELECT 
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_orders,
    SUM(CASE WHEN pizza_id IS NULL THEN 1 ELSE 0 END) AS null_pizzas
FROM order_details;

-- Identify highest pizza price
SELECT pizza_types.name, pizzas.price
FROM pizza_types JOIN pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price DESC LIMIT 1;

-- most commonly ordered pizzas 
SELECT pizza_types.name, SUM(order_details.quantity) as quantity
from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name order by quantity DESC LIMIT 5;

-- total quantity ordered of each category  
SELECT pizza_types.category, SUM(order_details.quantity) as quantity 
from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details 
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by quantity desc;

-- top revenue generating pizzas 
SELECT pizza_types.name, ROUND(SUM(order_details.quantity * pizzas.price), 2) AS total_revenue
FROM pizza_types 
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY total_revenue DESC
LIMIT 5;

-- weekly analysis 
SELECT 
    DAYNAME(orders.date) AS day,
    COUNT(DISTINCT orders.order_id) AS total_orders,
    SUM(order_details.quantity) AS total_pizzas,
    ROUND(SUM(order_details.quantity * pizzas.price), 2) AS revenue
FROM orders
JOIN order_details ON orders.order_id = order_details.order_id
JOIN pizzas ON pizzas.pizza_id = order_details.pizza_id
GROUP BY day
ORDER BY FIELD(day, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

-- monthly 
SELECT 
    MONTHNAME(orders.date) AS month,
    COUNT(DISTINCT orders.order_id) AS total_orders,
    SUM(order_details.quantity) AS total_pizzas_sold,
    ROUND(SUM(order_details.quantity * pizzas.price), 2) AS total_revenue
FROM orders
JOIN order_details ON orders.order_id = order_details.order_id
JOIN pizzas ON pizzas.pizza_id = order_details.pizza_id
GROUP BY month
ORDER BY FIELD(month, 
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December');


-- daywise 
SELECT 
    HOUR(orders.time) AS hour_of_day,
    COUNT(DISTINCT orders.order_id) AS order_count,
    ROUND(SUM(order_details.quantity * pizzas.price), 2) AS revenue
FROM orders
JOIN order_details ON orders.order_id = order_details.order_id
JOIN pizzas ON pizzas.pizza_id = order_details.pizza_id
GROUP BY hour_of_day
ORDER BY hour_of_day;
