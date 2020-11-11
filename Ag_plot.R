#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

library(ggplot2)

output_file_name<-args[2]
plot_title <-args[3]

agtest<-read.csv(args[1], header = TRUE)

T<-ggplot() +
  geom_line(data = agtest, aes(x = AA , y = Ag, group = Sequence, colour=Sequence)) + 
  #facet_wrap(~Sequence)+ ####makes individual plots for each sequence
  theme_bw() + 
  theme(plot.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank() ) +
  theme(panel.border= element_blank()) +
  theme(axis.line.x = element_line(color="black", size = 0.5),
        axis.line.y = element_line(color="black", size = 0.5)) +  geom_hline(yintercept = 0.35, size=0.2) + labs(title=plot_title) + theme(legend.key = element_blank()) + theme(legend.title=element_blank())
T

ggsave(output_file_name, device = "png", width = 20, height = 10, units = "cm")






