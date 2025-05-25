# Задание для Module02
## 1.1 Установка БД и загрузка данных.
+ Устанавливаем PostgreSQL 17 
+ Загружаем данные c помощью запросов в DBeaver,используя готовые скрипты [orders.sql](https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2002/data/orders.sql), [returns.sql](https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2002/data/returns.sql), [people.sql](https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2002/data/people.sql)
## 1.2 SQL запросы.
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
```
>Результат запроса:
![Top3profitsales](https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2002/img/top3profitsales.png)
## 1.3 Модель данных.
Задача создать модель данных для файла с данными [superstore.xls](https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2001/data/Sample%20-%20Superstore.xls).

_Для архитектуры БД выбрана схема "Звезда" по Инману. Создаем Dimensions таблицы,далее Sales_fact._

- **Концептуальная модель.**

_Определяем основные элементы. Можно сказать,составляем скорее диагрмму основных бизнес процессов   
(Что происходит между элементами?). Намечаем границы будущих таблиц._

![conceptual data model](https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2002/img/conceptual%20data%20model%202.png)

- **Логическая модель.**

_Более точное определение наполнения таблиц в хранилище данных, но без синтаксиса
(тип данных,ограничения null/not null, PK,FK). Доработка модели данных для соответсвия  общей концепции архитектуры БД._

![logical data model](https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2002/img/logical%20data%20model%202.png)

- **Физическая модель.**

_Финальный этап-добавление синтаксиса. Можно сказать,что данный этап непосредственно является DDL._

![physical data model ](https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2002/img/physical%20data%20model%202.png)

- **Generate SQL.**

_Генерируем SQL-запросы --> DDL. Выполняем в SQL клиенте._

- **Делаем ```insert into table```.**

_Заполняем Dimensions и Sales_fact._

[data-modelling-ddl.sql](https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2002/data/data-modelling-ddl.sql.2.sql)- файл со скриптом.

## 1.4 База данных в облаке.

Так как AWS сейчас недоступен в России,я решила воспользоваться облаком [YandexCloud](https://yandex.cloud/ru). 

***Процесс работы:***

1)Создать аккаунт в Яндекс Облаке. 
2)Выбрать ресурс **Кластер PostgreSQL**- я создала кластер с базовыми характеристиками. Важный момент : сделать хост публичным(после создания кластера перейти в хосты и настроить).
3)Получить [сертификат SSL](https://yandex.cloud/ru/docs/managed-postgresql/operations/connect#get-ssl-cert).
4)Подключиться к новой БД через DBeaver.
![newconnection](https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2002/img/New%20connection%20to%20db.png)
5)Построить схемы [stg](https://github.com/Data-Learn/data-engineering/blob/master/DE-101%20Modules/Module02/DE%20-%20101%20Lab%202.1/stg.orders.sql) и [dw](https://github.com/Data-Learn/data-engineering/blob/master/DE-101%20Modules/Module02/DE%20-%20101%20Lab%202.1/from_stg_to_dw.sql).
6)Выполнить несколько запросов.

## 1.5 Как донести данные до бизнес-пользователя.
Я решила воспользоваться сервисом Yandex DataLens.
Для этого:
- Открываем доступ к сервису через настройки кластера.
- Создаем подключение и проверяем соединение _-создаем Датасет._ Интерфейс чем то похож на Google Data Studio из урока.
- Создаем Чарты ( вариант 1:самостоятельно выбрать поля,изменить их агрегацию, выбрать график,
вариант 2: написать sql-запрос,я использовала оба варианта)
- Составляем дашборд
![dashboard1](https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2002/img/dashboard1.png)
![dashboard2](https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2002/img/dashboard2.png)
![dashboard3](https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2002/img/dashboard3.png)
![dashboard4](https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2002/img/dashboard4.png)

Ссылка на [Dashboard](https://datalens.yandex/l2tyetwrbuje7).



