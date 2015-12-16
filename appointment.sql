declare @DB varchar(128)
declare @SRV varchar(128)
declare @sdate datetime
--set @sdate='2013-12-31'

SET @DB='BIDCO_WAREHOUSE_PRD'
set @SRV='QDWSQLPROD03'


IF OBJECT_ID('tempdb..#apps ') IS NOT NULL DROP TABLE #apps ;

SELECT distinct 
      [appt_patient_id] as pat_id
      ,cast([appt_date] as date) as appt_date
      ,coalesce(datepart(hour,[appt_date]),[appt_begintime]) as appt_begintime
	  ,DATENAME ( dw, cast([appt_date] as date) ) weekday
  ,case when appt_kept_ind=1 then 'K' 
  when appt_rescheduled_ind='Y' then 'R'
  when [appt_cancel_ind]='Y' then 'C' 
  end as appt_status
,lm.location_name
,ROW_NUMBER() over (partition by appt_patient_id order by appt_date desc) rownum
into #apps --select top 10 *
  FROM QDWSQLPROD03.BIDCO_WAREHOUSE_PRD.[dbo].[t_appointment] a
  left join QDWSQLPROD03.BIDCO_WAREHOUSE_PRD.[dbo].location_master lm
  on lm.location_id=a.[appt_location_id]
where [appt_delete_ind]='N'
 and [appt_date] > '2012-11-30'
  and [appt_date] < dateadd(month,-1,getdate())

--declare @sdate datetime
--set @sdate='2014-12-31'
----update a
----set appt_status= case when e.enc_id is not null then 'K' when e.enc_id is null then 'C' end
--select appt_status, appt_status= case when e.enc_id is not null then 'K' when e.enc_id is null then 'C' end
--from #apps a
-- join t_encounter e
--  on enc_entry_timestamp> @sdate
--  --and appt_kept_ind=0
--  --and appt_rescheduled_ind='N'
--  --and appt_cancel_ind='N'
--  and [appt_date] between dateadd(minute,-30,enc_entry_timestamp) and dateadd(hour,1,enc_entry_timestamp)
--  and enc_delete_ind='N'
--where a.appt_status is null



IF OBJECT_ID('tempdb..#appStats ') IS NOT NULL DROP TABLE #appStats ;
 select pat_id
 ,[appt_date] 
 ,case when appt_status='K' then 1 else 0 end as kept_perc
 ,case when appt_status='C' then 1 else 0 end as can_perc
 ,case when appt_status='R' then 1 else 0 end as resch_perc
 into #appStats
  from #apps

  IF OBJECT_ID('tempdb..#appPerc ') IS NOT NULL DROP TABLE #appPerc ;

select 
  a.pat_id
 ,a.[appt_date] 
 ,count(*)-1 as n, avg(cast(b.kept_perc as numeric)) as kept_perc,avg(cast(b.can_perc as numeric)) as can_perc,avg(cast(b.resch_perc as numeric)) as resch_perc
  into #appPerc
  from #appStats a
  left join #appStats b
  on a.pat_id=b.pat_id
  and a.[appt_date]>b.[appt_date]
group by a.pat_id,a.[appt_date] 
order by a.pat_id,a.[appt_date] 


  IF OBJECT_ID('tempdb..#appList ') IS NOT NULL DROP TABLE #appList ;

 select
  a.*
  ,b.appt_status as last_appt_status
  ,n
  ,kept_perc
  ,can_perc
  ,resch_perc
  into #appList
 from  #apps a
 left join #apps b
 on a.pat_id=b.pat_id
 and a.rownum=b.rownum-1
 left join  #appPerc p
 on p.pat_id=a.pat_id
 and p.appt_date=a.appt_date
 where a.appt_status is not null
 and a.appt_date>'2013-11-30'  ---TODO: remove and fix above

 --) a group by appt_begintime
 --order by appt_begintime

-- select avg(cast(kept as numeric)), appt_begintime from(

  IF OBJECT_ID('tempdb..#output1 ') IS NOT NULL DROP TABLE #output1 ;


 SELECT distinct 
 a.pat_id,
  datepart(month,appt_date) as app_month
 ,appt_begintime
 ,CASE weekday
                    WHEN 'Sunday' THEN 1
                    WHEN 'Monday' THEN 2
                    WHEN 'Tuesday' THEN 3
                    WHEN 'Wednesday' THEN 4
                    WHEN 'Thursday' THEN 5
                    WHEN 'Friday' THEN 6
                    WHEN 'Saturday' THEN 7
        END as weekday
 ,case when appt_status='K' then 1 else 0 end as kept
 ,case when appt_status='R' then 1 else 0 end as rescheduled
  ,case when appt_status='C' then 1 else 0 end as cancelled
   ,case when last_appt_status='K' then 1 when last_appt_status is null then null else 0 end as last_kept
 ,case when last_appt_status='R' then 1 when last_appt_status is null then null else 0 end as last_rescheduled
  ,case when last_appt_status='C' then 1 when last_appt_status is null then null else 0 end as last_cancelled
    ,kept_perc
  ,can_perc
  ,resch_perc
		,datediff(year,pat_date_of_birth,appt_date) as age
      -- ,case when [pat_race] ='Needs Update' then NULL else [pat_race] end as [pat_race]
 --,CASE [pat_race]
 --                   WHEN 'white' THEN 1
 --                   WHEN 'Monday' THEN 2
 --                   WHEN 'Tuesday' THEN 3
 --                   WHEN 'Wednesday' THEN 4
 --                   WHEN 'Thursday' THEN 5
 --                   WHEN 'Friday' THEN 6
 --                   WHEN 'Saturday' THEN 7
 --       END as [pat_race]


      ,case when [pat_ethnicity] ='Not Hispanic or Latino' or [pat_ethnicity] ='Not Hispanic/Latino' then 1 else 0 end as [eth_not_hispanic]
	  ,case when [pat_ethnicity] ='Refused to Report'  or [pat_ethnicity] ='Unreported/Refused to Report' then 1 else 0 end as [eth_refused]
	  ,case when [pat_ethnicity] ='Hispanic or Latino' or [pat_ethnicity]='Hispanic/Latino' then 1 else 0 end as [eth_hispanic]
      ,case when [pat_language]='English' then 1 else 0 end as [lang_Eng]
    ,case when [pat_language]='Chinese' then 1 else 0 end as [lang_Chi]
	,case when [pat_language]='Spanish' or  [pat_language]='Spanish; Castilian' then 1 else 0 end [lang_Spa]
	,case when [pat_language]='Other' or  ([pat_language] not like '%Spanish%' and  [pat_language] not like '%English%' and  [pat_language] not like '%Chinese%' and pat_language<>'Needs Update') then 1 else 0 end [lang_Other]

      --,case when[pat_city]='Needs Update' then NULL else [pat_city] end as city
      --,case when[pat_county]='Needs Update' then NULL else  [pat_county] end as county
      --,case when[pat_state]='Needs Update' then NULL else [pat_state]end as state
      --,case when[pat_zip]='Needs Update' then NULL else [pat_zip] end as zip
      ,case when[pat_sex] ='M' then 1 else 0 end as male
	  ,case when[pat_sex] ='F' then 1 else 0 end as female
	  ,income
 --select distinct pat_race, count(*) as a from t_patient group by pat_race order by a desc
 into #output1
 FROM #appList a
 JOIN QDWSQLPROD03.BIDCO_WAREHOUSE_PRD.[dbo].t_patient p
  ON a.pat_id=p.pat_id
  left join [AnalyticsMonitoring].[dbo].[wrk_zip_cost] z
  on z.zip=left(p.pat_zip,5)
  where
   --appt_date>'2014-11-13'
 -- and
   last_appt_status is not null
   and kept_perc is not null
   and can_perc is not null
   and resch_perc is not null
   and datediff(year,pat_date_of_birth,appt_date)  is not null
   and datepart(month,appt_date) is not null
   and appt_begintime is not null
  -- ) a group by appt_begintime order by appt_begintime
  and income is not null
and (ABS(CAST(
  (BINARY_CHECKSUM(*) *
  RAND()) as int)) % 100) < 40



  select 
  app_month
  ,appt_begintime
  ,[weekday]
  ,kept
  ,rescheduled
  ,cancelled
  ,last_kept
  ,last_rescheduled
  ,last_cancelled
  ,kept_perc
  ,can_perc
  ,resch_perc
  ,age
  ,eth_not_hispanic
  ,eth_refused
  ,eth_hispanic
  ,lang_Eng
  ,lang_Chi
  ,lang_Spa
  ,lang_Other
  ,male
  ,female
  ,income
  ,case when p.patient_id is null then 0 else 1 end as depression
  from #output1 a
  left join  (
  select distinct patient_id from
  QDWSQLPROD03.BIDCO_WAREHOUSE_PRD.[dbo].t_problem  p
  where icd9_code like '296%'
  union
  select distinct patient_id from
  QDWSQLPROD03.BIDCO_WAREHOUSE_PRD.[dbo].t_assessment ta
  where icd9_code like '296%') p
  on p.patient_id=a.pat_id


