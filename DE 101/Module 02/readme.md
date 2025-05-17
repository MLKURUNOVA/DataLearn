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
limit 1
```
>Результат запроса:
![bestshipmode](https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2002/img/BestShipMode.png)

###### 2.Прибыльность товаров в зависимости от категории.
```
select category,
       round(sum(profit),2)as max_profit
from Orders
group by category
order by sum(profit)desc
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




