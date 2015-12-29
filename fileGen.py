import csv
import sys
import os.path

implementations = ["AHP", "ACP", "Silverton" ]
content = """
Status: Internal-Only
Author: Author;
CreateDate: 2015-12-16
ModifyDate: 2015-12-16

#Client Full Name (%(cli)s)

## Sections:
* [Client Details](#client-details)
* [Overview](#overview)
* [Inbound Data Sources](#inbound-data-sources)
* [Outbound Data Sources](#outbound-data-sources)
* [External Links](#external-links)
* [Out of Scope](#out-of-scope)

##Client Details
####Client Name
Client Full Name

####Client Density Area
Client Density Area

####Client Acronym
%(cli)s

####Client Contract IDs
Client Contacts


##Overview


###Description
Description of Client Full Name
###Location
Location of Client Full Name
###Other Details
Other  details
###Front-end URLs
* [PROD Front-End](https://%(cli)s.arcadiaanalytics.com/)

* [UAT Front-End](https://%(cli)stest.arcadiaanalytics.com/)

* [QA Front-End](https://%(cli)snwebtst01.arcadiahosted.local/)  


###Contacts  

##Inbound Data Sources
###Claims
* PSource1
###Clinical
* CSource1
###Other
If applicable

##Outbound Data Sources
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
* [JIRA Open Issues](https://jira.arcadiasolutions.com/issues/?jql=labels%20%3D%20%(cli)s)
* [Repo on Github](https://github.com/arcadia/qdw-%(cli)s) 
* [BOX - SoW](https://arcadia.app.box.com/files/0/f/1570839907/%(cli)s)
* Link [Deployment History]

##Attachments
* Put Releveant Attachments Here
"""

import json

import csv





tree = {}

reader = csv.reader(open('implementation_sources.csv', 'rb'))
reader.next() 
for row in reader:
    subtree = tree
    for i, cell in enumerate(row):
        if cell:
            if cell not in subtree:
                subtree[cell] = {} if i<len(row)-1 else 1
            subtree = subtree[cell]

print tree#json.dumps(tree, indent=4)

# with open('implementation_sources.csv') as f:
    # f=[x.strip() for x in f if x.strip()]
    # data=[tuple(x.split()) for x in f[2:]]
    # charges=[x[0] for x in data]
    # times=[x[0] for x in data]
    # print('times',times)
    # print('charges',charges)
	

	
	
for client in tree :
	folder="~Implementations\%s" % (client) 
	file="~Implementations\%s\%s.md" % (client,client)
	dir = os.path.dirname(__file__)
	print(os.path.join(dir,folder))
	if not os.path.exists(os.path.join(dir,folder)):
		os.makedirs(os.path.join(dir,folder))
	with open(os.path.join(dir,file), "w") as f:
		f.write(content % {'cli':client})	


