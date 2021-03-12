create database w
use w

CREATE TABLE Movie(
	mid int identity PRIMARY KEY,
	title VARCHAR(101),
	yearOfRelease INT,
	genre VARCHAR(51),
	studio VARCHAR(71)
)

CREATE TABLE TVSeries(
	tvsid int identity PRIMARY KEY,
	title VARCHAR(101),
	yearOfRelease INT,
	genre VARCHAR(51),
	studio VARCHAR(71),
	statusType VARCHAR(51)
)
CREATE TABLE UserOfWebsite(
	userid int identity PRIMARY KEY,
	username VARCHAR(101),
	email VARCHAR(71)
)


CREATE TABLE MovieAudience(
	userid int references UserOfWebsite(userid) ,
	mid int references Movie(mid) ,
	primary key(userid,mid)
)
CREATE TABLE TVSeriesAudience(
	userid int references UserOfWebsite(userid),
	tvsid int references TVSeries(tvsid),
	primary key(userid,tvsid),
)
alter table TVSeriesAudience
add rating int check(rating >=1 and rating <=5)

alter table MovieAudience
add rating int check(rating>=1 and rating <=5)

CREATE TABLE Episode(
	eid int identity PRIMARY KEY,
	title VARCHAR(101)
)
alter table Episode
add tvsid int not null

alter table Episode
add constraint FKEpisodeTVSeries foreign key(tvsid) references TVSeries(tvsid) on delete cascade


select * from Episode

CREATE TABLE VoiceActor(
	vaid int identity PRIMARY KEY,
	firstname VARCHAR(51),
	lastname varchar(51)
) 

create table EpisodeCast(
	eid int references Episode(eid),
	vaid int references VoiceActor(vaid),
	primary key(eid,vaid),
	characterName varchar(51)
)
--drop table VoiceCast

create table MovieCast(
	mid int references Movie(mid),
	vaid int references VoiceActor(vaid),
	primary key(mid,vaid),
	characterName varchar(51)
)

create table Universe(
   universeid int identity primary key,
   universeName varchar(101)
)
create table AnimeCharacter(
   cid int identity primary key,
   firstname varchar(51),
   lastname varchar(51),
   universeid int,
   foreign key(universeid) references Universe(universeid) on delete cascade
)
alter table AnimeCharacter
drop constraint [FK__AnimeChar__unive__5441852A]
alter table AnimeCharacter
drop column universeid
alter table AnimeCharacter
add universeid int not null
alter table AnimeCharacter
add constraint FKAnimeCharacterUniverse foreign key(universeid) references Universe(universeid) on delete cascade

alter table EpisodeCast
drop column charactername

alter table EpisodeCast
add characterFirstName varchar(51)

alter table EpisodeCast
add characterLastName varchar(51)

alter table MovieCast
drop column charactername

alter table MovieCast
add characterFirstName varchar(51)

alter table MovieCast
add characterLastName varchar(51)



alter table TVSeries
add universeid int not null

alter table Movie
add universeid int not null



select * from TVSeries



select * from Movie
alter table TVSeries
add constraint FKTVSeriesUniverse foreign key(universeid) references Universe(universeid)

alter table Movie
add constraint FKMovieUniverse foreign key(universeid) references Universe(universeid)

select * from TVSeries

create table Manga(
    mid int identity primary key,
	title varchar(101),
	authorFirstName varchar(51),
	authorLastName varchar(51),
	publisher varchar(51),
	YearOfRelease int,
	numberOfVolumes int,
	universeid int not null,
	foreign key(universeid) references Universe(universeid)
)

alter table Movie
add mangaid int
alter table TVSeries 
add mangaid int

alter table Movie
add constraint FKMangaMovie foreign key(mangaid) references Manga(mid) on delete set null
alter table TVSeries 
add constraint FKTVSeries foreign key(mangaid) references Manga(mid) on delete set null
select * from Movie


insert Universe(universeName) values ('Your Name'),('Shaman King'),('Naruto')
insert Universe(universeName) values ('Ghibli')
insert Universe(universeName) values ('Classic Literature Club')
select * from Universe
insert  Movie(title,yearOfRelease,genre,studio,universeid) values
			('Your Name',2016,'romantic','CoMix Wave Films',5135)---here fk constraint conflict 
insert Movie(title,yearOfRelease,genre,studio,universeid) values
			('Weathering with You',2019,'romantic','CoMix Wave Films',1),
			('My Neighbour Totoro',1988,'fantasy','Studio Ghibli',4)

insert TVSeries(title,yearOfRelease,genre,studio,statusType,universeid) values
             ('Shaman King',2001,'adventure','Xebec','completed',2),
			 ('Hyouka',2012,'mystery','Kyoto Animation','completed',5)
insert TVSeries(title,yearOfRelease,genre,studio,statusType,universeid) values
             ('Naruto',2002,'adventure','Studio Pierrot','completed',3),
			 ('Naruto: Shippuden',2007,'adventure','Studio Pierrot','completed',3),
			 ('Boruto: Naruto Next Generations',2017,'adventure','Studio Pierrot','ongoing',3)
use w
select * from TVSeries
select * from Movie
insert UserOfWebsite(username,email) values
         ('animeLover','jennieK@yahoo.com'),
		 ('uchihaPowa','larry25@gmail.com'),
		 ('sunnyDaffo','lrparsley@yahoo.com')

select * from UserOfWebsite
---actori Shaman King
insert VoiceActor(firstname,lastname) values
         ('Yuuko','Satou'),
		 ('Minami','Takayama'),
		 ('Megumi','Hayashibara')
---actori Hyouka
insert VoiceActor(firstname,lastname) values
         ('Satomi','Satou'),
		 ('Yuuichi','Nakamura'),
		 ('Ai','Kayano'),
		 ('Daisuke','Sakaguchi')
---actori Naruto
insert VoiceActor(firstname,lastname) values
         ('Chie','Nakamura'),
		 ('Kazuhiko','Inoue'),
		 ('Noriaki','Sugiyama'),
		 ('Junko','Takeuchi')
select * from VoiceActor
select * from TVSeries

select * from Universe
select * from VoiceActor
----episoade Shaman King
insert Episode(title,tvsid) values
		 ('A Boy Who Dances with Ghosts', 1),
		 ('Waiting Samurai',1),
		 ('Another Shaman',1)
---episoade Hyouka
insert Episode(title,tvsid) values
		 ('Revival of the Classics Club and Its History', 2),
		 ('Activities of the Esteemed Classics Club',2),
		 ('Inheritors of the Classics Club and Its Circumstances',2)
---episoade Naruto, Naruto: Shippuden, Boruto: Naruto Next Generations
insert Episode(title,tvsid) values
		 ('Enter: Naruto Uzumaki!', 3),
		 ('My Name is Konohamaru!',3),
		 ('Sasuke and Sakura: Friends or Foes?',3),
		 ('Homecoming', 4),
		 ('The Akatsuki Makes Its Move',4),
		 ('The Results of Training',4),
		 ('Boruto Uzumaki!', 5),
		 ('The Hokage''s Son!',5),
		 ('Metal Lee Goes Wild!',5)
select * from Episode
select * from EpisodeCast
insert EpisodeCast(eid,vaid,characterFirstName,characterLastName) values
          (1,1,'Yoh','Asakura')
select * from Episode
select * from EpisodeCast
select * from VoiceActor
select * from UserOfWebsite
select * from Movie
select * from TVSeries
select * from Manga
select * from Universe
 
insert EpisodeCast(eid,vaid,characterFirstName,characterLastName) values 
             (1,2,'Hao','Asakura'),
			 (1,3,'Anna','Kyouyama'),
			 (7,11,'Naruto','Uzumaki'),
			 (4,5,'Houtarou','Oreki')

update TVSeries
set mangaid=7
where title like 'Naruto%' or title like 'Boruto%'

select * from Manga
insert Manga(title,authorFirstName,authorLastName,publisher,YearOfRelease,numberOfVolumes,universeid) values
          ('Hyouka: You can''t escape / The niece of time','Honobu','Yonezawa','Kadokawa Shoten',2001,1,5),
		  ('Fools'' Staff Roll: Why didn''t she ask Eba?','Honobu','Yonezawa','Kadokawa Shoten',2002,1,5),
		  ('Kudryavka''s Order: Welcome to Kanya Festa!','Honobu','Yonezawa','Kadokawa Shoten',2005,1,5),
		  ('Dolls in the Distance: Little birds can remember','Honobu','Yonezawa','Kadokawa Shoten',2007,1,5),
		  ('Estimated Distance Between the Two: It walks by past','Honobu','Yonezawa','Kadokawa Shoten',2010,1,5),
		  ('Even Though I''m Told I Now Have Wings: Last seen bearing','Honobu','Yonezawa','Kadokawa Shoten',2016,1,5)

select * from Universe
select * from TVSeries
select * from Universe
insert TVSeries(title,yearOfRelease,genre,studio,statusType,universeid) values
             ('Naruto',2002,'adventure','Studio Pierrot','completed',3),
			 ('Naruto: Shippuden',2007,'adventure','Studio Pierrot','completed',3),
			 ('Boruto: Naruto Next Generations',2017,'adventure','Studio Pierrot','ongoing',3)

insert Manga(title,authorFirstName,authorLastName,publisher,YearOfRelease,numberOfVolumes,universeid) values 
             ('Naruto','Masashi','Kishimoto','Shueisha',1997,72,3)

insert Universe(universeName) values ('Tokyo Ghoul')
insert TVSeries(title,yearOfRelease,genre,studio,statusType,universeid) values
             ('Tokyo Ghoul',2014,'dark fantasy','Studio Pierot','completed',6),
			 ('Tokyo Ghoul:re',2018,'dark fantasy','Studio Pierot','completed',6)
insert TVSeries(title,yearOfRelease,genre,studio,statusType,universeid) values
             ('Tokyo GhoulrootA',2015,'dark fantasy','pierot','completed',6)
update TVSeries
set studio='Studio Pierrot'
where studio in ('Studio Pierot','pierot')--pentru insert Tokyo Ghoul cu valori diferite de 'Studio Pierrot' 
select * from Manga
select * from Movie
insert Movie (title,yearOfRelease,genre,studio,universeid,mangaid) values
			('Howl''s Moving Castle',2004,'fantasy','Studio Ghibli',4,NULL),
			('Spirited Away',2001,'fantasy','Studio Ghibli',4,NULL),
			('When Marnie Was There',2014,'drama','Studio Ghibli',4,NULL),
			('Tales from Earthsea',2006,'fantasy','Studio Ghibli',4,NULL)
select * from Universe
insert Universe(universeName) values ('A Letter to Momo')
insert Movie (title,yearOfRelease,genre,studio,universeid,mangaid) values
			('A Letter to Momo',2011,'drama','Production I.G',7,NULL),
			('Naruto the Movie: Ninja Clash in the Land of Snow',2004,'adventure','Studio Pierrot',3,NULL),
			('Naruto the Movie: Legend of the Stone of Gelel ',2005,'adventure','Studio Pierrot',3,NULL),
			('Naruto the Movie: Guardians of the Crescent Moon Kingdom',2006,'adventure','Studio Pierrot',3,NULL)
update Movie
set mangaid=7
where mangaid is null and yearOfRelease>=2000 and yearOfRelease<=2010
delete 
from TVSeries
where title like 'Tokyo Ghoul%' and yearOfRelease=2015--pentru ultimul insert Tokyo Ghoul
insert TVSeries(title,yearOfRelease,genre,studio,statusType,universeid) values
             ('Tokyo Ghoul Root A',2015,'dark fantasy','pierot','completed',6)

select * from Movie
delete
from Movie
where studio like 'Studio Ghibli' and yearOfRelease between 2000 and 2010



select * from TVSeries
select * from Movie
select * from Manga
select * from Episode

--UNION
select M.title
from Movie M
where studio like 'Studio Pierrot'
union
select T.title
from TVSeries T
where studio like 'Studio Pierrot'--select all movies and tvseries produced by Studio Pierrot

select *
from Movie M
where genre like 'fantasy'
union 
select *
from Movie M1
where genre like 'romantic'







select M.title
from Movie M
where yearOfRelease<2000 or studio like 'Studio Ghibli'
union
select T.title
from TVSeries T
where yearOfRelease<2005 and genre like 'adventure'--select older movies(classics) and TVSeries 

--UNION cu OR
select U.username,M.title,MA.rating
from UserOfWebsite U,MovieAudience MA, Movie M
where U.userid=MA.userid and MA.mid=M.mid and (MA.rating=1 or MA.rating=5)--select pair user-movie where the user rated the movie either a 1 or a 5

select * from UserOfWebsite
select * from Movie
select * from TVSeries

insert into TVSeriesAudience(userid,tvsid,rating) values
			(1,2,5),
			(3,4,3),
			(2,9,3),
			(3,5,5),
			(1,7,2)

insert into MovieAudience(userid,mid,rating) values
			(1,8,5),
			(3,9,4),
			(2,3,3),
			(3,2,1),
			(1,11,2)
select * from TVSeriesAudience
select * from MovieAudience
select * from Movie
select * from TVSeries
select * from UserOfWebsite

--INTERSECT
select U.username as 'username',U.email as 'email address'
from UserOfWebsite U, MovieAudience MA,Movie M
where U.userid=MA.userid and MA.mid=M.mid and M.universeid=3
intersect
select U1.username as 'username', U1.email as 'email address'
from UserOfWebsite U1,TVSeriesAudience TA,TVSeries T
where U1.userid=TA.userid and TA.tvsid=T.tvsid and T.universeid=3--select all users who've  watched both movies and TVseries from the Naruto universe

--INTERSECT with IN
---select all users who have watched studio pierrot tvseries and studio ghibli movies(big production companies)
select U.username as 'username', U.email as 'email address'
from UserOfWebsite U,TVSeriesAudience TA, TVSeries T
where U.userid=TA.userid and TA.tvsid=T.tvsid and T.studio like 'Studio Pierrot' and U.userid in(select U1.userid
                                                                                                 from UserOfWebsite U1,MovieAudience MA, Movie M
																								 where U1.userid=MA.userid and MA.mid=M.mid and M.studio='Studio Ghibli')

select * from Movie
select * from UserOfWebsite
select * from MovieAudience
select * from TVSeriesAudience

insert MovieCast(mid,vaid,characterFirstName,characterLastName) values 
			 (9,11,'Naruto','Uzumaki')

select * from VoiceActor
select * from EpisodeCast
select * from MovieCast
--EXCEPT
--select all actors who played characters only in TVSeries
select VA.firstName,VA.lastName
from VoiceActor VA,EpisodeCast EC
where VA.vaid=EC.vaid 
except
select VA1.firstName,VA1.lastName
from VoiceActor VA1,MovieCast MC
where VA1.vaid=MC.vaid
--EXCEPT cu NOT IN
select VA1.firstname,VA1.lastname
from VoiceActor VA1,EpisodeCast EC
where VA1.vaid=EC.vaid and VA1.vaid not in(select VA2.vaid
											from VoiceActor VA2,MovieCast MC
										    where VA2.vaid=MC.vaid)
select * from Movie
select * from VoiceActor
insert VoiceActor(firstname,lastname) values
         ('Noriko','Hidaka'),
		 ('Chika','Sakamoto'),
		 ('Hitoshi','Takagi'),
		 ('Tanie','Kitabayashi')
insert MovieCast(mid,vaid,characterFirstName,characterLastName) values 
			 (3,12,'Satsuki','Kusakabe'),
			 (3,13,'Mei','Kusakabe'),
			 (3,14,'Totoro',''),
			 (3,15,'Granny','')
--INNER JOIN
--select all movie actors(all actors who appeared in at least one movie; an actor should appear once)
select distinct va.firstname,va.lastname
from Movie M inner join MovieCast MC on M.mid=MC.mid inner join VoiceActor va on va.vaid=mc.vaid

select * from Movie
--LEFT JOIN
--select all movies watched by users, with the respective user
select M.title,MA.rating,U.username,U.email
from Movie M left join MovieAudience MA on M.mid=MA.mid  
     left join UserOfWebsite U on U.userid=MA.userid 
--select all watched movies rated 5 by users
select M.title,MA.rating,U.username,U.email
from Movie M left join MovieAudience MA on M.mid=MA.mid  
     left join UserOfWebsite U on U.userid=MA.userid where MA.rating=5 
--RIGHT JOIN
--select all watched TVSeries released between 1990 and 2005 
select U.username,U.email, T.title,T.yearOfRelease
from UserOfWebsite U right join TVSeriesAudience TA on U.userid=TA.userid right join TVSeries T on TA.tvsid=T.tvsid
     where T.yearOfRelease>=1990 and T.yearOfRelease<2005
--FULL JOIN
--select all actors who played a character in movies with rating between 3 and 5, with the users email(maybe send recommendations
--later via email)
select U.email,M.title,MA.rating,VA.firstname,VA.lastname,MC.characterFirstName,MC.characterLastName
from UserOfWebsite U full join MovieAudience MA on U.userid=MA.userid FULL join Movie M on 
                         M.mid=MA.mid full join MovieCast MC on MC.mid=M.mid full join VoiceActor VA on
						 VA.vaid=MC.vaid where MA.rating between 3 and 5

select * from Episode
select * from EpisodeCast
select * from VoiceActor
select * from UserOfWebsite
select * from Movie
select * from TVSeries
select * from Manga
select * from Universe

--IN subquery
--what movies were released more than 15 years ago?
select M.title,M.yearOfRelease,2020-M.yearOfRelease as 'released years/ago'
from Movie M
where M.mid in (select M1.mid
                from Movie M1
				where M1.yearOfRelease<2005)


--among completed TVSeries, select which ones were produced by a company other than Studio Pierrot
select T.title,T.statusType,T.studio
from TVSeries T
where T.tvsid in(select T1.tvsid
                 from TVSeries T1
				 where T1.statusType like 'completed' and T1.tvsid in(select T2.tvsid
				                                                      from TVSeries T2
																	  where T2.studio <> 'Studio Pierrot'))
 select * from TVSeries
 --EXISTS
 --select top 3 most recent tvseries with completed as status
 select top 3 T.title
 from TVSeries T
 where exists(select *
              from TVSeries T1
			  where T.tvsid=T1.tvsid and T1.statusType like 'completed')
order by T.yearOfRelease DESC

--find the top 5 movies from the list of ordered(by title)movies who are not dramas in the Ghibli universe 
select top 5 M.title
 from Movie M
 where exists(select *
              from Movie M1
			  where M.mid=M1.mid and M1.mid not in (select M2.mid
			                                        from Movie M2
													where M2.universeid=4 and M2.genre like 'drama'))
order by M.title



select * from Movie
select * from MovieAudience

--FROM
--select all tvseries based on a manga written by Masashi Kishimoto
select T.*
from TVSeries T inner join (select *
                             from Manga M
							 where M.authorFirstName like 'Masashi' and M.authorLastName like 'Kishimoto')mangaTable
               on T.mangaid=mangaTable.mid
--select episodes'names of the tvseries released after 2010 
select E.title,(2020-tvseriestable.yearOfRelease) as 'Years since release'
from Episode E inner join (select *
                           from TVSeries T
						   where T.yearOfRelease>2010)tvseriestable
               on E.tvsid=tvseriestable.tvsid

select * from Manga
--GROUP BY
--select first year of publishing manga for each author
select M.authorFirstName,M.authorLastName,MIN(M.yearOfRelease) as 'Earliest published manga'
from Manga M
group by M.authorFirstName,M.authorLastName
--select publishers who have published more than three manga 
select  distinct M.publisher
from Manga M
group by M.publisher
having count(*)>3
--select the years in which a manga was published for each publisher, where year is older than the average in the entire list 
select distinct M.publisher,M.YearOfRelease 
from Manga M
group by M.publisher,M.YearOfRelease
having M.YearOfRelease<(select AVG(M1.YearOfRelease)
                        from Manga M1)
--
select distinct M.universeid
from Manga M
group by M.universeid

--select authors who published more than 5 manga volumes since 1990
select M.authorFirstName,M.authorLastName,M.YearOfRelease
from Manga M
group by M.authorFirstName,M.authorLastName,M.YearOfRelease
having 5<(select sum(M2.numberOfVolumes)
          from Manga M2
		  where M2.authorFirstName=M.authorFirstName and M2.authorLastName=M.authorLastName) and M.YearOfRelease in (select M1.yearOfRelease
                                                        from Manga M1
														where M1.YearOfRelease>1990)
--ANY and ALL
--select movie released after some drama movie
select *
from Movie M
where M.yearOfRelease > any (select M1.yearOfRelease
                            from Movie M1
					        where M1.genre like 'drama')
--select movie released after every drama in the list
select *
from Movie M
where M.yearOfRelease > all (select M1.yearOfRelease
                            from Movie M1
					        where M1.genre like 'drama')
--rewrite with Min/Max
--select movie released after some drama movie
select *
from Movie M
where M.yearOfRelease > (select MIN(M1.yearOfRelease)
                         from Movie M1
						 where M1.genre='drama')
--select movie released after every drama in the list
select *
from Movie M
where M.yearOfRelease > (select MAX(M1.yearOfRelease)
                         from Movie M1
						 where M1.genre='drama')

select * from Movie
select * from MovieAudience
select * from TVSeries
select * from TVSeriesAudience

--select TVseries which have been watched and given a rating of 5(show the grade(2*rating)/10 of the movie)
select *,5*2 as 'TVSeries grade per 10'
from TVSeries T
where T.tvsid = any (select TA.tvsid
                     from TVSeriesAudience TA
					 where TA.rating=5)
--rewritten with IN
select *,5*2 as 'TVSeries grade per 10'
from TVSeries T
where T.tvsid in (select TA.tvsid
                  from TVSeriesAudience TA
				  where TA.rating=5)
--select tvseries which have a genre different from adventure
select *
from TVSeries T
where T.tvsid <> all(select T1.tvsid
                     from TVSeries T1
					 where T1.genre='adventure')
--rewritten with NOT IN
select *
from TVSeries T
where T.tvsid not in (select T1.tvsid
                      from TVSeries T1
					  where T1.genre='adventure')





--find the top 5 movies based on the grade of a movie(from 1 to 10 based on the rating) 
--for movies other than dramas in the Ghibli universe

--total number of volumes published before 2015 by each publisher
select M.title
from Movie M
where M.genre='romantic'

select * from VoiceActor

select M.mid,M.genre
from Movie M
where M.yearOfRelease=2016 OR M.yearOfRelease=2019

select * from Movie


select *
from VoiceActor V
where V.firstname like 'M%'

select * from AnimeCharacter
insert into AnimeCharacter(firstname,lastname,universeid) values ('a','aa',1),('b','bb',2)
delete from AnimeCharacter
select * from Movie

insert Movie(title,yearOfRelease,genre,studio,universeid,mangaid) values
			('ChocolatBlanche',2004,'romantic','Studio Ghibli',4,NULL),
			('Couple Magazine',2001,'romantic','Studio Ghibli',4,NULL),
			('Teacher',2014,'historical','Studio Ghibli',4,NULL),
			('Open the car door',2006,'romantic','Studio Ghibli',4,NULL)

insert MovieAudience(userid,mid,rating) values (2,18,3),(2,20,4),(1,21,2),(3,19,1),(1,19,2)


