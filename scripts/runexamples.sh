#!/bin/sh


echo "Testing all the files"

for f in $1/*.lfr;

do 
	echo "Running File $f";
    python ../lfr/cmdline.py --no-gen --outpath ../out/ $f
done  