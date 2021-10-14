import csv

#Read a file containing:
#'Species', 'Infraorder','Family,'Distribution','Body mass male (Kg)'
with open('../data/testcsv.csv', 'r') as f:

#csv.reader() enables the script to read the .csv file, [] means everything within the rows.
    csvread = csv.reader(f)
    temp = []
    for row in csvread: #applies changes to the rows in the file (now named csvread)
        temp.append(tuple(row))  
        
        #linked everything in each row together, so tupples the specie name 
        #with its common game, Infraorder, body etc
        
        print(row)
        #prints 'the species is' before row [0], which is the tupple containing the species name
        print("The species is", row[0])

    
    #write a file containing only species name and Body mass, 
with open('../data/testcsv.csv', 'r') as f:
    with open('../data/bodymass.csv', 'w') as g:

        csvread = csv.reader(f)
        #need to read the file so that we can extract/ copy some rows from it.
        csvwrite = csv.writer(g)
        #allows us to write/ manually edit the csv file
        for row in csvread:
            print(row)
            csvwrite.writerow([row[0], row[4]]) 
            #we are now writing into bodymass.csv from basic.csv 
            #the first tupple (species name) and the fourth (bodymass) from each row