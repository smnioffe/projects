import sys
import os.path

implementations = ["AHP", "ACP", "Silverton" ]
content = """
Status: Internal-Only
Author: 
CreateDate: 
ModifyDate: 

#%(cli)s

##Data Sources
###Claims Sources

#####%(cli)s
"""




for client in implementations :
	folder="~Implementations\%s" % client
	file="~Implementations\%s\%s.md" % (client,client)
	dir = os.path.dirname(__file__)
	print(os.path.join(dir,folder))
	if not os.path.exists(os.path.join(dir,folder)):
		os.makedirs(os.path.join(dir,folder))
	with open(os.path.join(dir,file), "w") as f:
		f.write(content % {'cli':client})	


