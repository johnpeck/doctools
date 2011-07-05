# Import a bom file from orcad and output a bom of pick and placeable parts
# pickbomgen
# Create a bill of materials for the pick and place machine given a
# complete bill of materials, a disqualified parts list, and the maximum
# number of parts able to be placed on the machine.
#
# Also takes in a file containing current pick and place parts to see which
# parts need to be added.
import os

# Import the bill of materials (bom) file created as such:
# Combined property string:
# {Reference}\t{Quantity}\t{Value}\t{Part number\t{Manufacturer}\t{Manufacturer part}
# Header line doesn't matter.
# Make sure "each part on a separate line" is checked
bomname = "judybom.bom"

# Parts not eligible for the pick and place
disfile = "noplace.dat"

# The file srsparts.dat maps part numbers to plain text descriptions
partfile = "srsparts.dat"

# Parts already defined for the pick and place
stockfile = 'PnP_Database_index.txt'

# File to write the pick and place bom to.  This bom will be formatted as:
# Refdes <tab> srspart
placefile = "pickplace.bom"

# File to write parts to that need to be added to database
toaddfile = 'toadd.dat'

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
# Usage: ispn(<string to test>)
# Returns: True (for a good part) or False
# Example:
# ispn('5-00764-581') returns True
# ispn('5-00764') returns True
# ispn('5-764') returns True
def ispn(testpn):
    hasdash = '-' in testpn # Contains at least one dash
    firstok = len(testpn.split('-')[0]) == 1 #Only one first digit
    return hasdash and firstok

# iscom -- Check to see if a line is commented out
# Usage: iscom(<complete line from a file>)
# Returns: True (for a line beginning with #) or False
# Example:
# iscom('#Some comment') returns True
def iscom(line):
    return line.startswith('#')

# delbom -- Remove the previous bom output if it exists
# Usage: delbom(placefile)
def delbom(placefile):
        if os.path.isfile(placefile):
                os.remove(placefile)
                print('Removing existing ' + placefile)
        else:
                print('No previous ' + placefile + ' exists')

# getstock -- Read in a list of existing pick and place parts
# Returns a dictionary of parts and their descriptions
def getstock(stockfile):
    fgs = open(stockfile,'r')
    rawstock = fgs.read()
    stock = {}
    for line in rawstock.split('\n'):
        if line != '':
            fields = line.split('\t')
            if ispn(fields[0]):
                stock[fields[0]] = fields[1]
    return stock

            

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
        

#make a dictionary to hold part number and quantity
#qty will hold part:qty
fbm = open(bomname,'r')
rawbom = fbm.read()
qty = {}
totalnum = 0
for line in rawbom.split("\n"):
        if line != '':
                fields = line.split("\t")
                if (len(fields) == 6 and ispn(fields[3])):
                        srspn = pntrunc(fields[3])
                        totalnum += 1
                        if srspn in qty:
                                qty[srspn] += 1
                        else:
                                qty[srspn] = 1

#Make a list of disqualified parts
fdq = open(disfile,'r')
rawdq = fdq.read()
dqparts = []
for line in rawdq.split("\n"):
    if line != '' and not iscom(line):
        fields = line.split()
        srspn = pntrunc(fields[0])
        dqparts.append(srspn)



#Sort the parts by frequency in descending order
qtylist = sorted(qty,key=lambda x: qty[x], reverse=True)

# Remove disqualified parts from the ordered list
placelist = []
for part in qtylist:
    if part not in dqparts:
        placelist.append(part)
print('I can place ' + str(len(placelist)) + ' parts out of ' +
      str(len(qty)) + '.')




# Write a file of srspn <tab> quantity for pick and place parts
delbom(placefile)
fpp = open(placefile,'w')
fpp.write('# List of machine placeable parts \n' +
          '# SRS part number <tab> Quantity \n')
if len(placelist) > maxparts:
    print('Placeable parts exceeds maxparts (' + str(maxparts) + ')')
    maxlist = placelist[0:maxparts]
else:
    maxlist = placelist


for part in maxlist:
        fpp.write(part + '\t' + str(qty[part]) + '\n')
fpp.close()
print(str(len(maxlist)) + ' machine placeable parts written ' +
      'to ' + placefile)

# Identify parts with various packages
packages = ['so-16','so-14','so-8','0603','1206','2512','1210',
            'sot-223','sot23-3','unknown']
packdict = {}
for package in packages:
        packdict[package] = []


for part in maxlist:
        found = 0
        for package in packages[0:-1]:
                if package in desc[part]:
                        packdict[package].append(part)
                        found = 1
        if found == 0:
                packdict['unknown'].append(part)


                

                





# Figure out if the parts in placelist are in the database
stock = getstock(stockfile)
toadd = []
delbom(toaddfile)
tap = open(toaddfile,'w')
tap.write('# Parts not found in pick and place database \n' +
          '# SRS part number <tab> Description \n\n')
for package in packages:
        tap.write('\n# ' + package + ' package\n')
        for part in maxlist:
                if part not in stock and part in packdict[package]:
                        toadd.append(part)
                        if part in desc: 
                                tap.write(part + '\t' + desc[part] + '\n')
                        else:
                                tap.write(part + '\n')

            
tap.close()
print(str(len(toadd)) + ' parts not in database written to toadd.dat')
