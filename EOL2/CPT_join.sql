/****** Script for SelectTopNRows command from SSMS  ******/
--SELECT TOP 1000 [description]
--      ,[procedure_code]
--      ,[occurrence]
--      ,[avg_cost]

select category,sum(occurrence) as occurrence ,cast(sum(total_cost)/sum(cast(occurrence as numeric)) as int) as avg_cost
from (
select
case when category is NULL then 'Other'
when occurrence=1 and avg_cost <1000 then 'Other'
else  category end as category
,occurrence
,avg_cost
,cast(avg_cost as numeric)*cast(occurrence as numeric) as total_cost
from(
select
category,sum(occurrence) as occurrence ,cast(sum(total_cost)/sum(cast(occurrence as numeric)) as int) as avg_cost
from(

		select 
		description
		,procedure_code
		,cast(occurrence as numeric) as occurrence
		,avg_cost
		,cast(avg_cost as numeric)*cast(occurrence as numeric) as total_cost
		,case
		when [CCS Label]is null and description like '%anesth%' then'Anesthesia' 
		when [CCS Label]is null and description like '%antibio%' or description like '%cefazolin%' then'Antibiotics' 
		when  [CCS Label]is null and description like '% ecg %' then 'Electrographic cardiac monitoring'
		else REPLACE([CCS Label], '"', '') end  as category
		  FROM [simon].[dbo].[output] a
		  left join dbo.cpt b
		  on a.[procedure_code] between left(b.[Code Range],5) and right(b.[Code Range],5)
		  or  a.[procedure_code] = left(b.[Code Range],5) 
		  --order by category
) a group by category
) a
) a group by category