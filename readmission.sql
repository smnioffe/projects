 IF OBJECT_ID('tempdb..#cpt') IS NOT NULL 
    DROP TABLE #cpt  
 
 select *
into #cpt
 from(
 select '99201–99216' as CPT, 'Office/other outpatient services' as L1 ,'Office/other outpatient services' as L2
union all select '99217–99220' as CPT, 'Hospital observation services' as L1 ,'Hospital observation services' as L2
union all select '99221–99239' as CPT, ' Hospital inpatient services' as L1 ,' Hospital inpatient services' as L2
union all select '99241–99255' as CPT, ' Consultations' as L1 ,' Consultations' as L2
--union all select '99281–99288' as CPT, ' Emergency department services' as L1 ,' Emergency department services' as L2
union all select '99291–99292' as CPT, ' Critical care services' as L1 ,' Critical care services' as L2
union all select '99304–99318' as CPT, ' Nursing facility services' as L1 ,' Nursing facility services' as L2
union all select '99324–99337' as CPT, ' Domiciliary, rest home (boarding home  or custodial care services)' as L1 ,' Domiciliary, rest home (boarding home  or custodial care services)' as L2
union all select '99339–99340' as CPT, ' Domiciliary, rest home (assisted living facility, or home care plan oversight services)' as L1 ,' Domiciliary, rest home (assisted living facility, or home care plan oversight services)' as L2
union all select '99341–99350' as CPT, ' Home health services' as L1 ,' Home health services' as L2
union all select '99354–99360' as CPT, ' Prolonged services' as L1 ,' Prolonged services' as L2
union all select '99363–99368' as CPT, ' Case management services' as L1 ,' Case management services' as L2
union all select '99374–99380' as CPT, ' Care plan oversight services' as L1 ,' Care plan oversight services' as L2
union all select '99381–99429' as CPT, ' Preventive medicine services' as L1 ,' Preventive medicine services' as L2
union all select '99441–99444' as CPT, ' Non-face-to-face physician services' as L1 ,' Non-face-to-face physician services' as L2
union all select '99450–99456' as CPT, ' Special evaluation and management services' as L1 ,' Special evaluation and management services' as L2
union all select '99460–99465' as CPT, ' Newborn care services' as L1 ,' Newborn care services' as L2
union all select '99466–99480' as CPT, ' Inpatient neonatal intensive, and pediatric/neonatal critical, care services' as L1 ,' Inpatient neonatal intensive, and pediatric/neonatal critical, care services' as L2
union all select '99487–99489' as CPT, ' Complex chronic care coordination services' as L1 ,' Complex chronic care coordination services' as L2
union all select '99495–99496' as CPT, ' Transitional care management services' as L1 ,' Transitional care management services' as L2
union all select '99499' as CPT, ' Other evaluation and management services' as L1 ,' Other evaluation and management services' as L2
union all select '00100–00222' as CPT, ' head' as L1 ,'anethesia' as L2
union all select '00300–00352' as CPT, ' neck' as L1 ,'anethesia' as L2
union all select '00400–00474' as CPT, ' thorax' as L1 ,'anethesia' as L2
union all select '00500–00580' as CPT, ' intrathoracic' as L1 ,'anethesia' as L2
union all select '00600–00670' as CPT, ' spine and spinal cord' as L1 ,'anethesia' as L2
union all select '00700–00797' as CPT, ' upper abdomen' as L1 ,'anethesia' as L2
union all select '00800–00882' as CPT, ' lower abdomen' as L1 ,'anethesia' as L2
union all select '00902–00952' as CPT, ' perineum' as L1 ,'anethesia' as L2
union all select '01112–01190' as CPT, ' pelvis (except hip' as L1 ,'anethesia' as L2
union all select '01200–01274' as CPT, ' upper leg (except knee' as L1 ,'anethesia' as L2
union all select '01320–01444' as CPT, ' knee and popliteal area' as L1 ,'anethesia' as L2
union all select '01462–01522' as CPT, ' lower leg (below knee' as L1 ,'anethesia' as L2
union all select '01610–01682' as CPT, ' shoulder and axillary' as L1 ,'anethesia' as L2
union all select '01710–01782' as CPT, ' upper arm and elbow' as L1 ,'anethesia' as L2
union all select '01810–01860' as CPT, ' forearm, wrist and hand' as L1 ,'anethesia' as L2
union all select '01916–01936' as CPT, ' radiological procedures' as L1 ,'anethesia' as L2
union all select '01951–01953' as CPT, ' burn excisions or debridement' as L1 ,'anethesia' as L2
union all select '01958–01969' as CPT, ' obstetric' as L1 ,'anethesia' as L2
union all select '01990–01999' as CPT, ' other procedures' as L1 ,'anethesia' as L2
union all select '99100–99140' as CPT, ' qualifying circumstances for anesthesia' as L1 ,'anethesia' as L2
union all select '99143–99150' as CPT, ' moderate (conscious sedation)' as L1 ,'anethesia' as L2
union all select '10000–10022' as CPT, ' general' as L1 ,'surgery' as L2
union all select '10040–19499' as CPT, ' integumentary system' as L1 ,'surgery' as L2
union all select '20000–29999' as CPT, ' musculoskeletal system' as L1 ,'surgery' as L2
union all select '30000–32999' as CPT, ' respiratory system' as L1 ,'surgery' as L2
union all select '33010–37799' as CPT, ' cardiovascular system' as L1 ,'surgery' as L2
union all select '38100–38999' as CPT, ' hemic and lymphatic systems' as L1 ,'surgery' as L2
union all select '39000–39599' as CPT, ' mediastinum and diaphragm' as L1 ,'surgery' as L2
union all select '40490–49999' as CPT, ' digestive system' as L1 ,'surgery' as L2
union all select '50010–53899' as CPT, ' urinary system' as L1 ,'surgery' as L2
union all select '54000–55899' as CPT, ' male genital system' as L1 ,'surgery' as L2
union all select '55920–55980' as CPT, ' reproductive system and intersex' as L1 ,'surgery' as L2
union all select '56405–58999' as CPT, ' female genital system' as L1 ,'surgery' as L2
union all select '59000–59899' as CPT, ' maternity care and delivery' as L1 ,'surgery' as L2
union all select '60000–60699' as CPT, ' endocrine system' as L1 ,'surgery' as L2
union all select '61000–64999' as CPT, ' nervous system' as L1 ,'surgery' as L2
union all select '65091–68899' as CPT, ' eye and ocular adnexa' as L1 ,'surgery' as L2
union all select '69000–69979' as CPT, ' auditory system' as L1 ,'surgery' as L2
union all select '70000–76499' as CPT, ' diagnostic imaging' as L1 ,'radiology' as L2
union all select '76506–76999' as CPT, ' diagnostic ultrasound' as L1 ,'radiology' as L2
union all select '77001–77032' as CPT, ' radiologic guidance' as L1 ,'radiology' as L2
union all select '77051–77059' as CPT, ' breast mammography' as L1 ,'radiology' as L2
union all select '77071–77084' as CPT, ' bone/joint studies' as L1 ,'radiology' as L2
union all select '77261–77799' as CPT, ' radiation oncology' as L1 ,'radiology' as L2
union all select '78000–79999' as CPT, ' nuclear medicine' as L1 ,'radiology' as L2
union all select '80000–80076' as CPT, ' organ or disease-oriented panels' as L1 ,'pathology and laboratory' as L2
union all select '80100–80103' as CPT, ' drug testing' as L1 ,'pathology and laboratory' as L2
union all select '80150–80299' as CPT, ' therapeutic drug assays' as L1 ,'pathology and laboratory' as L2
union all select '80400–80440' as CPT, ' evocative/suppression testing' as L1 ,'pathology and laboratory' as L2
union all select '80500–80502' as CPT, ' consultations (clinical pathology' as L1 ,'pathology and laboratory' as L2
union all select '81000–81099' as CPT, ' urinalysis' as L1 ,'pathology and laboratory' as L2
union all select '82000–84999' as CPT, ' chemistry' as L1 ,'pathology and laboratory' as L2
union all select '85002–85999' as CPT, ' hematology and coagulation' as L1 ,'pathology and laboratory' as L2
union all select '86000–86849' as CPT, ' immunology' as L1 ,'pathology and laboratory' as L2
union all select '86850–86999' as CPT, ' transfusion medicine' as L1 ,'pathology and laboratory' as L2
union all select '87001–87999' as CPT, ' microbiology' as L1 ,'pathology and laboratory' as L2
union all select '88000–88099' as CPT, ' anatomic pathology (postmortem' as L1 ,'pathology and laboratory' as L2
union all select '88104–88199' as CPT, ' cytopathology' as L1 ,'pathology and laboratory' as L2
union all select '88230–88299' as CPT, ' cytogenetic studies' as L1 ,'pathology and laboratory' as L2
union all select '88300–88399' as CPT, ' surgical pathology' as L1 ,'pathology and laboratory' as L2
union all select '88720–88741' as CPT, ' in vivo (transcutaneous lab procedures)' as L1 ,'pathology and laboratory' as L2
union all select '89049–89240' as CPT, ' other procedures' as L1 ,'pathology and laboratory' as L2
union all select '89250–89398' as CPT, ' reproductive medicine procedures' as L1 ,'pathology and laboratory' as L2
union all select '90281–90399' as CPT, ' immune globulins, serum or recombinant prods' as L1 ,'medicine' as L2
union all select '90465–90474' as CPT, ' immunization administration for vaccines/toxoids' as L1 ,'medicine' as L2
union all select '90476–90749' as CPT, ' vaccines, toxoids' as L1 ,'medicine' as L2
union all select '90801–90899' as CPT, ' psychiatry' as L1 ,'medicine' as L2
union all select '90901–90911' as CPT, ' biofeedback' as L1 ,'medicine' as L2
union all select '90935–90999' as CPT, ' dialysis' as L1 ,'medicine' as L2
union all select '91000–91299' as CPT, ' gastroenterology' as L1 ,'medicine' as L2
union all select '92002–92499' as CPT, ' ophthalmology' as L1 ,'medicine' as L2
union all select '92502–92700' as CPT, ' special otorhinolaryngologic services' as L1 ,'medicine' as L2
union all select '92950–93799' as CPT, ' cardiovascular' as L1 ,'medicine' as L2
union all select '93875–93990' as CPT, ' noninvasive vascular diagnostic studies' as L1 ,'medicine' as L2
union all select '94002–94799' as CPT, ' pulmonary' as L1 ,'medicine' as L2
union all select '95004–95199' as CPT, ' allergy and clinical immunology' as L1 ,'medicine' as L2
union all select '95250–95251' as CPT, ' endocrinology' as L1 ,'medicine' as L2
union all select '95803–96020' as CPT, ' neurology and neuromuscular procedures' as L1 ,'medicine' as L2
union all select '96101–96125' as CPT, ' central nervous system assessments/tests (neuro-cognitive, mental status, speech testing' as L1 ,'medicine' as L2
union all select '96150–96155' as CPT, ' health and behavior assessment/intervention' as L1 ,'medicine' as L2
union all select '96360–96549' as CPT, ' hydration, therapeutic, prophylactic, diagnostic injections and infusions, and chemotherapy and other highly complex drug or highly complex biologic agent administration' as L1 ,'medicine' as L2
union all select '96567–96571' as CPT, ' photodynamic therapy' as L1 ,'medicine' as L2
union all select '96900–96999' as CPT, ' special dermatological procedures' as L1 ,'medicine' as L2
union all select '97001–97799' as CPT, ' physical medicine and rehabilitation' as L1 ,'medicine' as L2
union all select '97802–97804' as CPT, ' medical nutrition therapy' as L1 ,'medicine' as L2
union all select '97810–97814' as CPT, ' acupuncture' as L1 ,'medicine' as L2
union all select '98925–98929' as CPT, ' osteopathic manipulative treatment' as L1 ,'medicine' as L2
union all select '98940–98943' as CPT, ' chiropractic manipulative treatment' as L1 ,'medicine' as L2
union all select '98960–98962' as CPT, ' education and training for patient self-management' as L1 ,'medicine' as L2
union all select '98966–98969' as CPT, ' non-face-to-face nonphysician services' as L1 ,'medicine' as L2
union all select '99000–99091' as CPT, ' special services, procedures and reports' as L1 ,'medicine' as L2
union all select '99170–99199' as CPT, ' other services and procedures' as L1 ,'medicine' as L2
union all select '99500–99602' as CPT, ' home health procedures/services' as L1 ,'medicine' as L2
union all select '99605–99607' as CPT, ' medication therapy management services' as L1 ,'medicine' as L2
union all select '99605–99607' as CPT, 'medication therapy management services' as L1 ,'medicine' as L2

) a




IF OBJECT_ID('tempdb..#persons') IS NOT NULL 
    DROP TABLE #persons  

select distinct e.personID,e.startdate,e.enddate
into #persons  
 from rpt.event e
join [rpt].[EventCode] ec
on ec.[EventCodeID]=e.[EventCodeID]
and ec.codeset='cpt'
and ec.[CodeValue] between '99281' and '99285' 
--or (procedure_code between '10030' and '69979' and pos='23'
--join rpt.event e2
--on e.personid=e2.personid
--join [rpt].[EventCode] ec2
--on ec2.[EventCodeID]=e2.[EventCodeID] 
--and ec2.codeset='pos'
--and ec2.[CodeValue] ='21'
--and e2.startdate=e.startdate 
where e.startdate>'2015-01-01'


IF OBJECT_ID('tempdb..#readmission') IS NOT NULL 
  DROP TABLE #readmission
select distinct a.*, case when b.personid is not null then 1 else 0 end as readmission
 into #readmission
 from #persons  a
left join #persons b
on a.personId=b.personId
and b.startdate between dateadd(day,2,a.enddate) and dateadd(day,31,a.enddate)

IF OBJECT_ID('tempdb..#readmission_persons') IS NOT NULL 
 DROP TABLE #readmission_persons
select personID,max(readmission) as readmission
into #readmission_persons
 from #readmission
  group by personID




IF OBJECT_ID('tempdb..#pivot') IS NOT NULL 
 DROP TABLE #pivot
 select * into #pivot from(
select a.*,am.name,m.numerator as value
 from #readmission_persons a
left join rpt.measuresubject m
on a.personID=m.subjectID
and m.subjecttype='p'
join rpt.period p
on p.period_id=m.periodid
and p.name='2015'
join [rpt].[ArcasMeasure] am
on am.measureid=m.measureid
and am.name not like '%child%' and am.name not like '%adult%'
union
SELECT a.personid
	   ,readmission
      ,[Name]
      ,[value_ind] as value
  FROM #readmission_persons a
  join [rpt].[SinglePatientConditional] b
  on a.personid=b.personid

union

select distinct
e.personid
,readmission
,l2 as name
,1 as value
   
 from rpt.event e
 join #readmission_persons p
on p.personid=e.personid
join [rpt].[EventCode] ec
on ec.[EventCodeID]=e.[EventCodeID]
 join #cpt b
		  on ec.[CodeValue] between left(b.[cpt],5) and right(b.[cpt],5)
		  or  ec.[CodeValue] = left(b.[cpt],5) 
where e.startdate>'2014-01-01'
and  e.enddate<'2015-01-01'

union 

select 
a.personid
,readmission
,b.name+'_numeric' as name
, cast(case 
when isnumeric(value)=1 and round(try_convert(decimal(10,2), value),0) > 500.00 then 500
when isnumeric(value)=1 then round(try_convert(decimal(10,2), value),0)
 else round(try_convert(decimal(10,2), b.avg_val),0) end as int)   as value
from [rpt].[SinglePatientConditional] a
join (

select name, avg(convert(numeric(9,2),value)) as avg_val from(
SELECT top 10000 [Name]
	  , round(try_convert(decimal(10,2), value),2) value
      
  FROM [rpt].[SinglePatientConditional]
where isnumeric(value)=1
) a 
where name not like '%depression%' and name not like '%screen%'  and name not like '%tobac%' and name not like '%pap%'
group by name

) b
on a.name=b.name
  join #readmission_persons c
  on a.personid=c.personid

)a

UPDATE #pivot
set name=replace(name,',','') 

 DECLARE @i int
 DECLARE @y varchar(max)
 DECLARE @y2 varchar(max)
 DECLARE @columns varchar(max)
 DECLARE @columns2 varchar(max)
 SET @i = 1 
 SET @columns=''
 SET @columns2=''
      
	  IF OBJECT_ID('tempdb..#rc') IS NOT NULL 
       DROP TABLE #rc;
	  select name, row_number() over(order by name desc) as rownum  into #rc from(
	  SELECT distinct name from #pivot ) a

 WHILE (@i <=(SELECT max(rownum) from #rc ))
  BEGIN
    IF @i=1 
    BEGIN
	set @y=(select name from #rc where rownum=@i)
	--set @y2=(select replace(name,',','') from #rc where rownum=@i)
	   set @columns=@columns +'coalesce([' +cast(@y as varchar(max))+'],0) as ['+@y+']'
	  set @columns2=@columns2 +'[' +cast(@y as varchar(max))+']'
    END
    ELSE
	BEGIN
	set @y=(select name from #rc where rownum=@i)
	set @y2=(select replace(name,',','') from #rc where rownum=@i)
      SET @columns=@columns +',coalesce([' +cast(@y as varchar(max))+'],0) as ['+@y+']'
     set @columns2=@columns2 +',[' +cast(@y as varchar(max))+']'
    END
 --PRINT @columns
  set @i=@i+1;
  END


DECLARE @DynamicPivotQuery AS NVARCHAR(MAX)

SET @DynamicPivotQuery = 
  N'
   SELECT readmission, ' + @columns + '
    FROM (SELECT personid,readmission,value,name
	   FROM #pivot) AS SourceTable
    PIVOT(AVG(value) 
          FOR [name] IN (' + @columns2 + ')) AS PVTTable '

EXEC sp_executesql @DynamicPivotQuery
--print @DynamicPivotQuery








