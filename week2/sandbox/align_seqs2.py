f = open('../sandbox/test.txt','r') 
lines = f.readlines()
items = []
for i in lines:
    items.append(i.strip())
print(items)

# Two example sequences to match
seq2 = items[0]
seq1 = items[1]

# Assign the longer sequence s1, and the shorter to s2
# l1 is length of the longest, l2 that of the shortest

l1 = len(seq1) #len() gives the length of both sequences respectively
l2 = len(seq2)
if l1 >= l2:  #if l1 is greater or equal to l2, seq1 and seq2 are equal to s1 and s2 respectively. 
    s1 = seq1
    s2 = seq2
else:
    s1 = seq2 #if l1 is less than l2, seq1 and se2 are equal to s2 and s1 respectively. 
    s2 = seq1 #so s1 is always has a higher number than s2. if seq1 and seq2 have swapped, l1 and l2 also have to so that they are assigned to the right sequences. 
    l1, l2 = l2, l1 # swap the two lengths assigned to l1 and l2. this whole bit is done to make sure that the longest sequence is always assigned to s1.

# A function that computes a score by returning the number of matches starting
# from arbitrary startpoint (chosen by user) - a random number chosen by the user
def calculate_score(s1, s2, l1, l2, startpoint): # needs (in order): the longer sequence, the shorter sequence, length of the longer sequence, the length of the shorter sequence, startpoint- which determines what base number on the sequence matching starts to occur.
    matched = "" # to hold string displaying alignements - so it can dusplay matches (*) and not matches (-) as they are processed.
    score = 0   #matches start at zero
    for i in range(l2): #for each base on the shortest sequence length. where i can be any bases on the seqence from 1 - max l2 length (eg.10). this changes the alignment of s2 on s1.
        if (i + startpoint) < l1: #if i + the startpoint is less than the longest sequence length (eg. 16), it will ocntinue to try and match bases across the current alignment. once reachinfg the end it will print off the stuff below and return to the line above.
            if s1[i + startpoint] == s2[i]: # if, the bases read on s1 match the bases read on s2.
                matched = matched + "*" #if the bases match an asterisk are added to 'match'
                score = score + 1  #1 is added to the score, as the fucntion loops over it will add up all the times the bases matched in one go. 
            else:
                matched = matched + "-" #if it doesnt match a dash is added to 'matched'

    # some formatted output
    print("." * startpoint + matched)  #dots are printed for the same number of times as the value of start point + i (eg. startpoint =5 + i = 3 >>> ........) then matched string is printed   
    print("." * startpoint + s2) #dots are printed as explained above, then sequence two is printed
    print(s1) #sequence 1 is printed, the asterisks from 'matched' and matching bases form seq1 and seq2 should align.
    print(score) #prints how many times the bases matched betwen s1 and s2.
    print(" ")

    return score #once done, seq2 will move once space across seq 1 to be compared again and again until it reaches the end of sequence 1 (line 23) 

# Test the function with some example starting points:
# calculate_score(s1, s2, l1, l2, 0)
# calculate_score(s1, s2, l1, l2, 1)
# calculate_score(s1, s2, l1, l2, 5)

# now try to find the best match (highest score) for the two sequences
my_best_align = None  #assign it nothing for the moment
my_best_score = -1   

for i in range(l1): # Note that you just take the last alignment with the highest score. for i in the length of sequence 1
    z = calculate_score(s1, s2, l1, l2, i) #each score from each alignment the abpve function is now refered to as z.
    if z > my_best_score: #if z is greater than my best score,
        my_best_align = "." * i + s2 # think about what this is doing! "." * i prints out dots equal to the number of i with the best score. then the sequence of s2 is added after it. this is so seq 1 and se2 will b printed out togetehr at their best alignment
        my_best_score = z #it assigns z as the new best score
print(my_best_align)
print(s1)
print("Best score:", my_best_score)

