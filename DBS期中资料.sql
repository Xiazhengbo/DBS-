create table guest//客人
(	gno char(4)	primary key,
    gname char(4),
    age int check(age > 18),
    city char(8),
);
create table food //食物
(	fno char(4) primary key,
    fname char(10) not null,
    price float check(price < 500)
);
create table menu//点单
(	gno char(4),
    fno char(4),
    amount int check(amount < 10),
    primary key (gno, fno),
    foreign key(gno) references guest(gno),
    foreign key(fno) references food(fno),
);
//插入数据，以客人为例
insert into guest(gno, gname, age, city)
values('g01', 'zhao', '21', 'nanjing');
//出生年份，以名字排序
select gname, 2021 - age
from guest
order by gname;
//找出年龄小于30客人
select gname, age
from guest
where age <= 30;
//名字中含有 i 客人的数量
select count(*)
from guest
where gname like '%i%' // %字符数量不定  _ 一个字符
//点餐少于3个
select gno
from menu
group by gno
having count(*) > 3;
//查询顾客zhao的消费总额
select sum(price *amount)
from guest, food, menu
where guest.gno = menu.gno
                  and food.fno = menu.fno
                                 and gname like 'zhao';
//创建视图view1，统计个顾客的消费总计
create view view1(gno, city, totalpay)
as
select guest.gno, city, sum(price *amount)
from guest, food, menu
where guest.gno = menu.gno
                  and food.fno = menu.fno
                                 group by guest.gno;
//创建视图view2，统计各城市的消费人数
create view view2(city, totalguest)
as
select city, count(*)
from guest
group by city;
select *from view2;
//在视图view1和view2的基础上
//计算出哪个城市的平均消费能力强
select view1.city, sum(totalpay / totalguest), avgcitypay
from view1, view2
where view1.city = view2.city
                   group by city
                   order by avgcitypay desc;
//将菜品beef价格改为52
update food
set price = 52
            where fname like 'beef';
select *from food;
//suzhou点单加1
update menu
set amount = amount + 1
             where gno in(
                 select gno
                 from guest
                 where city like 'suzhou'
             );
//删除60岁以上客户消费记录
delete from menu
where gno in (
    select gno
    from guest
    where age > 60
);
//删除nanjing顾客的所有信息
delete from menu
where gno in(
    select gno
    from guest
    where city like 'nanjing'
);
delete from guest
where city like 'nanjing' ;
//授予zhangsna1用户对food关系进行数据修改的权力
create user zhangsan;
grant update
on food
to zhangsan;
//授予lisi用户对food关系进行结构修改及查询的能力
create user lisi;
grant alter, select
on food
to lisi;
//授予所有用户对menu关系的查询权限
grant select
on menu
to public;
//收回lisi用户对food关系的查询能力
revoke select
on food
from lisi;
