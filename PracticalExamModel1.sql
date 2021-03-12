create database e2
use e2

create table Customers(
cid int primary key,
name varchar(71),
dateOfBirth date,
)

create table BankAccounts(
bid int primary key,
iban bigint,
cbalance int,
holderId int references Customers(cid))

create table Cards(
cid int primary key,
number bigint,
cvv int,
bid int references BankAccounts(bid)
)

create table ATMs(
aid int primary key,
address varchar(101)
)

create table Transactions(
cardId int references Cards(cid),
atmId int references ATMs(aid),
sumMoney int,
dateOfTransaction datetime,
primary key(cardId,atmId,dateOfTransaction)
)

delete from Customers
delete from BankAccounts
delete from ATMs
delete from Cards
delete from Transactions

insert Customers(cid,name,dateOfBirth) values (1,'Allan Smith','1989-09-05'),(2,'Emma Jane','1970-01-09'),(3,'Troy Montez','2003-07-27')
insert BankAccounts(bid,iban,cbalance,holderId) values (1,1726384958641263,257,2),(2,7465728374657492,97,3),(3,7465837463529109,5095,1)
insert ATMs(aid,address) values (1,'Strada A1'),(2,'Strada A2'),(3,'Strada B')
insert Cards(cid,number,cvv,bid) values (1,6374657483647583,715,3),(2,9475638492637458,976,1),(3,92837446573829102,797,1)
insert Transactions(cardId,atmId,sumMoney,dateOfTransaction) values (3,2,507,'2025-05-05T13:25:53'),(2,1,75,'2025-09-07T07:09:15'),(1,3,245,'2025-07-05T14:09:29')

go

create procedure deleteCardTransact(@cid int)
as
begin
delete from Transactions
where cardId=@cid
end
go

select * from Customers
select * from BankAccounts
select * from ATMs
select * from Cards
select * from Transactions

exec deleteCardTransact 1

go

create view CardsAllATMs
as
select C.number
from Cards C
where (select count(*) from (select distinct atmId
                             from Transactions
	                         where cardId=cid)t
							 )=(select count(*)
	                      from ATMs)
go

insert Transactions(cardId,atmId,sumMoney,dateOfTransaction) values (1,1,507,'2025-05-05T13:35:53'),(1,3,75,'2025-09-07T17:09:15')
insert Transactions(cardId,atmId,sumMoney,dateOfTransaction) values (1,2,507,'2025-05-05T13:53:53')

select * from CardsAllATMs

go

create function TotalTransaction()
returns table
as
return
select number,cvv
from Cards
where (select SUM(sumMoney)
       from Transactions
	   where cardId=cid)>2000
go


insert Transactions(cardId,atmId,sumMoney,dateOfTransaction) values (1,2,705,'2025-05-05T13:53:03')

select * from TotalTransaction()


















create table PresentationShops(
psid int primary key,
name varchar(101),
city varchar(101)
)

create table Women(
wid int primary key,
name varchar(101),
maxAmount int
)

create table ShoeModels(
smid int primary key,
name varchar(101),
season varchar(101)
)

create table Shoes(
sid int primary key,
price int ,
shoeModelId int references ShoeModels(smid)
)

create table ShoeShops(
sid int references Shoes(sid),
psid int references PresentationShops(psid),
primary key(sid,psid),
availableShoes int
)

create table WomenShoes(
wid int references Women(wid),
sid int references Shoes(sid),
primary key(wid,sid),
shoesBought int,
amountSpent int
)

insert PresentationShops(psid,name,city) values (1,'Le Boutique','Paris'),(2,'Finest footwear','London'),(3,'Napoca','Cluj-Napoca')
insert Women(wid,name,maxAmount) values (1,'Helen',509),(2,'Stella',1579),(3,'Ingrid',55551)
insert ShoeModels(smid,name,season) values (1,'sport for the bold','autumn'),(2,'boots','summer'),(3,'slippers','summer')
insert Shoes(sid,price,shoeModelId) values (1,275,2),(2,1900,3),(3,397,1)
insert ShoeShops(sid,psid,availableShoes) values (2,3,200),(3,1,20),(1,2,2)
insert WomenShoes(wid,sid,shoesBought,amountSpent) values (2,1,10,2750),(1,3,4,1588),(3,2,2,3800)


select * from PresentationShops
select * from Women
select * from ShoeModels
select * from Shoes
select * from ShoeShops
select * from WomenShoes

go

create procedure addShoetoShop(@shoe int,@shop int,@numberOfShoes int)
as
begin
insert ShoeShops(sid,psid,availableShoes) values (@shoe,@shop,@numberOfShoes)
end

exec addShoetoShop 2,1,500
go

create view womenShoeModel
as
select *
from Women w
where 2<=(select sum(shoesBought)
          from WomenShoes ws
		  where w.wid=ws.wid and ws.sid in (select sid
		                from Shoes
						where shoeModelId=2))
go

select * from womenShoeModel	

go

create function ShoesTShops(@T int)
returns table
return
select *
from Shoes S
where @T<=(select count(*)
          from ShoeShops SS
		  where SS.sid=S.sid)
go

select * from ShoesTShops(2)





create table Movies(
mid int primary key,
name varchar(101),
releaseDate date,
companyId int references Companies(cid),
stageDirectorId int references StageDirectors(sdid)
)

create table Companies(
cid int primary key,
name varchar(101),
)

create table Actors(
aid int primary key,
name varchar(101),
ranking int
)

create table StageDirectors(
sdid int primary key,
name varchar(101),
awards int
)

create table CinemaProductions(
cpid int primary key,
title varchar(101),
mid int references Movies(mid)
)

create table ProductionActors(
cpid int references CinemaProductions(cpid),
aid int references Actors(aid),
entryMoment datetime,
primary key (cpid,aid)
)


insert Actors(aid,name,ranking) values (1,'Emma Jones',5),(2,'Natalie Smithman',8),(3,'Jane Caviel',7)
insert Companies(cid,name) values (1,'Company 1'),(2,'Company 2'),(3,'Company 3')
insert StageDirectors(sdid,name,awards) values (1,'SD 1',3),(2,'SD 2',9),(3,'SD 3',15)
insert Movies(mid,name,releaseDate,companyId,stageDirectorId) values (1,'Movie 1','2035-05-02',1,2),(2,'Movie 2','2057-09-07',2,3),(3,'Movie 3','2097-05-02',3,1)
insert CinemaProductions(cpid,title,mid) values (1,'CP 1',1),(2,'CP 2',2),(3,'CP 3',3)
insert ProductionActors(cpid,aid,entryMoment) values (1,2,'2025-05-05T13:25:53'),(2,1,'2025-07-05T23:25:53'),(3,3,'2025-05-05T13:35:53')

go

create procedure CPA(@aid int,@entryMoment datetime,@cpid int)
as
begin
insert ProductionActors(cpid,aid,entryMoment) values (@cpid,@aid,@entryMoment)
end
go

exec CPA 2,'2025-05-05T13:25:53',3
select * from ProductionActors

go
create view ActorsAll
as
select name
from Actors A
where (select count(*)
       from CinemaProductions)=(select count(*) from (select distinct PA.cpid
	                                                  from ProductionActors PA
								                      where PA.aid=A.aid)t)
go

insert ProductionActors(cpid,aid,entryMoment) values (2,2,'2025-05-05T13:25:53')
select * from ActorsAll

go

create function MoviesF(@p int)
returns table
as 
return select *
       from Movies M
	   where M.releaseDate>'2018-01-01' and @p<=(select count(*)
	                                             from CinemaProductions CinP
												 where CinP.mid=M.mid)
go

select * from MoviesF(1)

insert CinemaProductions(cpid,title,mid) values (4,'CP 4',1)

select * from MoviesF(2)