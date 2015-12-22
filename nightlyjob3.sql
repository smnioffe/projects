/****** Script for SelectTopNRows command from SSMS  ******/
select 
		[name]
		,'job duration' as [orig_table]
     -- ,[start_time]
     -- ,[end_date]
      ,[job_complete]
      ,[run_days]
      ,[run_hours]
      ,[run_minutes]
      ,[last_step_name]
      ,[last_step_id]
      ,[last_step_date]
	   ,[CLIENT]
      ,[ENV]

      ,[entry_timestamp]
      ,[updated_timestamp]
from (
SELECT [name]
      ,[start_time]
      ,[end_date]
      ,[job_complete]
      ,[run_days]
      ,[run_hours]
      ,[run_minutes]
      ,[last_step_name]
      ,[last_step_id]
      ,[last_step_date]
	  ,[CLIENT]
      ,[ENV]

      ,[entry_timestamp]
      ,[updated_timestamp]
	   ,ROW_NUMBER() over (partition by name order by start_time desc) rownum
  FROM [AnalyticsMonitoring].[dbo].[nightly_jobs_status]
) a
where rownum=1
and name not like'%arcas%'


select 
name
,'job duration history' as [orig_table]
,status, run_duration,run_minutes,left(run_date,4)+'-'+right(left(run_date,6),2)+'-'+right(run_date,2) as run_date ,env,client,rownum from(
SELECT distinct
*
 ,ROW_NUMBER() over (partition by a.name order by run_date desc) rownum
  FROM
  (select distinct 
   a.name
 , a.status
 ,a.run_date
 ,a.env
,a.client
,run_duration as run_minutes
 , CASE LEN(a.run_duration)
            WHEN 1 THEN '00:00:0' + CONVERT(CHAR(1),a.run_duration)
            WHEN 2 THEN '00:00:' + CONVERT(CHAR(2),a.run_duration)
            WHEN 3 THEN '00:0' + CONVERT(CHAR(1),LEFT(a.run_duration,1)) + ':' + CONVERT(CHAR(2),RIGHT(a.run_duration,2))
            WHEN 4 THEN '00:' + CONVERT(CHAR(2),LEFT(a.run_duration,2)) + ':' + CONVERT(CHAR(2),RIGHT(a.run_duration,2))
            WHEN 5 THEN '0' + CONVERT(CHAR(1),LEFT(a.run_duration,1)) + ':' + LEFT(RIGHT(a.run_duration,4),2) + ':' + CONVERT(CHAR(2),RIGHT(a.run_duration,2))
            ELSE
                  CONVERT(VARCHAR(4),LEFT(a.run_duration,LEN(a.run_duration)-4)) + ':' + LEFT(RIGHT(a.run_duration,4),2) + ':' + CONVERT(CHAR(2),RIGHT(a.run_duration,2))
            END AS run_duration

 from  [dbo].[nightly_job_history] a
  join [dbo].[nightly_jobs_status] b 
  on a.name=b.name
  where step_id = 0) a
  ) a where rownum < 9


select top 10* from report_output