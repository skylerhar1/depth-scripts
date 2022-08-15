#!/bin/bash
for file in *depth.table
do
	echo "Rscript plot_generator.R $file ii_info.txt"

done
