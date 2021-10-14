###########
#FILE OUTPUT
###########

#Save the elements of a list into a file


list_to_save = range(100)

#Now open and create a file named 'testout.txt' in the sandbox folder
f = open('../sandbox/testout.txt', 'w')
#Now save the list (1 to 100) as a string in the testout.txt file
for i in list_to_save:
    f.write(str(i) + '\n') ## '\n' adds a new line at the end (eg. 101)

f.close()