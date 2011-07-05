# misspick.py
# Generates a list of parts scheduled for pick and place not currently
# in the SRS pick and place database.  Arranges them by package.
import os

# Import the bill of materials (bom) file created as such:
# Combined property string:
# {Reference}\t{Quantity}\t{Value}\t{Part number\t{Manufacturer}\t{Manufacturer part}
# Header line doesn't matter.
# Make sure "each part on a separate line" is checked
bomfile = 'judybom.bom'

# Parts not eligible for the pick and place
dqfile = "noplace.dat"

# The file srsparts.dat maps part numbers to plain text descriptions
descfile = "srsparts.dat"

# Parts already defined for the pick and place
stockfile = 'files.txt'

# Output file of parts needed to add to database
outfile = 'needed.dat'

# Maximum number of parts available
maxparts = 1000

packages = ['so-16','so-14','so-8','0603','1206','2512','1210',
            'sot-223','sot23-3','unknown']

# iscom -- Check to see if a line is commented out
# Usage: <boo> = iscom(<complete line from a file>)
# Example:
# iscom('#Some comment') returns True
def iscom(line):
    return line.startswith('#')


# blankfile -- Remove the file if it exists
# Usage: blankfile(filename)
def blankfile(filename):
        if os.path.isfile(filename):
                os.remove(filename)
                print('Removing existing ' + filename)
        else:
                print('No previous ' + filename + ' exists')

# ispn -- Check to see if this is a valid srs part number
# Usage: <boo> = ispn(<string to test>)
# Example:
# ispn('5-00764-581') returns True
# ispn('5-00764') returns True
# ispn('5-764') returns True
def ispn(testpn):
    hasdash = '-' in testpn # Contains at least one dash
    firstok = len(testpn.split('-')[0]) == 1 #Only one first digit
    return hasdash and firstok


# pntrunc -- Truncate part numbers to get rid of the suffix
# Usage: <truncated pn> = pntrunc(<full srs part number>)
# Returns: Truncated part number as a string
# Example:
# pntrunc('5-00764-581') returns '5-00764'
# pntrunc('5-00764') returns '5-00764'
def pntrunc(fullpn):
    if len(fullpn) == 7:
        spn = fullpn
    elif len(fullpn) == 11:
        pnsplit = fullpn.split('-')
        spn = pnsplit[0] + '-' + pnsplit[1]
    else:
        print('Part ' + str(fullpn) + ' is a bad part number.')
        spn = 0
    return spn

# getdq -- Get a list of disqualified part numbers
# Usage: <list> = getdq(<path to disqualified part list>)
def getdq(dqfile):
    fdq = open(dqfile,'r')
    rawdq = fdq.read()
    dqparts = []
    for line in rawdq.split("\n"):
        if line != '' and not iscom(line):
            fields = line.split()
            srspn = pntrunc(fields[0])
            dqparts.append(srspn)
    return dqparts

# getdesc -- Get a list of part number descriptions
# Usage: <dict> = getdesc(<path to description file>)
def getdesc(descfile):
    fdc = open(descfile,'r')
    rawdc = fdc.read()
    desc = {}
    for line in rawdc.split('\n'):
        if line != '' and not iscom(line):
            fields = line.split()
            srspn = pntrunc(fields[0])
            blurb = fields[1]
            if len(fields) >= 3:
                for item in fields[2:]:
                    blurb += ' ' + item
            desc[srspn] = blurb
    print(str(len(desc)) + ' part descriptions read in from ' +
          descfile)
    return desc

# getstock -- Read in a list of existing pick and place parts
# Returns a dictionary of parts and their descriptions
def getstock(stockfile):
    fgs = open(stockfile,'r')
    rawstock = fgs.read()
    stock = {}
    for line in rawstock.split('\n'):
        if line != '' and not iscom(line):
            fields = line.split()
            srspn = pntrunc(fields[0])
            blurb = fields[1]
            if len(fields) >= 3:
                for item in fields[2:]:
                    blurb += ' ' + item
            stock[srspn] = blurb
    print(str(len(stock)) + ' parts read from ' + stockfile)
    return stock

# orcadqty -- Get part usage frequencies from orcad bom file
# Usage: <dict of SRSpn:quantity> = orcadqty(<path to bom>)
def orcadqty(bomfile):
    fbm = open(bomfile,'r')
    rawbom = fbm.read()
    bomqty = {}
    for line in rawbom.split('\n'):
        if line != '':
            fields = line.split('\t')
            if (len(fields) == 6 and ispn(fields[3])):
                srspn = pntrunc(fields[3])
                if srspn in bomqty:
                    bomqty[srspn] += 1
                else:
                    bomqty[srspn] = 1
    return bomqty


# purgedq -- Remove part number keys disqualified for pick place
# Usage: <dict> = purgedq(<original dict>,<list of disqualified parts>)
def purgedq(bomqty,dqparts):
    allkeys = bomqty.keys()
    for part in allkeys:
        if part in dqparts:
            dummy = bomqty.pop(part)
    return bomqty

# rankparts -- Return a list of maxparts or less most numerous parts
# Usage: <list> = rankparts(<maxparts>,<dict of part:quantity>)
def rankparts(maxparts,bomqty):
    freqlist = sorted(bomqty,key=lambda x: bomqty[x], reverse=True)
    freqlist = freqlist[0:maxparts]
    return freqlist

# packsort -- create a dictionary of package:srspn
# Usage: <dict> = packsort(<dict of descriptions>,<list of parts>,
#                           <list of packages>)
def packsort(desc,picklist,packages):
    packdict = {}
    for package in packages:
        packdict[package] = []
    for part in picklist:
        found = 0
        for package in packages[0:-1]:
            if package in desc[part]:
                packdict[package].append(part)
                found = 1
        if found == 0:
            packdict['unknown'].append(part)
    return packdict




# report -- Dump a file of parts not in the database organized by package
# Usage: report(<file of srs part descriptions,output file,
#               list of stock pick and place parts,
#               list of this board's pick and place parts,
#               package dictionary>)
def report(desc,outfile,stockfile,picklist,packdict):
    stock = getstock(stockfile)
    toadd = []
    blankfile(outfile)
    fot = open(outfile,'w')
    fot.write('# Parts not found in pick and place database \n' +
              '# SRS part number <tab> Description \n\n')
    for package in packdict:
        fot.write('\n# ' + package + ' package\n')
        for part in picklist:
            if part not in stock and part in packdict[package]:
                toadd.append(part)
                if part in desc:
                    fot.write(part + '\t' + desc[part] + '\n')
                else:
                    fot.write(part + '\n')
    fot.close()
    print(str(len(toadd)) + ' parts not in database written to ' +
          outfile)
            
    


def main():
    bomqty = orcadqty(bomfile) #Read in bom file generated by Orcad
    desc = getdesc(descfile) #Get part descriptions
    dqparts = getdq(dqfile) # Get disqualified parts
    qualqty = purgedq(bomqty,dqparts) #Remove disqualified keys
    picklist = rankparts(maxparts,qualqty) #Most numerous parts
    packdict = packsort(desc,picklist,packages) #Organize parts by package
    report(desc,outfile,stockfile,picklist,packdict) #Report the missing parts


