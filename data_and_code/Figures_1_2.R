rm(list=ls())
gc()

#### Loading in useful things ####
packlist <- c("cowplot", "binsreg", "haven")
install.packages(packlist[!(packlist %in% installed.packages()[, 1])])

library(tidyverse)
library(ggplot2)
library(binsreg)

#### Load in data ####
#setwd("C:/Users/cxiex/Downloads/ECON 140/185801-V1/data_directory")
df <- haven::read_dta("FINAL_REPOSITORY_MAIN_FEB2023.dta")

#### Filtering values ####
citizens <- filter(df, attriter==0) #drop non-citizens

inclusive <- filter(citizens, distancecutoff_norm<=0) #n = 295611
# inclusive_b <- filter(citizens, draft_exempt==1) #n = 295611
noninclusive <- filter(citizens, distancecutoff_norm<0) #n = 294619

#### Figure 1 ####
df_fig1 <- select(citizens, distancecutoff_norm, failed_exam100, cond_easy100, 
                  cond_inter100, cond_hard100, contains("dcohort"), dairforce)

#create long data to plot all levels on single graph
long_data <- df_fig1 %>%
  pivot_longer(
    cols = c(cond_easy100, cond_inter100, cond_hard100, failed_exam100), 
    names_to = "type", 
    values_to = "y_var"
  ) %>% 
  mutate(type = case_when(type == "cond_easy100" ~ "Easy-to-cheat-conditions", 
                          type == "cond_inter100" ~ "Intermediate conditions", 
                          type == "cond_hard100" ~ "Hard-to-cheat conditions", 
                          type == "failed_exam100" ~ "All conditions")) %>%
  mutate(type = factor(type, levels = c("All conditions", "Easy-to-cheat-conditions", 
                       "Intermediate conditions", "Hard-to-cheat conditions")))

dcohort <- select(citizens, contains("dcohort"), dairforce)
dcohort_ctrl1 <- do.call(rbind, replicate(4, dcohort, simplify = F))

binsreg(long_data$y_var, 
        long_data$distancecutoff_norm, 
        dcohort_ctrl1, 
        by = long_data$type,
        nbins = 40, 
        plotyrange=c(-1, 17), 
        legendTitle = "", 
        bycolors = list("gray12", "royalblue4", "red3", "green4"), 
        bysymbols = list(15, 16, 17, 18))$bins_plot + #extract binsreg output as ggplot object
  geom_vline(xintercept = 0, linetype = "dashed") + 
  xlab("Normalized difference bewteen draft lottery number and cutoff") + 
  ylab("Failure rate in medical examination (percent)") + 
  ggtitle("Figure 1. Failure rate in medical examination as a function of draft lottery number") + 
  theme(plot.title = element_text(size = 10), 
        axis.title.x = element_text(size = 9), 
        axis.title.y = element_text(size = 9))

rm(df_fig1, long_data, dcohort, dcohort_ctrl1) 
gc()

#### Figure 2 ####
df_fig2 <- select(noninclusive, empl_public100, empl_private100, distancecutoff_norm, contains("dcohort"))
# the authors chose the non-inclusive data for this figure

dcohort_ctrl2 <- select(df_fig2, contains("dcohort"))

left <- binsreg(df_fig2$empl_public100,
                df_fig2$distancecutoff_norm, 
                dcohort_ctrl2,
                nbins = 12, 
                plotyrange=c(16, 17), 
                bycolors = "royalblue")$bins_plot + 
  xlab("Normalized difference bewteen \n draft lottery number and cutoff") + 
  ylab("Public sector employment (percent)") +
  ggtitle("Panel A. Public employment") + 
  theme(plot.title=element_text(size = 11))

right <- binsreg(df_fig2$empl_private100,
                 df_fig2$distancecutoff_norm,
                 dcohort_ctrl2,
                 nbins = 12, 
                 plotyrange=c(36.23, 37.75), 
                 bycolors = "royalblue")$bins_plot + 
  xlab("Normalized difference bewteen \n draft lottery number and cutoff") + 
  ylab("Private sector employment (percent)") + 
  ggtitle("Panel B. Private employment") + 
  theme(plot.title=element_text(size = 11))

cowplot::plot_grid(left, right)


