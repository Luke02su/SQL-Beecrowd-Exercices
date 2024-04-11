create database beecrowd2609;
use beecrowd2609;

create table categories (
	id int primary key,
    name varchar(10) not null
);

create table products (
	id int primary key,
    name varchar(20) not null,
    amount int not null,
    price float not null,
	id_categories int not null,
    
    foreign key fk_id_categories(id_categories) references categories(id)
);

insert into categories values(1, 'wood');
insert into categories values(2, 'luxury');
insert into categories values(3, 'vintage');
insert into categories values(4, 'modern');
insert into categories values(5, 'super luxury');

select * from categories;
SET SQL_SAFE_UPDATES = 0;
update categories set name = 'super luxury' where id = 5;
alter table categories modify name varchar(50);

insert into products values(1, 'Two-doors wardrobe', 100 , 800,	1);
insert into products values(2, 'Dining table', 1000, 560, 3);
insert into products values(3, 'Towel holder', 10000, 25.50, 4);
insert into products values(4,	'Computer desk', 350, 320.50, 2);
insert into products values(5, 'Chair',	3000, 210.64, 4);
insert into products values(6, 'Single bed', 750, 460, 1);

select * from products;

SELECT categories.name, SUM(amount)
FROM products
INNER JOIN categories
ON products.id_categories = categories.id
GROUP BY categories.name;