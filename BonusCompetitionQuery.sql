use w
go

--select all tvseries based on a manga written by Masashi Kishimoto(popular writer)
select T.*
from TVSeries T inner join (select *
                             from Manga M
							 where M.authorFirstName like 'Masashi' and M.authorLastName like 'Kishimoto')mangaTable
               on T.mangaid=mangaTable.mid

--for each user, show all the recent(released since 2017) movies and tvseries they haven't watched, but which have been watched and have an average rating of 4 or higher based on ratings from other users
--useful for new users(not only), who don't know what to start watching/haven't watched any anime before(top recent picks)
select U.userid,U.email,M.title,M.yearOfRelease, 'movie' as 'Movie/TVSeries'
from UserOfWebsite U, Movie M
where M.mid not in (select MA.mid
                    from MovieAudience MA
				    where MA.userid=U.userid) and 4<=(select AVG(MA1.rating)
					                                  from MovieAudience MA1
													  where M.mid=MA1.mid) and M.yearOfRelease>=2017
union
select U.userid,U.email,T.title,T.yearOfRelease, 'tvseries' as 'Movie/TVSeries'
from UserOfWebsite U, TVSeries T
where T.tvsid not in (select TA.tvsid
                      from TVSeriesAudience TA
					  where TA.userid=U.userid) and 4<=(select AVG(TA1.rating)
					                                    from TVSeriesAudience TA1
														where TA1.tvsid=T.tvsid) and T.yearOfRelease>=2017