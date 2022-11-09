-- г) топ-3 товаров по выручке и их доля в общей выручке за любой год



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


