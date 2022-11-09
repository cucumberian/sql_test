### Задание


a) какую сумму в среднем в месяц тратит:
- пользователи в возрастном диапазоне от 18 до 25 лет включительно
- пользователи в возрастном диапазоне от 26 до 35 лет включительно

b) в каком месяце года выручка от пользователей в возрастном диапазоне 35+ самая большая

c) какой товар обеспецчивает дает наибольший вклад в выручку за последний год

d) топ-3 товаров по выручке и их доля в общей выручке за любой год


___
## какую сумму в среднем в месяц тратит пользователи в возрастном диапазоне от 18 до 25 лет включительно
[ссылка на файл](./vacancy_a_1.sql)
```sql
select
    sum(overall_spent_money) / count(1) as average_sum_per_month     -- считаю общую сумму по всем поьзователям
    from(
    -- считается для каждого юзера количество денег потраченных а среднем в месяц
    select 
        *,
        greatest(1, DATEDIFF(last_purchase_date, first_purchase_date) / 30) as months,   -- считаю кол-во месяцев, если было только одна покупка, то кол-во месяцев сжде ними = 0, и 0 заменяю на 1
        overall_spent_money / greatest(1, DATEDIFF(last_purchase_date, first_purchase_date) / 30) as money_per_month_per_user
        
    from
    (
        -- группирую по пользователям и считаю для каждого сумму покупок и время первой и последней покупки
        select 
            userId,
            sum(price) as overall_spent_money,
            max(date) as last_purchase_date,
            min(date) as first_purchase_date
        from(
        -- объединенная таблица с пользователями 18-25 лут и их покупками, ценой и датой
            select
                aged_users.userId,
                Purchases.date,
                Items.price,
                aged_users.age
            from Purchases inner join Items
                on Purchases.itemId = Items.itemId
            inner join (select * from Users where age between 18 and 25) as aged_users
            on Purchases.userId = aged_users.userId
        ) as aged_purchases
        group by userId
    ) as sum_dates
) as money_per_user
```
___
## Какую сумму в среднем в месяц тратит пользователи в возрастном диапазоне от 26 до 35 лет включительно
[ссылка на файл](./vacancy_a_2.sql)
```sql
select
    sum(overall_spent_money) / count(1) as average_sum_per_month     -- считаю общую сумму по всем поьзователям
    from(
    -- считается для каждого юзера количество денег потраченных а среднем в месяц
    select 
        *,
        greatest(1, DATEDIFF(last_purchase_date, first_purchase_date) / 30) as months,   -- считаю кол-во месяцев, если было только одна покупка, то кол-во месяцев сжде ними = 0, и 0 заменяю на 1
        overall_spent_money / greatest(1, DATEDIFF(last_purchase_date, first_purchase_date) / 30) as money_per_month_per_user
        
    from
    (
        -- группирую по пользователям и считаю для каждого сумму покупок и время первой и последней покупки
        select 
            userId,
            sum(price) as overall_spent_money,
            max(date) as last_purchase_date,
            min(date) as first_purchase_date
        from(
        -- объединенная таблица с пользователями 26-35 лет и их покупками, ценой и датой
            select
                aged_users.userId,
                Purchases.date,
                Items.price,
                aged_users.age
            from Purchases inner join Items
                on Purchases.itemId = Items.itemId
            inner join (select * from Users where age between 26 and 35) as aged_users
            on Purchases.userId = aged_users.userId
        ) as aged_purchases
        group by userId
    ) as sum_dates
) as money_per_user
;
```
___
## В каком месяце года выручка от пользователей в возрастном диапазоне 35+ самая большая
[ссылка на файл](./vacancy_b.sql)
```sql
select
    month_num,
    sum(price) as month_money_spent
from(
    select
        month(Purchases.date) as month_num,
        Items.price
        from Purchases inner join Items
        on Items.itemId = Purchases.itemId
        inner join (select * from Users where Users.age >= 35) as aged_users
    ) as Purchases_month
    group by month_num
    order by month_money_spent desc
    limit 1
;
```
___
## Какой товар обеспецчивает дает наибольший вклад в выручку за последний год?
[ссылка на файл](./vacancy_c.sql)
```sql
select
    Items.itemId,
    sum(price) as total_spend
    from Items inner join (
        -- выборка всех товаров с датой покупки не больше 365 дней
        select  
            *,
            datediff(CURRENT_TIMESTAMP, date) as days_age
            from Purchases
            where datediff(CURRENT_TIMESTAMP, date) <= 365
        ) as aged_purchases
    group by itemId
    order by total_spend desc
    limit 1
;
```
___
## топ-3 товаров по выручке и их доля в общей выручке за любой год
[ссылка на файл](./vacancy_d.sql)
```sql

-- выборка топ-3 товаров по выручке
select
    Items.itemId,
    sum(price) as total_spent_on_item
from Items inner join Purchases
    on Items.itemId = Purchases.itemId
group by itemId
order by total_spent_on_item desc
limit 3
;


-- выручка топ-3х товаров
-- select
--     sum(total_spent_on_item) as top3_2022_revenue
-- from (
--     select
--         Items.itemId,
--         sum(price) as total_spent_on_item
--     from Items inner join Purchases
--         on Items.itemId = Purchases.itemId
--     group by itemId
--     order by total_spent_on_item desc
--     limit 3
--     ) as items_top3 inner join (select * from Purchases where Year(date) = 2022) as purchases_2022
--     on items_top3.itemId = purchases_2022.itemId
-- ;


-- общая выручка за 2022
-- select
--     sum(price) as overall_2022_revenue
-- from Items inner join (select * from Purchases where Year(date) = 2022) as purchases_2022
-- on Items.itemId = purchases_2022.itemId
-- ;


-- доля топ-3 за 2022 к общей выручке за 2022
select
    B.overall_2022_revenue / A.top3_2022_revenue  as part_top3_in_2022_overall_revenue
from
    (
        select
            sum(total_spent_on_item) as top3_2022_revenue
        from (
            select
                Items.itemId,
                sum(price) as total_spent_on_item
            from Items inner join Purchases
                on Items.itemId = Purchases.itemId
            group by itemId
            order by total_spent_on_item desc
            limit 3
            ) as items_top3 
        inner join (select * from Purchases where Year(date) = 2022) as purchases_2022
        on items_top3.itemId = purchases_2022.itemId
    ) as A, 
    (
        select
            sum(price) as overall_2022_revenue
        from Items inner join (select * from Purchases where Year(date) = 2022) as purchases_2022
        on Items.itemId = purchases_2022.itemId
    ) as B
;

```