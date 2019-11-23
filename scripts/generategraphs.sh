#!/bin/sh


echo "Converting all the dot files to ps"

for f in ../*.dot;

do 
	echo "Running File $f";
    dot -T ps $f -o $f.ps
done