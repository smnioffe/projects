import sys

implementations = ["AHP", "ACP", "Silverton" ]
content = "This is the first line of code\nThis is my second line of code with %s the first item in my list\nAnd this is my last line of code"

for item in items:
    with open("%s_hello_world.txt" % item, "w") as f:
        f.write(content % item)