create table menu_items(
menu_item_id int identity(1,1) PRIMARY KEY,
name varchar(100) not null,
price decimal(8,2),
active varchar(20) ,
dateOfLaunch date,
category varchar(20) ,
freeDelivery varchar(20),
action varchar(20)
);
go
--C001(a)
insert into menu_items(name,price,active,dateOfLaunch,category,freeDelivery) 
values('SandWich',99.00,'Yes','2017-03-1','Main Course','Yes'),
('Burger',129.00,'Yes','2017-12-23','Main Course','No'),
('Pizza',149.00,'Yes','2017-08-21','Main Course','No'),
('French Fries',57.00,'No','2017-07-02','Staters','Yes'),
('Chocolate Brownie',32.00,'Yes','2022-11-02','Deserts','Yes')
go
--C001(b)
select * from menu_items
go
--C002
select * from menu_items where dateOfLaunch < GETDATE() and active = 'yes'
go

--C003(a) (select based on menu item id)
create procedure getMenuItems (@id int)
as select * from menu_items where menu_Item_Id = @id
go
exec getMenuItems @id = '1'
go
--C003(b) (update all columns based on menu item id)
create procedure editMenuItems (@id int, @name varchar(100),@price decimal(8,2),@active varchar(20),@dateOfLaunch date,@category varchar(20),@freeDelivery varchar(20))
as
update menu_items
set name = @name, price = @price, active = @active, dateOfLaunch = @dateOfLaunch, category = @category, freeDelivery = @freeDelivery
where menu_Item_Id = @id
go
exec editMenuItems @id='1',@name = 'Lasagna', @active ='No', @dateOfLaunch = '2020-01-27', @category = 'Staters', @freeDelivery = 'No',@price = '90.00'
go
--C004(create user and cart table)
create table users(
user_id int PRIMARY  KEY identity(1,1),
user_name varchar(20)
)
go
create table cart(
cart_id int PRIMARY KEY identity(1,1),
user_id int,
menu_Item_Id int,
constraint fk foreign key (user_id) references users(user_id),
constraint fK1 foreign key (menu_Item_Id) references menu_items(menu_Item_Id)
)
go
insert into users (user_name) values("RESHU"),("RICKU")
go
insert into cart (user_id, menu_Item_Id)
values(1,4),(1,3),(1,1)
 go
 --C005 (getting details)
 create procedure CartDetails (@user_id int)
 as
 select * from menu_items m
 inner join cart c on c.menu_Item_Id = m.menu_Item_Id
 where c.user_id=@user_id
 go 
 exec CartDetails @user_id = '1'
 go
 --getting total cost
 create procedure TotalCost (@user_id int)
 as
 select sum(m.price) from cart c
 inner join menu_items m on m.menu_Item_Id = c.menu_Item_Id
 where c.user_id = @user_id
 go
 exec TotalCost @user_id = '1'
 go

 --C006
 create procedure RemoveCartItems (@user_id int, @menuItemId int)
 as
 delete from cart where user_id = @user_id and menu_Item_Id = @menuItemId
 go
 exec RemoveCartItems @user_id = '1', @menuItemId = '3'
 go