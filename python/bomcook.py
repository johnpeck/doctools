# bomcook.py
# Processes Orcad's BOM output to be compliant with Judy's asp script
import os

# Import the bill of materials (bom) file created as such:
# Combined property string:
# {Reference}\t{Quantity}\t{Value}\t{Part number\t{Manufacturer}\t{Manufacturer part}
# Header line doesn't matter.
# Make sure "each part on a separate line" is checked
bomname = "../schematics/judybom.bom"

# The name of the output bom
outbom = "../schematics/ec100_int_i2v_revc.bom"

delim = '\t'


# Take a list and make a delimited string out of it
def makedlm(listin,delim):
        outstr = ''
        count = 0
        for entry in listin:
                if count != 0:
                        outstr = outstr + delim + entry
                else:
                        outstr = entry
                count += 1
        return outstr


def headstrip(bomname,outbom):
        fbm = open(bomname,'r')
        rawbom = fbm.read()
        fbo = open(outbom,'w')
        count = 0
        foundref = False
        for line in rawbom.split('\n'):
                fields = line.split('\t')
                if fields[0] == 'Reference':
                        fbo.write(makedlm(fields,delim) + '\n')
                        count = 0
                        foundref = True
                if foundref and (count >= 3) and fields[0] != '': 
                        fbo.write(makedlm(fields,delim) + '\n')
                count += 1
        print('Stripped header junk from ' + bomname)

# Switch columns 1 and 0
def switchcol(outbom):
        fbi = open(outbom,'r')
        rawbom = fbi.read()
        fbi.close()
        fbo = open(outbom,'w')
        for line in rawbom.split('\n'):
                fields = line.split('\t')
                if len(fields) > 1:
                        tempfield = fields[0]
                        fields[0] = fields[1]
                        fields[1] = tempfield
                        fbo.write(makedlm(fields,delim) + '\n')
        print('Exchanged refdes and quantity columns')

# Add item column
def additem(outbom):
        fbi = open(outbom,'r')
        rawbom = fbi.read()
        fbi.close()
        fbo = open(outbom,'w')
        count = 0
        for line in rawbom.split('\n'):
                fields = line.split('\t')
                if count == 0:
                        fields.insert(0,'Item')
                        fbo.write(makedlm(fields,delim) + '\n')
                if count !=0 and len(fields) > 1:
                        fields.insert(0,str(count))
                        fbo.write(makedlm(fields,delim) + '\n')
                count += 1
        print('Added an item column')

#Add "any" to the manufacturer cols, "unknown" to manufacturer pn
def junkfill(outbom):
        fbi = open(outbom,'r')
        rawbom = fbi.read()
        fbi.close()
        fbo = open(outbom,'w')        
        for line in rawbom.split('\n'):
                fields = line.split('\t')
                if fields[0] != '':
                        while len(fields) < 7:
                                fields.append('')
                        if fields[5] == '':
                                fields[5] = ('any')
                        if fields[6] == '':
                                fields[6] = ('unknown')
                        fbo.write(makedlm(fields,delim) + '\n')
        print('Filled in empty Manufacturer and Manufacturer part entries')

#Add quotes to entries in columns 2-6
def addquotes(outbom):
        fbi = open(outbom,'r')
        rawbom = fbi.read()
        fbi.close()
        fbo = open(outbom,'w')
        count = 0
        for line in rawbom.split('\n'):
                fields = line.split('\t')
                if fields[0] != '':
                        if count == 0:
                                for index, header in enumerate(fields):
                                        fields[index] = ('"' + header + '"')
                        else:
                                incount = 0
                                for index, entry in enumerate(fields):
                                        if incount > 1:
                                                fields[index] = ('"' + entry + '"')
                                        incount += 1
                        count += 1
                        fbo.write(makedlm(fields,delim) + '\n')
        print('Added double quotes to entries in cols 2-6')
                                        


#Convert to comma delimiting
def commadlm(outbom):
        fbi = open(outbom,'r')
        rawbom = fbi.read()
        fbi.close()
        fbo = open(outbom,'w')
        for line in rawbom.split('\n'):
                fields = line.split('\t')
                if fields[0] != '':
                        fbo.write(makedlm(fields,',') + '\n')
        print('Converted to comma delimiting')

#Rename file
def csvname(outbom):
        nameparts = outbom.split('.')
        newname = '..' + nameparts[2] + '.csv'
        if not os.path.exists(newname):
                os.rename(outbom,newname)
        else:
                os.remove(newname)
                os.rename(outbom,newname)
        print('Saved file as ' + newname)
       

                                
                        



                        
        

        

def main():
        headstrip(bomname,outbom) #Strip out Orcad's header spaces
        switchcol(outbom) #Exchange quantity and refdes columns
        additem(outbom) #Add a number to the item column
        junkfill(outbom) #Fill in manufact and man part columns
        addquotes(outbom) #Add double quotes around cols 2-6
        commadlm(outbom) #Make a comma delimited file
        csvname(outbom) #Rename the file
        



	
