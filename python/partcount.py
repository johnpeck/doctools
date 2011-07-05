import os

# Import the bill of materials (bom) file created as such:
# Combined property string:
# {Reference}\t{Quantity}\t{Value}\t{Part number\t{Manufacturer}\t{Manufacturer part}
# Header line doesn't matter.
# Make sure "each part on a separate line" is checked
bomname = "../schematics/judybom.bom"

# The file srsparts.dat maps part numbers to plain text descriptions
partfile = "srsparts.dat"

#Parts not eligible for the pick and place
disfile = "noplace.dat"

#Number of part reels on the machine.  15 reels x 8 parts = 120
maxparts = 120

# pntrunc -- Truncate part numbers to get rid of the suffix
# Usage: pntrunc(<full srs part number>)
# Returns: Truncated part number as a string
# Example:
# pntrunc('5-00764-581') returns '5-00764'
def pntrunc(fullpn):
	pnsplit = fullpn.split('-')
	spn = pnsplit[0] + '-' + pnsplit[1]
	return spn

# ispn -- Check to see if this is a valid srs part number
# Usage: ispn(<full srs part number>)
# Returns: True (for a good part) or False
# Example:
# ispn('5-00764-581') returns True
def ispn(fullpn):
        return len(fullpn.split('-')) == 3

# iscom -- Check to see if a line is commented out
# Usage: iscom(<complete line from a file>)
# Returns: True (for a line beginning with #) or False
# Example:
# iscom('#Some comment') returns True
def iscom(line):
        return line.startswith('#')


        

#Make a dictionary of descriptions
fpf = open(partfile,'r')
rawpf = fpf.read()
desc = {}
for line in rawpf.split("\n"):
    if line != '' and not iscom(line):
        fields = line.split()
        srspn = pntrunc(fields[0])
        blurb = fields[1]
        if len(fields) >= 3:
            for item in fields[2:]:
                blurb += ' ' + item
        desc[srspn] = blurb

#Make a list of disqualified parts
fdq = open(disfile,'r')
rawdq = fdq.read()
dqparts = []
for line in rawdq.split("\n"):
    if line != '' and not iscom(line):
        fields = line.split()
        srspn = pntrunc(fields[0])
        dqparts.append(srspn)


#make a dictionary to hold part number and quantity
#qty will hold part:qty
fbm = open(bomname,'r')
rawbom = fbm.read()
qty = {}
totalnum = 0
for line in rawbom.split('\n'):
        if line != '':
                fields = line.split('\t')
                if (len(fields) == 6 and ispn(fields[3])):
                        srspn = pntrunc(fields[3])
                        totalnum += 1
                        if srspn in qty:
                                qty[srspn] += 1
                        else:
                                qty[srspn] = 1
                else:
                        print('Skipping line --> ' +
                              str(fields[0]))


#Sort the parts by frequency in descending order
qtylist = sorted(qty,key=lambda x: qty[x], reverse=True)





#Now qty is a dictionary of srs part numbers and their quantities
print('\n' + "There are " + str(totalnum) + " total parts, with " +
      str(len(qty)) + " unique")


# Start the list of most-used parts, with parts disqualified for
# pick and place enclosed in parenthesis
print('Machine-placeable parts ranked by frequency:')
count = 0
for part in qtylist:
        if part not in dqparts:
            count += 1
            if count > maxparts and count < (maxparts + 2):
                print('--------------------------------------------------')
            if part in desc:
                print(str(count) + ": " + str(qty[part]) +
                    " " + desc[part] + "s")
            else:
                print(str(count) + ": " + str(qty[part]) + " " + part)
        else:
            if part in desc:
                print("(" + str(qty[part]) + " " +
                    desc[part] + "s)")
            else:
                print("(" + str(qty[part]) + " " + part)
#fpk.close()
        

                


