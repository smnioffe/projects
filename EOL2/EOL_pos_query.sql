IF OBJECT_ID('tempdb..#persons') IS NOT NULL 
    DROP TABLE #persons  

select * 
into #persons
from(
select pm.member_id
, sex
, dob
, death_date
,DATEDIFF(year,dob,death_date) as death_age
, service_from_date
, service_thru_date
, coalesce(submitted_total_billed_amount,0) as submitted_total_billed_amount
--into #persons
from [QDWSQLqa02].[CHPW_WAREHOUSE_UAT].[dbo].[plan_member] pm
join [QDWSQLqa02].[CHPW_WAREHOUSE_UAT].[dbo].plan_claim_header pch
on pch.member_id=pm.member_id
and pch.delete_ind='N'
and pch.final_claim_ind='Y'
where death_date is not null
and pm.delete_ind='N'
and service_from_date<death_date
and dateadd(month,3,service_from_date)>death_date
--union all
--select pm.member_id
--, sex
--, dob
--, death_date
--,DATEDIFF(year,dob,death_date) as death_age
--, service_from_date
--, service_thru_date
--, coalesce(submitted_total_billed_amount,0) as submitted_total_billed_amount
----into #persons
--from [QDWSQLqa02].[CCCN_WAREHOUSE_UAT].
--[dbo].[plan_member] pm
--join [QDWSQLqa02].[CCCN_WAREHOUSE_UAT].
--[dbo].plan_claim_header pch
--on pch.member_id=pm.member_id
--and pch.delete_ind='N'
--and pch.final_claim_ind='Y'
--where death_date is not null
--and pm.delete_ind='N'
--and service_from_date<death_date
--and dateadd(month,3,service_from_date)>death_date
) a

select pos, count(*) as occurrence, [week], avg(avg_cost) as avg_cost from(
select distinct member_id,description,procedure_code,pos,  DATEDIFF(week,death_date,service_from_date) as [week], avg(submitted_total_billed_amount) as avg_cost  from(
select distinct pc.*,admitting_diagnosis_unscrubbed,procedure_code,pos,procedure_code_type, procedure_code_type_unscrubbed,description,[code_category] from (
SELECT distinct * FROM #persons  pc
where DATEDIFF(week,death_date,service_from_date)=0
--order by submitted_total_billed_amount desc
 ) pc
join plan_claim_header pch on
 pc.member_id=pch.member_id
 and pch.submitted_total_billed_amount=pc.submitted_total_billed_amount
 and pch.service_from_date=pc.service_from_date
 and final_claim_ind='y'
 and pch.delete_ind='n'
 join [CHPW_WAREHOUSE_PRD].[dbo].plan_claim_line pcl
 on pcl.claim_header_id=pch.claim_header_id
 and procedure_code_type='CPT'
 left join [CHPW_WAREHOUSE_PRD].[lookup].[code] lc
 on lc.code_value=procedure_code
 and lc.code_set='CPT'
 left join [CHPW_WAREHOUSE_PRD].[lookup].[code_categorization] lcc
 on lcc.code_value=procedure_code
 and lcc.code_set='CPT'
 ) a
 group by member_id,description,pos,procedure_code,  DATEDIFF(week,death_date,service_from_date)
 ) a group by pos,week

IF OBJECT_ID('tempdb..#persons_costs') IS NOT NULL 
   DROP TABLE #persons_costs  

select 
 member_id
,sex
,dob
,death_date
,case when death_age < 5 then '<5'
    when death_age >=5 and  death_age<18 then '5-17'
    when death_age >=18 and  death_age<30 then '18-29'
    when death_age >=30 and  death_age<46 then '30-45'
    when death_age >=46 and  death_age<65 then '46-64'
    when death_age >=65  then '65+' else null end as age_bucket
--,death_age
--,DATEDIFF(year,dob,death_date) as death_age
,service_from_date
,sum(submitted_total_billed_amount) as cost
,[week]
into #persons_costs  
FROM
    (select *
    ,DATEDIFF(week,death_date,service_from_date) as week
	from #persons 
    where member_id in (
				select distinct member_id from #persons
				where dateadd(week,1,service_from_date)>death_date
				)) a
group by
 member_id
,sex
,dob
,death_date
,service_from_date
--,death_age--,DATEDIFF(year,dob,death_date)
,[week]
,case when death_age < 5 then '<5'
    when death_age >=5 and  death_age<18 then '5-17'
    when death_age >=18 and  death_age<30 then '18-29'
    when death_age >=30 and  death_age<46 then '30-45'
    when death_age >=46 and  death_age<65 then '46-64'
    when death_age >=65  then '65+' else null end 



    
delete p
from #persons_costs p
JOIN (SELECT  top 25 * FROM #persons_costs 
order by cost desc) b
on p.member_id=b.member_id
and p.cost=b.cost
--select * from #persons_costs

delete p
from #persons_costs p
JOIN (SELECT top 25 * FROM #persons_costs 
order by cost asc) b
on p.member_id=b.member_id
and p.cost=b.cost


 DECLARE @i int
 DECLARE @columns varchar(max)
 DECLARE @columns2 varchar(max)
 SET @i = 1 
 SET @columns=''
 SET @columns2=''
      

 WHILE (@i <=(SELECT MAX(ABS([week])) FROM #persons_costs ))
  BEGIN
    IF @i=1 
    BEGIN
	   set @columns=@columns +'coalesce([-' +cast(@i as varchar(5))+'],0) as ['+cast(@i as varchar(5))+']'
	   set @columns2=@columns2 +'[-' +cast(@i as varchar(5))+']'
    END
    ELSE
    BEGIN
      SET @columns=@columns +',coalesce([-' +cast(@i as varchar(5))+'],0) as ['+cast(@i as varchar(5))+']'
      SET @columns2=@columns2 +',[-' +cast(@i as varchar(5))+']'
    END
  --PRINT @columns
  set @i=@i+1;
  END


DECLARE @DynamicPivotQuery AS NVARCHAR(MAX)

SET @DynamicPivotQuery = 
  N'
   SELECT ''AverageCost'' AS cost_per_week,''total'' as age_bucket, ' + @columns + '
    FROM (SELECT [week], cost
	   FROM #persons_costs) AS SourceTable
    PIVOT(AVG(cost) 
          FOR [week] IN (' + @columns2 + ')) AS PVTTable 
  
  UNION ALL
  
  SELECT ''AverageCost'' AS cost_per_week,age_bucket, ' + @columns + '
    FROM (SELECT [week], cost ,age_bucket
	   FROM #persons_costs) AS SourceTable
    PIVOT(AVG(cost) 
          FOR [week] IN (' + @columns2 + ')) AS PVTTable'
--Execute the Dynamic Pivot Query
--EXEC sp_executesql @DynamicPivotQuery


SELECT  sex,avg(cost) as cost ,abs(week) as week from #persons_costs
group by sex,week