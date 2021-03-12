create database practicalExam
use practicalExam

create table Courses(
cid int primary key,
title varchar(101),
language varchar(101),
price int,
discount int check(discount>=0),
noOfLectures int
)

create table Topics(
tid int primary key,
name varchar(101),
)

create table TopicsCourses(
tid int references Topics(tid),
cid int references Courses(cid),
primary key(tid,cid)
)

create table Students(
sid int primary key,
lastName varchar(101),
firstName varchar(101),
dateOfBirth date
)

create table StudentsCourses(
sid int references Students(sid),
cid int references Courses(cid),
enrollDate date,
completionDate date,
textReview varchar(101),
stars int,
primary key(sid,cid)
)

create table Lectures(
lid int primary key,
title varchar(101),
courseId int references Courses(cid)
)
create table Resources(
rid int primary key,
url varchar(101),
lectureId int references Lectures(lid)
)

insert Students(sid,lastName,firstName,dateOfBirth) values (1,'ln 1','fn 1','1999-09-09'),(2,'ln 2','fn 2','1999-08-08'),(3,'ln 3','fn 3','1999-09-08')
insert Courses(cid,title,language,price,discount,noOfLectures) values (1,'Course 1','Ro',150,10,25),(2,'Course 2','Ro',250,200,105),(3,'Course 3','En',50,0,23)
insert Topics(tid,name) values (1,'topic1'),(2,'topic2')
insert StudentsCourses(sid,cid,enrollDate,completionDate,textReview,stars) values (1,3,'2015-08-08','2015-09-09','ok',5),(2,1,'2014-07-08','2015-07-09','fine',3)
insert TopicsCourses(tid,cid) values (1,2),(2,3)
insert Lectures(lid,title,courseId) values (1,'L1',2),(2,'L3',3),(3,'L15',1)
insert Resources(rid,url,lectureId) values (1,'longtext1',2),(2,'longtext2',3)

go

create procedure addStudentEnrollment(@studId int,@courseId int,@eDate date,@cDate date,@stars int,@text varchar(101))
as
begin
declare @ok int=0
select @ok=count(*)
from StudentsCourses SC
where SC.sid=@studId and SC.cid=@courseId

if @ok=0
begin
insert StudentsCourses(sid,cid,enrollDate,completionDate,textReview,stars) values (@studId,@courseId,@eDate,@cDate,@text,@stars)
end

else
begin
update StudentsCourses
set enrollDate=@eDate,completionDate=@cDate,textReview=@text,stars=@stars
where sid=@studId and cid=@courseId
end
end

select * from StudentsCourses
exec addStudentEnrollment 1,2,'2015-05-05','2015-06-05',5,'alright'
exec addStudentEnrollment 1,3,'2015-05-05','2015-06-05',5,'right'

go

create view ShowNames
as
select S.firstName,S.lastName
from Students S
where (select count(*)
       from (select distinct SC1.cid
	         from StudentsCourses SC1
			  where SC1.sid=S.sid)t1)/2<(select count(*)
			                             from (select distinct SC2.cid
									           from StudentsCourses SC2
										       where SC2.sid=S.sid and SC2.completionDate is not null)t2)
										   
go

select * from Students
select * from Courses
select * from StudentsCourses
select * from ShowNames

go

create function TitleC(@p int)
returns table
as
return
select C.title
from Courses C
where (select count(*)
       from (select distinct SC.sid
	         from StudentsCourses SC
			 where SC.cid=C.cid and SC.completionDate is null)t)>@p
go
insert StudentsCourses(sid,cid,enrollDate,textReview,stars) values (3,2,'2015-08-08','ok',5)
insert StudentsCourses(sid,cid,enrollDate,textReview,stars) values (2,2,'2015-08-08','ok',5)
select * from TitleC(1)