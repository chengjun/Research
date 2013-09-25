print "hello,world"
# this is a comment

for i in range(0,20): # a loop
    print i, # the comma suppresses line break
    
numbers=[i for i in range(0,15)] # a list comprehension
print numbers

if 10 in numbers: # conditional logic
    print True
else:
    print False
