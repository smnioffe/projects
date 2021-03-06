/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [Arc_Client_Acronym] as client_acronym
      ,[Arc_Client_Name] as client_name
	  ,case when [Arc_Client_Name] like '%silverton%' then 'Silverton' 
	  when [Arc_Client_Name] like '%Excellus%' then 'Excellus' 
	  else Arc_Client_Acronym end as client_alt_name
      ,[Arc_Source_Acronym] as source_acronym
      ,[Arc_Source_Name] as source_name
	  ,case when [Arc_Source_Name] like '%claim%' or [Arc_Source_Name] like '%plan%' then 'Claim' else 'Clinical' end as source_type
  FROM [InformaticaConfig_PRD].[dbo].[v_Client_Sources]
  where Arc_Client_Name NOT like '%test%'
 and Arc_Client_Name NOT like '%hotfix%'
 and Arc_Client_Name NOT like '%azara%'
 and Arc_Client_Acronym NOT like '%LHCQFOLD%'
  and Arc_Client_Acronym NOT like '%PRSEXT%'
  and Arc_Client_Acronym <> 'PRSEXT'
  and Arc_Client_Acronym NOT like '%UPGRADE%'