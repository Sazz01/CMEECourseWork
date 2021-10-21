


import csv

# Read a file containing:
# 'Species','Infraorder','Family','Distribution','Body mass male (Kg)'
with open('../sandbox/test.txt','r') as f:

    with open("test.csv", "r") as f:
        reader = csv.reader(f, delimiter="\t")
        
    for i, line in enumerate(reader):
        print('line[{}] = {}'.format(i, line))

# write a file containing only species name and Body mass
with open('../data/testcsv.csv','r') as f:
    with open('../data/bodymass.csv','w') as g:

        csvread = csv.reader(f)
        csvwrite = csv.writer(g)
        for row in csvread:
            print(row)
            csvwrite.writerow([row[0], row[4]])