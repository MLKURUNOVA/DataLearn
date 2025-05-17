# Задание для Module02
## 1.1 Установка БД и загрузка данных
+ Устанавливаем PostgreSQL 17 
+ Загружаем данные c помощью запросов в DBeaver,используя готовые скрипты [orders.sql](https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2002/data/orders.sql), [returns.sql](https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2002/data/returns.sql), [people.sql](https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2002/data/people.sql)
## 1.2 SQL запросы 
###### 1.Самый оптимальный способ доставки.
```
select ship_mode,
       sum(profit) as max_profit
from Orders
group by ship_mode
order by sum(profit) desc
limit 1;
```
>Результат запроса:
![bestshipmode](https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2002/img/BestShipMode.png)

###### 2.Прибыльность товаров в зависимости от категории.
```
select category,
       round(sum(profit),2)as max_profit
from Orders
group by category
order by sum(profit)desc;
```
>Результат запроса:
![categoryProfit](https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2002/img/categoryProfit.png)

###### 3.Прибыль за каждый год.
```
with DateType as (
    select profit,
           CAST(order_date AS DATE) as DateT,
           order_id
    from Orders
)
select EXTRACT(YEAR from DateT) as order_year,
       SUM(profit) as total_profit
from DateType
group by order_year
order by order_year;
```
>Результат запроса:
![YearProfit](https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2002/img/YearTotalProfit.png)

###### 4.Доход,прибыль и сумма общих расходов по сегментам
```
select segment,
       sum(sales)as total_sales,
       sum(profit)as total_profit,
       sum(sales)-sum(profit) as total_expenses
from Orders
group by segment
order by total_sales desc,
         total_profit desc;
```
>Результат запроса:
![SegmentTotalPSE](https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2002/img/SegmentTotalPSE.png)

###### 5. Продажи региональных менеджеров по категориям товаров.
```
select p.person, 
       p.region,
       o.category,
       sum(o.sales)as total_sales
from People p left join orders o on p.region=o.region
group by p.person,
         p.region,
         o.category
order by p.person,total_sales;
```
>Результат запроса:
![CategoryPersonTS](https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2002/img/CategoryPersonTS.png)

###### 6.Количество невозвращенных и возвращенных заказов.
```
select count(
    case 
       when r.order_id is null then o.order_id 
	end) as count_not_returned_orders,
       count(r.order_id)as count_returned_orders
from orders o left join returns r on r.order_id = o.order_id;
```
>Резултат запроса:
![ReturnedNotReturnedOrders](https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2002/img/ReturnedNotReturnedOrders.png)

###### 7.Топ-3 самых прибыльных продажи для каждого менеджера.
```
with ProfitPerson as (
                      select o.product_name,
                             o.profit,o.region,
                             p.person
                      from Orders o join people p on o.region = p.region),
NumProfitPerson as(
                   select product_name,
                          profit,person,
                          row_number()over(partition by person order by profit desc)as number 
                   from ProfitPerson) 
select product_name,person,profit 
from NumProfitPerson 
where number in (1,2,3);







