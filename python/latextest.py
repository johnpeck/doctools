"""Test creating latex input"""

f = open('latexout.tex','w')
"""number of positions per row"""
positions = 24
"""width of the positions in mm"""
width = 5 

"""The text to put into the vfd"""
vfdtext = 'Some text'

f.write(r'\begin{center}' + '\n')
f.write(r'\setlength{\unitlength}{1mm}' + '\n')
f.write(r'\begin{picture}(' + str(positions * width) + ',10)' + '\n')
for index in range(0, len(vfdtext)):
    f.write(r'\put(' + str(index * 5) +
            r',1){\framebox(5,5)[c]{' + vfdtext[index] + '}}\n')
for index in range(len(vfdtext), 24):
	f.write(r'\put(' + str(index * 5) +
			r',1){\framebox(5,5)[c]{}}' + '\n')
f.write(r'\end{picture}' + '\n')
f.write(r'\end{center}' + '\n')
f.close()
