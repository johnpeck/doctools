"""Test counting parts from output of bom2"""

"""The input bom file"""
fbm = open('gnet_bom2_out.bom','r')

"""The input Digi-Key parts file"""
fdk = open('jrrparts/digikey.dat','r')

"""The output file"""
fout = open('gnet_bom2_qty.bom','w')

"""Read every line of the input files"""
rawbm = fbm.read()
rawdk = fdk.read()

"""Make an empty dictionary"""
cnt = {}
parts = {}

#Split the raw data up based on newline character
#Skip the header by starting at row 1
for line in rawbm.split("\n")[1:-1]:
	#Split individual lines up based on colon
	if line != '':
		fields = line.split(":")
		#fields[3] is the JRR part number.
		cnt[fields[3]] = len(fields[0].split(","))

# Read in the digikey part number file
for line in rawdk.split("\n"):
	if line != '':
		fields = line.split()
		parts[fields[0]] = fields[1]
	
for i in cnt:
	if i in parts:
		fout.write("%s \t %s \t" %(i, cnt[i]))
		fout.write(parts[i] + "\n")
	else:
		fout.write("%s \t %s \n" %(i, cnt[i]))
