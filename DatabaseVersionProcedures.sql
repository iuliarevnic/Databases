use w
go

--modify column type
create procedure modifyColumn
as
begin
alter table TVSeries
alter column yearOfRelease INT not null
end
go

exec modifyColumn
go

--restore column type
create procedure restoreColumn
as
begin
alter table TVSeries
alter column yearOfRelease INT
end
go

exec restoreColumn
go

--add a column
create procedure addColumn
as
begin
alter table VoiceActor
add dateOfBirth date
end
go

exec addColumn
go

--remove a column
create procedure removeColumn
as
begin
alter table VoiceActor
drop column dateOfBirth
end 
go

exec removeColumn
go

--add default constraint
create procedure addConstraint
as
begin
alter table Manga
add constraint defaultNumberOFVolumes default 1 for numberOfVolumes
end
go

exec addConstraint
go

--remove default constraint
create procedure removeConstraint
as
begin
alter table Manga
drop constraint defaultNumberOfVolumes
end 
go

exec removeConstraint
go

--remove primary key
create procedure removePrimary
as
begin
alter table AnimeCharacter
drop constraint PKAnimeCharacter
end
go

exec removePrimary
go

--add primary key
create procedure addPrimary
as
begin
alter table AnimeCharacter
add constraint PKAnimeCharacter primary key(cid)
end
go

exec addPrimary
go

--add candidate key
create procedure addCandidate
as
begin
alter table Episode
add constraint CKEpisode unique(eid)
end
go

exec addCandidate
go

--remove candidate key
create procedure removeCandidate
as
begin
alter table Episode
drop constraint CKEpisode
end
go

exec removeCandidate
go

--remove foreign key
create procedure removeForeign
as
begin
alter table Movie
drop constraint FKMangaMovie
end
go

exec removeForeign
go

--add foreign key
create procedure addForeign
as
begin
alter table Movie
add constraint FKMangaMovie foreign key(mangaid) references Manga(mid) on delete set null
end
go

exec addForeign
go

--create table
create procedure createTable
as
begin
create table MangaDraft(
    mid int identity primary key,
	title varchar(101),
	authorFirstName varchar(51),
	authorLastName varchar(51)
)
end
go

exec createTable
go

--remove table
create procedure removeTable
as
begin
drop table MangaDraft 
end
go

exec removeTable
go




--create table which stores the current version of the database
create table CurrentVersion(
    id int,
    currentVersion int
)
insert CurrentVersion(id,currentVersion) values (0,0)
select * from CurrentVersion

create table TargetVersion(
    dbVersion int,
	procedureName nvarchar(101),
	reverseProcedure nvarchar(101)
)
drop table TargetVersion
insert TargetVersion(dbVersion,procedureName,reverseProcedure) values
                                                                       (1,'modifyColumn','restoreColumn'),
																	   (2,'addColumn','removeColumn'),
																	   (3,'addConstraint','removeConstraint'),
																	   (4,'removePrimary','addPrimary'),
																	   (5,'addCandidate','removeCandidate'),
																	   (6,'removeForeign','addForeign'),
																	   (7,'createTable','removeTable')
select * from TargetVersion
go

create procedure getDatabaseToVersion(@targetVersion int)
as
begin

declare @currentversion int
select @currentversion=CV.currentVersion from CurrentVersion CV
declare @statement nvarchar(101)
set @statement=''
if @currentversion<@targetVersion 

	while @currentversion<@targetVersion

	begin
	select @statement=TV.procedureName from TargetVersion TV where TV.dbVersion=@currentversion+1
	execute sp_executesql @statement
	update CurrentVersion
	set currentVersion=@currentversion+1
	where id=0
	select @currentversion=CV.currentVersion from CurrentVersion CV where id=0
	end


else 
       while @currentversion>@targetVersion

             begin
			 select @statement=TV.reverseProcedure from TargetVersion TV where TV.dbVersion=@currentversion
			 execute sp_executesql @statement
			 update CurrentVersion
			 set currentVersion=@currentversion-1
			 where id=0
			 select @currentversion=CV.currentVersion from CurrentVersion CV where id=0
             end


end
go
drop procedure getDatabaseToVersion
exec getDatabaseToVersion 0
go


