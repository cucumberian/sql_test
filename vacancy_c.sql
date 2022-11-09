-- в) какой товар обеспецчивает дает наибольший вклад в выручку за последний год

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