select

		'job duration' as [orig_table]
     -- ,[start_time]
     -- ,[end_date]
	  ,[last_step_name] as type
      ,[job_complete] as value1
      ,[run_days] as value2
      ,cast([run_hours]as varchar(max)) as value3
      ,[run_minutes] as value4

      ,[last_step_id] as value5
      ,[last_step_date] as date_value
	  ,[name] as database_name
	  ,[CLIENT] as client
      ,[ENV] as env
	  ,getdate() as modify_timestamp
	  ,getdate() as create_timestamp
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





	  --(
   --   [orig_table]
   --   ,[type]
   --   ,[value1]
   --   ,[value2]
   --   ,[value3]
   --   ,[value4]
   --   ,[value5]
   --   ,[date_value]
   --   ,[database_name]
   --   ,[client]
   --   ,[env]
   --   ,[modify_timestamp]
   --   ,[create_timestamp]
   --   ,[entry_timestamp]
	  -- ,[updated_timestamp]

   --   )


select
'job duration history' as [orig_table]
,status as type
,run_duration as value1
,run_minutes as value2
,left(run_date,4)+'-'+right(left(run_date,6),2)+'-'+right(run_date,2) as value3--run_date 
,rownum as value4
,null as value5
,null as date_value
,name as database_name
,client
,env
,getdate() as modify_timestamp
,getdate() as create_timestamp
,[entry_timestamp]
,[updated_timestamp]
from(
SELECT distinct
*
 ,ROW_NUMBER() over (partition by a.name order by run_date desc) rownum
  FROM
  (select distinct 
  a.status
 ,a.run_date
 ,a.client
 ,a.env
 ,a.name 
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
,min(a.[entry_timestamp]) as [entry_timestamp]
      ,max(a.[updated_timestamp]) as [updated_timestamp]
 from  [dbo].[nightly_job_history] a
  join [dbo].[nightly_jobs_status] b 
  on a.name=b.name
  where step_id = 0
  and run_duration>45
  group by
    a.status
 ,a.run_date
 ,a.client
 ,a.env
 ,a.name 
,run_duration  
  ) a
  ) a where rownum < 9




