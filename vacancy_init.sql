--  а) какую сумму в среднем в месяц тратит:
--      - пользователи в возрастном диапазоне от 18 до 25 лет включительно
--      - пользователи в возрастном диапазоне от 26 до 35 лет включительно
--  б) в каком месяце года выручка от пользователей в возрастном диапазоне 35+ самая большая
--  в) какой товар обеспецчивает дает наибольший вклад в выручку за последний год
--  г) топ-3 товаров по выручке и их доля в общей выручке за любой год
 
drop table if exists Purchases;
drop table if exists Users;
drop table if exists Items;


create table Users (
    userId int primary key auto_increment,
    age int
);

create table Items (
    itemId int primary key auto_increment,
    price decimal(8, 2)
);

create table Purchases (
    purchaseId int auto_increment primary key,
    userId int not null,
    itemId int not null,
    date date,
    foreign key (userId) references Users (userId),
    foreign key (itemId) references Items (itemId)
);

insert into Users (age) values
  (18),
  (42),
  (23),
  (24),
  (19),
  (32),
  (47),
  (52),
  (19),
  (29),
  (30),
  (42),
  (54),
  (25)
;

insert into Items (price) values
    (123.22),
    (250.99),
    (99.99),
    (621.23),
    (1200.32),
    (15.22),
    (320.09),
    (932.93),
    (215.00),
    (99.99)
;

insert into Purchases (userId, itemId, date) values
    (3, 2, "2022-11-08"),
    (3, 10, "2022-11-08"),
    (3, 2, "2022-11-08"),
    (2, 9, "2022-11-02"),
    (2, 1, "2022-11-02"),
    (1, 8, "2022-03-01"),
    (3, 8, "2021-12-04"),
    (1, 10, "2022-09-23"),
    (6, 7, "2022-03-07"),
    (8, 3, "2022-07-23"),
    (10, 5, "2022-02-23"),
    (9, 5, "2022-02-23"),
    (8, 6, "2022-03-05"),
    (5, 6, "2022-03-06"),
    (2, 6, "2022-03-07"),
    (4, 6, "2022-03-08"),
    (7, 3, "2022-06-05"),
    (5, 4, "2022-07-09"),
    (10, 1, "2022-11-01")
;

