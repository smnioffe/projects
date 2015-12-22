SELECT
 name
,start_time
,end_date
,job_complete
,run_minutes / 1440 as run_days
, (run_minutes % 1440) / 60 as run_hours
, (run_minutes % 60) as run_minutes
,last_step_name
,last_step_id
,last_step_date
,case when name like '%QA' then 'QA' else right([name],3) end ENV
 ,SUBSTRING(name,0, CHARINDEX(' ',name)) as CLIENT
  ,getdate() AS [entry_timestamp], getdate() AS [updated_timestamp] 


FROM(


SELECT sj.name
   , run_requested_date as start_time
   , stop_execution_date as end_date
   , case when stop_execution_date is null then 0 else 1 end as job_complete
   , datediff(minute,run_requested_date,coalesce(stop_execution_date,getdate())) as run_minutes
   ,last_executed_step_id as last_step_id
   ,step_name as last_step_name
   ,last_executed_step_date as last_step_date

FROM msdb.dbo.sysjobactivity sja with (nolock) 
INNER JOIN msdb.dbo.sysjobs sj with (nolock) 
ON sja.job_id = sj.job_id
LEFT JOIN  [msdb].[dbo].[sysjobsteps]  ss with (nolock) 
 ON ss.[job_id]=sj.[job_id]
AND ss.[step_id]=sja.[last_executed_step_id]
WHERE sja.start_execution_date IS NOT NULL
   AND (sja.stop_execution_date IS NULL OR sja.stop_execution_date > DATEADD(WEEK,-1,GETDATE()))
   and name like '%nightly%'
   AND NAME NOT LIKE '%upgrade%'
   and name not like '%hotfix%'

   ) a


