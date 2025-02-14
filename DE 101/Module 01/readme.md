# Задание для Module01.
## 1.1 Архитектура аналитического решения
Построим архитектуру аналитического решения с разделением на 3 основных слоя:
- ***Source Layer*** 
- ***Storage Layer*** 
- ***Business Layer***

![Архитектура аналитического решения][def2]

[Скачать схему](Data.zip)

## 1.2 Работа в Excel

Задача построить отчеты и дашборд на основе [полученных данных][def] 

- Объединяем данные в одну рабочую таблицу __Orders__ , на основе которой будет построена отчетность и дашборд
- Составляем план отчетности, определяем параметры и показатели-в каком виде будет их визуализация

|***Параметры и показатели***|***Визуализация***|
|---|---|
|Динамика дохода и прибыли|Диаграмма-график|
|Категории товаров сравнение|Линейчатая диаграмма|
|Продажи региональных менеджеров сравнение|Гистограмма|
|Сегменты сравнение|Гистограмма|
|Динамика по сегментам|Диаграмма-график|
|Продажи по штатам|Картограмма|
|Сравнение по регионам|Круговая|
|Возвраты|Круговая|
|Сравнение категорий товаров|Линейчатая диаграмма|
|Оптимальность способов доставки|Линейчатая диаграмма|
|Основные показатели|Спарклайны|

-Создаем сводные таблицы, с учетом раннее установленных параметров и показателей

> Динамика дохода и прибыли 
![1][def3]
> Категории товаров
![2][def4]
> Продажи по штатам
![3][def5]
> Динамика по сегментам
![4][def6]
> Спарклайны основных показателей
![5][def7]
![6][def8]
![7][def9]
![8][def10]


[def]: https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2001/data/Sample%20-%20Superstore.xls
[def2]: https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2001/img/Архитектура%20аналитического%20решения.png
[def3]: https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2001/img/%20Динамика%20дохода%20и%20прибыли.png
[def4]:https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2001/img/Сравнение%20товаров%20по%20категории.png
[def5]:https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2001/img/Продажи%20по%20штатам.png 
[def6]:https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2001/img/Динамика%20продаж%20по%20сегментам.png
[def7]:https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2001/img/Discount%20Sparkline.png
[def8]:https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2001/img/Profit%20Sparkline.png
[def9]:https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2001/img/Quantity%20sparkline.png
[def10]:https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2001/img/Sales%20sparkline.png
[def11]:https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2001/img/dashboard.png

##Создание дашборда
На основе созданных диаграмм собираем дашборд.Добавляем срезы и подключаем их к отчетам.
![Dashboard][def11]
#####[Скачать дашборд](https://github.com/MLKURUNOVA/DataLearn/blob/main/DE%20101/Module%2001/data/%20Dashboard.xlsx)
