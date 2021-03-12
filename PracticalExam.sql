create database newdb
use newdb

create table Tournaments(
tid int primary key,
name varchar(101),
startdate date,
enddate date
)

create table Courts(
cid int primary key,
name varchar(101),
capacity int,
tournamentId int references Tournaments(tid)
)

create table Players(
pid int primary key,
name varchar(101),
prizeMoney int,
points int
)

create table Matches(
mid int primary key,
tournamentId int references Tournaments(tid),
courtId int references Courts(cid),
firstPlayerId int references Players(pid),
secondPlayerId int references Players(pid),
matchDate date,
matchTime time,
moneyFirst int,
moneySecond int,
pointsFirst int,
pointsSecond int
)



insert into Tournaments(tid,name,startdate,enddate) values (1,'T1','2015-05-05','2015-05-05'),(2,'T2','2015-05-05','2015-05-05'),(3,'T3','2015-05-05','2015-05-05')
insert into Courts(cid,name,capacity,tournamentId) values(1,'C1',100,2),(2,'C2',200,1),(3,'C3',300,3)
insert into Players(pid,name,prizeMoney,points) values (1,'P1',10,5),(2,'P2',100,89),(3,'P3',50,500)

insert into Matches(mid,tournamentId,courtId,firstPlayerId,secondPlayerId,matchDate,matchTime,moneyFirst,moneySecond,pointsFirst,pointsSecond) values
             (1,2,1,1,3,'2015-05-06','12:34:39',100,200,50,100),(2,1,2,2,3,'2015-05-07','12:35:39',500,50,150,10)
go

create procedure deletePlayer(@N varchar(101))
as
begin
declare @playerId int=0
select @playerId=P.pid
from Players P
where P.name=@N

delete
from Matches
where firstPlayerId=@playerId or secondPlayerId=@playerId

delete
from Players
where pid=@playerId
end

drop procedure deletePlayer

select * from Tournaments
select * from Courts
select * from Players
select * from Matches

insert into Matches(mid,tournamentId,courtId,firstPlayerId,secondPlayerId,matchDate,matchTime,moneyFirst,moneySecond,pointsFirst,pointsSecond) values
             (2,1,2,2,3,'2015-05-07','12:35:39',500,50,150,10)


exec deletePlayer 'P2'

go
create function playersN(@M int)
returns table
as
return
select P.name
from Players P
where (select COUNT(*)
       from Matches Mat
	   where (Mat.firstPlayerId=P.pid and Mat.moneyFirst>Mat.moneySecond) or (Mat.secondPlayerId=P.pid and Mat.moneySecond>Mat.moneyFirst))*100/(select count(*) from Matches M1 where firstPlayerId=P.pid or secondPlayerId=P.pid)>=@M
go
drop function playersN

insert into Matches(mid,tournamentId,courtId,firstPlayerId,secondPlayerId,matchDate,matchTime,moneyFirst,moneySecond,pointsFirst,pointsSecond) values
             (2,1,2,1,3,'2015-05-07','12:35:39',500,50,150,10)
insert into Players(pid,name,prizeMoney,points) values(2,'P2',100,89)
insert into Matches(mid,tournamentId,courtId,firstPlayerId,secondPlayerId,matchDate,matchTime,moneyFirst,moneySecond,pointsFirst,pointsSecond) values
             (3,1,2,2,3,'2015-05-07','12:35:39',500,50,150,10)

select * from Matches
select * from playersN(50)
select * from playersN(100)

go

create view TournamentMatches
as
select T.name as TournamentName, Count(*) as TotalNumberOfMatches
from Tournaments T,Matches M
where M.tournamentId=T.tid
group by T.name
										   
go

select * from TournamentMatches