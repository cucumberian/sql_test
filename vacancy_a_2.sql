--  а) какую сумму в среднем в месяц тратит:
--      - пользователи в возрастном диапазоне от 18 до 25 лет включительно
--      - пользователи в возрастном диапазоне от 26 до 35 лет включительно


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
