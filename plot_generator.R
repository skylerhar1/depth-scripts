#LOAD IN THE LIBRARIES
#library(reshape) # to rename columns
library(data.table) # to make sliding window dataframe
library(zoo) # to apply rolling function for sliding window
library(dplyr)
library(ggplot2)
#READ IN ISLAND INFO
ii_info <- read.table(file = "ii_info.txt", header = F, sep = "\t")
colnames(ii_info) <- c("Isolate","Island")
#READ IN THE DATA
filename <- "B_127_con_L1_1.fq.gz_depth_depth.table"
depth_table <- read.table(file=filename, header = T, sep = "\t")
colnames(depth_table) <- c("CHROM","POS","DEPTH")
split_name<-strsplit(filename,split = "_")
#take the first two string chinks and uses that as the ID
iso_id<-gsub(" ","",paste(split_name[[1]][1],"_",split_name[[1]][2]))
#USES THE ID TO INFER ISLAND
island <- ii_info$Island[which(ii_info$Isolate == iso_id)]
#REFLOW THE POSITION TO BE CONTINUOUS
num_rows <- nrow(depth_table)
depth_table$POS <- 1:num_rows
head(depth_table)
#GENOME COVERAGE AS A SLIDING WINDOW
depth.average<-setDT(depth_table)[, .(
  window.start = rollapply(POS, width=10000, by=1000, FUN=min, align="left", partial=TRUE),
  window.end = rollapply(POS, width=10000, by=1000, FUN=max, align="left", partial=TRUE),
  coverage = rollapply(DEPTH, width=10000, by=1000, FUN=mean, align="left", partial=TRUE)
), .(CHROM)]
head(depth.average)
tail(depth.average)
#PLOT THE DATA
depth.average.plot <- ggplot(depth.average, aes(x=window.end, y=coverage, colour=CHROM)) + 
  geom_point(shape = 20, size = 0.7, colour=depth.average$CHROM) +
  geom_line(colour=depth.average$CHROM, size = 0.1)+
  scale_x_continuous(name="Genomic Position (bp)", limits=c(0,num_rows ),labels = scales::comma,breaks = scales::pretty_breaks(n = 20)) +
  scale_y_continuous(name="Average Coverage Depth", limits=c(0,350))+
  ggtitle(iso_id, subtitle = island)
plot_name <- gsub(" ","",paste("png_directory/",iso_id,"flagged.png"))
ggsave(plot_name, width = 18000, height = 900, units = "px",limitsize = FALSE)
