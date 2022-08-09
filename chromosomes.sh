#!/bin/bash


for file in *.txt; do
	echo -e "CHROM	POS	DEPTH" > ${file::-4}_depth.table
	cat $file | \
	sed -r 's/PGA_scaffold1__56_contigs__length_3729814/1/' | \
	sed -r 's/PGA_scaffold2__144_contigs__length_3979939/2/' | \
	sed -r 's/PGA_scaffold3__62_contigs__length_3192218/3/' | \
	sed -r 's/PGA_scaffold4__57_contigs__length_2565902/4/' | \
	sed -r 's/PGA_scaffold5__75_contigs__length_2711963/5/' | \
	sed -r 's/PGA_scaffold6__60_contigs__length_2620934/6/' | \
	sed -r 's/PGA_scaffold7__74_contigs__length_2332212/7/' | \
	sed -r 's/PGA_scaffold8__44_contigs__length_2425279/8/' | \
	sed -r 's/PGA_scaffold9__67_contigs__length_2336877/9/' | \
	sed -r 's/PGA_scaffold10__58_contigs__length_2235715/10/' | \
	sed -r 's/PGA_scaffold11__54_contigs__length_1992196/11/'  >> ${file::-4}_depth.table
done
