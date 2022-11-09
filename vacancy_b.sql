-- б) в каком месяце года выручка от пользователей в возрастном диапазоне 35+ самая большая


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

