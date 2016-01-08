import csv
import sys
import os.path

import csv

import pandas as pd

contentHead = """
Status: Internal-Only
Author: Author;
CreateDate: 2015-12-16
ModifyDate: 2015-12-16

# %(cliN)s

## Sections:
* [Client Details](#client-details)
* [Overview](#overview)
* [Inbound Data Sources](#inbound-data-sources)
* [Outbound Data Sources](#outbound-data-sources)
* [External Links](#external-links)
* [Out of Scope](#out-of-scope)

##Client Details
####Client Name
%(cliN)s

####Client Density Area
Client Density Area

####Client Acronym
%(cli)s

####Client Contract IDs
Client Contacts


##Overview


###Description
Description of %(cliN)s
###Location
Location of %(cliN)s
###Other Details
Other  details
###Front-end URLs
* [QA Front-End](https://%(cli)swebtst01.arcadiahosted.local/) 
* [UAT Front-End](https://%(cli)stest.arcadiaanalytics.com/) 
* [PROD Front-End](https://%(cliAlt)s.arcadiaanalytics.com/)


###Contacts  

##Inbound Data Sources
###Claims
"""


contentClinicalSourcesHeader = """
###Clinical
"""

contentClinicalSources = """
* [%(srcN)s - %(src)s](../~Sources/%(src)s/index.html) 
"""

contentEnd = """


##Outbound Data Sources
###Report Name
* Details

###Report Name 
* Details


##Out of Scope
Out of scope

##Configurations
* Measures/Reports needed
* Periods Processed
	* Historic/Onetime
	* Weekly
	* Nightly

 
##Customization 
* Custom Schema Elements
* MPI Customization(if any)

##External Links
###Jira Issues
* [JIRA Open Issues](https://jira.arcadiasolutions.com/issues/?jql=labels%%20%%3D%%20%(cli)s)
* [Repo on Github](https://github.com/arcadia/qdw-%(cliAlt)s) 
* [BOX - SoW](https://arcadia.app.box.com/files/0/f/1570839907/%(cli)s)
* Link [Deployment History]

##Attachments
* Put Releveant Attachments Here

"""





df = pd.read_csv('implementation_sources.csv',delimiter=',', encoding="utf-8-sig")	

	
	
for client in pd.unique(df.client_acronym.ravel()):	
	#folder="~Implementations\%s" % (client) 
	folder="~Implementations\%s" % (client) 
	#file="~Implementations\%s\%s.md" % (client,client)
	file="~Implementations\%s.md" % (client)
	dir = os.path.dirname(__file__)
	print(os.path.join(dir,folder))
	clientName= df[df['client_acronym']== client].client_name.iloc[0]
	clientNameAlt= df[df['client_acronym']== client].client_alt_name.iloc[0]
	if not os.path.exists(os.path.join(dir,folder)):
		os.makedirs(os.path.join(dir,folder))
	with open(os.path.join(dir,file), "w") as f:
		f.write(contentHead % {'cli':client,'cliN':clientName,'cliAlt':clientNameAlt})
	for sourceC in df[(df['client_acronym']== client)&(df['source_type']== 'Claim')].source_acronym:
		sourceName= df[(df['client_acronym']== client)&(df['source_acronym']== sourceC)].source_name.iloc[0]
		with open(os.path.join(dir,file), "a") as f:
			f.write(contentClinicalSources% {'src':sourceC,'srcN':sourceName})
	with open(os.path.join(dir,file), "a") as f:
		f.write(contentClinicalSourcesHeader)	
	for sourceC in df[(df['client_acronym']== client)&(df['source_type']== 'Clinical')].source_acronym:
		sourceName= df[(df['client_acronym']== client)&(df['source_acronym']== sourceC)].source_name.iloc[0]
		with open(os.path.join(dir,file), "a") as f:
			f.write(contentClinicalSources% {'src':sourceC,'srcN':sourceName})
	with open(os.path.join(dir,file), "a") as f:
		f.write(contentEnd % {'cli':client,'cliAlt':clientNameAlt})


