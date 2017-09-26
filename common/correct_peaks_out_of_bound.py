#!/usr/bin/env python

import os,sys
out = open("000_"+sys.argv[2],"w")

with open(sys.argv[1],"r") as f:
	for line in f:
		f = line.strip().split("\t")
		#the end coordinates must match
		if( int(f[7]) != int(f[2]) ):
			f[7] = f[2]
			diff = int(f[2])-int(f[1])-1
			block = f[11].split(",")
			block[-1]=str(diff)
			f[11] = ",".join(block)
			out.write("\t".join(f))
			out.write("\n")
		else:
			out.write(line)

out.close()
