
IF OBJECT_ID('tempdb..#a') IS NOT NULL 
    DROP TABLE #a

SELECT 
count(distinct f.id) as ff
,f.city
,f.state
    ,[PCT_OBESE_ADULTS09]
      ,[PCT_OBESE_ADULTS10]
      ,[PCT_OBESE_ADULTS13]
,coalesce(pop,0) as pop
into #a
  FROM [AnalyticsMonitoring].[ext].[fast_food] f
  left join [AnalyticsMonitoring].[ext].[zip_fips] zf
  on zf.zip5=f.zip
  left join [AnalyticsMonitoring].[ext].[health_stats_num] h
  on zf.fips_code=h.fips
  left join [AnalyticsMonitoring].[ext].[population] p
  on p.fips=zf.fips_code
  group by
  f.city
,f.state
    ,[PCT_OBESE_ADULTS09]
      ,[PCT_OBESE_ADULTS10]
      ,[PCT_OBESE_ADULTS13]
,pop




IF OBJECT_ID('tempdb..#b') IS NOT NULL 
    DROP TABLE #b


select 
sum(ff) as ff
,city
,state

,max(pct_obese_adults13) as obese13
,max(PCT_OBESE_ADULTS10) as obese10
,max(PCT_OBESE_ADULTS09) as obese09
,sum(pop) as pop
into #b
 from #a

 group by
 city
 ,state

 
 --select * from #b
 
IF OBJECT_ID('tempdb..#c') IS NOT NULL 
    DROP TABLE #c

	select 
	ff
	,city
	,state
	,pop
	,(obese13+obese10+obese09)/3 as obese
	--into #c
	 from #b
	where obese13 is not null


IF OBJECT_ID('tempdb..#d') IS NOT NULL 
    DROP TABLE #d
 select 
 c.pop
 ,c.city,c.state
 ,c.obese
 ,type
 ,typeCount
 into #d
  from #c c
  left join (select type,city,state,count(2) as typeCount from [AnalyticsMonitoring].[dbo].[fast_food] group by type,city,state) b
  on b.city=c.city
  and b.state=c.state



  --avg obese by chain
select
sum(pop) as pop
,sum(d.typeCount) as type
,type from(
select 
((d.obese*d.pop)/a.pop) as pop
,d.typeCount
,d.type
 from #d d
left join(
  select 
  sum(d.pop) as pop
  ,sum(d.typeCount) as typeCount
  ,type
  from #d d
  group by type
  ) a on a.type=d.type
  ) d group by type








SELECT 
count(distinct f.id) as ff
,f.city
,f.state
    ,[PCT_OBESE_ADULTS09]
      ,[PCT_OBESE_ADULTS10]
      ,[PCT_OBESE_ADULTS13]
	  ,PCT_DIABETES_ADULTS09
	  ,PCT_DIABETES_ADULTS10
	  	,PCT_OBESE_CHILD08,PCT_OBESE_CHILD11,PCH_OBESE_CHILD_08_11,PCT_HSPA09,PCH_RECFAC_07_12,PCH_RECFACPTH_07_12
,coalesce(pop,0) as pop --select * from [AnalyticsMonitoring].[dbo].[health_stats_num]  p
  FROM [AnalyticsMonitoring].[dbo].[fast_food] f
  left join [AnalyticsMonitoring].[ext].[zip_fips] zf
  on zf.zip5=f.zip
  left join  [AnalyticsMonitoring].[dbo].[health_stats_num] h
  on zf.fips_code=h.fips
  left join [AnalyticsMonitoring].[ext].[population] p
  on p.fips=zf.fips_code
  group by
  f.city
,f.state
    ,[PCT_OBESE_ADULTS09]
      ,[PCT_OBESE_ADULTS10]
      ,[PCT_OBESE_ADULTS13]
	  	  ,PCT_DIABETES_ADULTS09
	  ,PCT_DIABETES_ADULTS10
	  	,PCT_OBESE_CHILD08,PCT_OBESE_CHILD11,PCH_OBESE_CHILD_08_11,PCT_HSPA09,PCH_RECFAC_07_12,PCH_RECFACPTH_07_12
,pop
order by ff desc




