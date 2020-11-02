#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

library(ggplot2)

output_file_name<-args[2]
plot_title <-args[3]

agtest<-read.table(args[1], header = TRUE, sep = " ")

T<-ggplot() +
  geom_line(data = agtest, aes(x = AA , y = Ag, group = Species, colour=Species)) + 
  theme_bw() + 
  theme(plot.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank() ) +
  theme(panel.border= element_blank()) +
  theme(axis.line.x = element_line(color="black", size = 0.5),
        axis.line.y = element_line(color="black", size = 0.5)) +  geom_hline(yintercept = 0.35, size=0.2) + labs(title=plot_title) + theme(legend.key = element_blank()) + theme(legend.title=element_blank())
T

ggsave(output_file_name, device = "png", width = 20, height = 10, units = "cm")






