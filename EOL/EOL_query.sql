IF OBJECT_ID('tempdb..#persons') IS NOT NULL 
    DROP TABLE #persons  

select pm.member_id
, sex
, dob
, death_date
,DATEDIFF(year,dob,death_date) as death_age
, service_from_date
, service_thru_date
, coalesce(submitted_total_billed_amount,0) as submitted_total_billed_amount
into #persons
from plan_member pm
join plan_claim_header pch
on pch.member_id=pm.member_id
and pch.delete_ind='N'
and pch.final_claim_ind='Y'
where death_date is not null
and pm.delete_ind='N'
and service_from_date<death_date
and dateadd(month,3,service_from_date)>death_date

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
JOIN (SELECT  top 10 * FROM #persons_costs 
order by cost desc) b
on p.member_id=b.member_id
and p.cost=b.cost
--select * from #persons_costs


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


SELECT  age_bucket,avg(cost) as cost ,week from #persons_costs
group by age_bucket,week