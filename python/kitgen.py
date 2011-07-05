#kitgen.py
#Generate files that can be used to order parts for circuit boards.
#Uses the output from gnetlist's bom2 script
import os

#The output file from the bom2 script (with JRR part as third field)
#To generate, use:
#gnetlist -g bom2 <input.sch> -o <output.bom>
bomname = 'gnet_bom2_out.bom'

#The kit number (should just be an integer)
kitnum = 4

#The kit quantity (how many boards do you want to build)
kitqty = 5

#Vendor files
ven1 = 'jrrparts/digikey.dat'
ven2 = 'jrrparts/mcmaster.dat'
ven3 = 'jrrparts/newark.dat'

#make a directory to store the kit information
kitdir = "kit" + str(kitnum)
if (not os.access(kitdir,os.F_OK)):
	os.mkdir(kitdir)


sumfile = ("kit" + str(kitnum) + "_summary.dat")
fos = open(kitdir + "/" + sumfile,'w')
ven1out = ("kit" + str(kitnum) + "_" +
	ven1.split('/')[-1].split('.')[0] + ".dat")
fo1 = open(kitdir + "/" + ven1out,'w')
ven2out = ("kit" + str(kitnum) + "_" +
	ven2.split('/')[-1].split('.')[0] + ".dat")
fo2 = open(kitdir + "/" + ven2out,'w')
ven3out = ("kit" + str(kitnum) + "_" +
	ven3.split('/')[-1].split('.')[0] + ".dat")
fo3 = open(kitdir + "/" + ven3out,'w')


#Create a dictionary of JRR part:quantity
qty = {}
fbm = open(bomname,'r')
rawbom = fbm.read()
for line in rawbom.split("\n")[1:-1]:
	#Split individual lines up based on colon
	if line != '':
		fields = line.split(":")
		#fields[3] is the JRR part number.
		qty[fields[3]] = len(fields[0].split(","))
fbm.close()

#Create a dictionary of JRR part:vendor 1 part
v1d = {}
fv1 = open(ven1,'r')
rawv1 = fv1.read()
for line in rawv1.split("\n"):
	if line != '':
		fields = line.split()
		v1d[fields[0]] = fields[1]
fv1.close()


#Create a dictionary of JRR part:vendor 2 part
v2d = {}
fv2 = open(ven2,'r')
rawv2 = fv2.read()
for line in rawv2.split("\n"):
	if line != '':
		fields = line.split()
		v2d[fields[0]] = fields[1]
fv2.close()

#Create a dictionary of JRR part:vendor 3 part
v3d = {}
fv3 = open(ven3,'r')
rawv3 = fv3.read()
for line in rawv3.split("\n"):
	if line != '':
		fields = line.split()
		v3d[fields[0]] = fields[1]
fv3.close()


#Write the vendor 1 file
fo1.write("Part number" + "\t" + "Quantity" + "\n")
for part in qty:
	if part in v1d:
		fo1.write(str(v1d[part]) + "\t" +
			str(qty[part] * kitqty) + "\n")
fo1.close()

#Write the vendor 2 file
fo2.write("Part number" + "\t" + "Quantity" + "\n")
for part in qty:
	if part in v2d:
		fo2.write(str(v2d[part]) + "\t" +
			str(qty[part] * kitqty) + "\n")
fo2.close()

#Write the vendor 3 file
fo3.write("Part number" + "\t" + "Quantity" + "\n")
for part in qty:
	if part in v3d:
		fo3.write(str(v3d[part]) + "\t" +
			str(qty[part] * kitqty) + "\n")
fo3.close()

#Write the summary file
fos.write("JRR part" + "\t" + "Quantity" + "\t" + "Vendor" + "\n")
for part in qty:
	if part in v1d:
		fos.write(str(part) + "\t" + str(kitqty * qty[part]) + "\t" +
			"Digi-Key" + "\n")
	elif part in v2d:
		fos.write(str(part) + "\t" + str(kitqty * qty[part]) + "\t" +
			"McMaster" + "\n")
	elif part in v3d:
		fos.write(str(part) + "\t" + str(kitqty * qty[part]) + "\t" +
			"Newark" + "\n")		
	else:
		fos.write(str(part) + "\t" + str(kitqty * qty[part]) + "\t" +
			"None" + "\n")

