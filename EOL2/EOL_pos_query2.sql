IF OBJECT_ID('tempdb..#persons') IS NOT NULL 
    DROP TABLE #persons  

select * 
into #persons --select * from #persons
from(
select pm.member_id
, sex
, dob
, death_date
,DATEDIFF(year,dob,death_date) as death_age
, pch.service_from_date
, pch.service_thru_date
, coalesce(submitted_total_billed_amount,0) as submitted_total_billed_amount
--into #persons
from [QDWSQLPROD03].[CHPW_WAREHOUSE_prd].[dbo].[plan_member] pm
join [QDWSQLPROD03].[CHPW_WAREHOUSE_prd].[dbo].plan_claim_header pch
on pch.member_id=pm.member_id
and pch.delete_ind='N'
and pch.final_claim_ind='Y'
--join [QDWSQLPROD03].[CHPW_WAREHOUSE_prd].[dbo].plan_claim_line pcl
--on pcl.claim_header_id=pch.claim_header_id
where death_date is not null
and pm.delete_ind='N'
and pch.service_from_date<death_date
and dateadd(month,3,pch.service_from_date)>death_date

) a


IF OBJECT_ID('tempdb..#person_claims') IS NOT NULL 
    DROP TABLE #person_claims  


--select pos, count(*) as occurrence, [week], avg(avg_cost) as avg_cost from(
select distinct member_id, sex, death_age
--,description
,procedure_code--,pos
--,  DATEDIFF(week,death_date,service_from_date) as [week]
, avg(billed_amount) as avg_cost 
into #person_claims from(
select distinct pc.*,billed_amount,admitting_diagnosis_unscrubbed,procedure_code--,pos
,procedure_code_type, procedure_code_type_unscrubbed from (
SELECT distinct * FROM #persons  pc
--where DATEDIFF(week,death_date,service_from_date)=0
--order by submitted_total_billed_amount desc
 ) pc
join plan_claim_header pch on
 pc.member_id=pch.member_id
 and pch.submitted_total_billed_amount=pc.submitted_total_billed_amount
 and pch.service_from_date=pc.service_from_date
 and final_claim_ind='y'
 and pch.delete_ind='n'
 join [CHPW_WAREHOUSE_PRD].[dbo].plan_claim_line pcl --select top 100 * from [CHPW_WAREHOUSE_PRD].[dbo].plan_claim_line 
 on pcl.claim_header_id=pch.claim_header_id
 and pcl.delete_ind='n'
 and procedure_code_type='CPT'

 ) a
 group by member_id--,pos
 ,procedure_code, sex, death_age--,  DATEDIFF(week,death_date,service_from_date)
 --) a group by pos,week



 delete p
from #person_claims p
JOIN (SELECT  top 25 * FROM #person_claims 
order by avg_cost desc) b
on p.member_id=b.member_id
and p.avg_cost=b.avg_cost
--select * from #persons_costs

delete p
from #person_claims p
JOIN (SELECT top 25 * FROM #person_claims 
order by avg_cost asc) b
on p.member_id=b.member_id
and p.avg_cost=b.avg_cost




IF OBJECT_ID('tempdb..#categorized') IS NOT NULL 
   DROP TABLE #categorized  


select 
	  [sex]
, round(death_age,-1)  as age
      ,avg_cost as [cost]
      ,procedure_code as [cpt]
     -- ,pos as [pos]
	  , [CCSMinorDescription]
	  ,[CCSMajorName]
      ,[CCSMajorDescription]
      ,[CCSPriority]
      ,[ColorCode]
into #categorized  
 from #person_claims pc
 join [CHPW_WAREHOUSE_PRD].[ccs].[ProcedureCodeMap] pcm
on pcm.[CodeValue]=pc.procedure_code
and codetype='cpt'
join [CHPW_WAREHOUSE_PRD].[ccs].[ProcedureMinorCategory] pmc
on pmc.[CCSMinorCode]=pcm.[CCSMinorCode]
join [CHPW_WAREHOUSE_PRD].[ccs].[ProcedureMajorCategory] pmac
on pmac.[CCSMajorCode]=pmc.[CCSMajorCode]



select avg_cost
,n
,CCSMinorDescription as minor
,CCSMajorName as major
--,CCSPriority as priority
,ColorCode as color_code
 from (
select avg(cost) as avg_cost, count(*) as n
,replace([CCSMinorDescription],',','') as [CCSMinorDescription]
	  ,replace([CCSMajorName],',','') as [CCSMajorName]
      ,replace([CCSPriority],',','') as [CCSPriority]
      ,[ColorCode]
from #categorized 
group by
 [CCSMinorDescription]
	  ,[CCSMajorName]
      ,[CCSPriority]
      ,[ColorCode]
	  ) a where n>9
	  and ccsminordescription is not null



select avg(avg_cost) as avg_cost
,count(*) as n
,CCSMinorDescription as minor
,CCSMajorName as major
--,CCSPriority as priority
,ColorCode as color_code
 from (
select cost as avg_cost--, count(*) as n
,replace([CCSMinorDescription],',','') as [CCSMinorDescription]
	  ,case when CCSMajorName='Anesthesia, labs, and medication supplies' then 'Anesthesia labs and medication supplies'
when CCSMajorName='Diagnostic Procedures' then 'Diagnostic Procedures'
when CCSMajorName='Evaluation and Therapeutic Procedures' then 'Evaluation and Therapeutic Procedures'
when CCSMajorName='Unspecified and ancillary services' then 'Unspecified and ancillary services'
when CCSMajorName='Obstetrical procedures' then 'Obstetrical procedures'
else 'Procedure' end as CCSMajorName
      ,replace([CCSPriority],',','') as [CCSPriority]
      , case when CCSMajorName not in ('Anesthesia, labs, and medication supplies','Diagnostic Procedures','Evaluation and Therapeutic Procedures','Unspecified and ancillary services','Obstetrical procedures')
	  then '#7bc143' else colorcode end as ColorCode
from #categorized 
where ccsminordescription is not null
) a
   where ccsminordescription is not null
group by
 [CCSMinorDescription]
	  ,CCSMajorName
      ,[CCSPriority]
      ,[ColorCode]
	  having count(*) >9
	
