# Replication Project
This project is a replication of Figures 1 and 2 from Cruces et al.'s (2023) ["Dishonesty and Public Employment"](https://www.aeaweb.org/articles?id=10.1257/aeri.20220550) paper in AEA: Insights.The data and STATA code are made publicly available by the authors through [openICPSR](https://www.openicpsr.org/openicpsr/project/185801/version/V1/view). 

My replication in R uses the tidyverse, dplyr, haven, binsreg, and cowplot packages. 

## Premise 
Using data of Argentine men born between 1958 and 1962, Cruces et al. propose a causal relationship between dishonesty measured through
failure rate a of a medical exam determining military conscription, and future public employment. Ordinary least squares and 2-stage least-squares regression analysis, with distance to a randomized cutoff as an instrumental variable, are used to estimate this relationship[^1]. Men above the randomized cutoff were conscripted, men below the cutoff were exempt, but failing the medical exam could exempt anyone. The conscription cutoff varies from year-to-year and is not publicly known, though an rough inference can be made from previous years' cutoffs. 

Figure 1 demonstrates the relationship between the instrument and the explanatory variable, and Figure 2 demonstrates the relationship between the instrument and the dependent variable (reduced-form regression). 
[^1]: Please refer to the original paper for a more complete explanation of the experiment. 

## Explanation of variables 
| Variable name      | Description |
| ----------- | ----------- |
| *attriter*      | Equal to 1 if non-citizen.       |
| *cond_easy100*, *cond_hard100*, *cond_inter100*   | Equal to 1 if method used to cheat on medical exam was easy, hard, or moderately difficult to detect and/or carry out.        |
| *dairforce*, *dcohort*   | Control variables for birth cohorts and air force participation.        |
| *distancecutoff_norm*   | Normalized distance to cutoff for military conscription.       | 
| *empl_public*, *empl_private*   | Equal to 1 if person is either publicly or privately employed.        |
| *failed_exam100*   | Equal to 1 if person failed the medical exam.       |

