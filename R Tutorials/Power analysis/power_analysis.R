# Power analysis using R
# Chengjun wang
# 2013 Oct 12

library(pwr)
library(semTools)

"3-group between subject design, 
and I want to be conservative so use the smallest effect size (.1 or .15). 
And the power is .8 and alpha is .005 as you alreadyknow. 
In my impression, it should be around 250 participants in total (70 per group) "


pwr.t.test(d=0.15, power = 0.8,  sig.level=0.05,
           type="paired",alternative="two.sided")


"n  Number of observations (per sample)
d	Effect size
sig.level	Significance level (Type I error probability)
power	Power of test (1 minus Type II error probability)"

# Paired t test power calculation 
# 
# n = 350.7638
# d = 0.15
# sig.level = 0.05
# power = 0.8
# alternative = two.sided
# 
# NOTE: n is number of *pairs*
  
pwr.anova.test(k = 3, n = NULL, f = 0.2, 
               sig.level = 0.05, power = 0.8)

"k Number of groups
n Number of observations (per group)
f Effect size
sig.level Signiﬁcance level (Type I error probability)
power Power of test (1 minus Type II error probability)"

# Balanced one-way analysis of variance power calculation 
# 
# k = 3
# n = 143.7394
# f = 0.15
# sig.level = 0.05
# power = 0.8
# 
# NOTE: n is number in each group


# Balanced one-way analysis of variance power calculation 
# 
# k = 3
# n = 81.29601
# f = 0.2
# sig.level = 0.05
# power = 0.8
# 
# NOTE: n is number in each group

# Balanced one-way analysis of variance power calculation 
# 
# k = 3
# n = 52.3966
# f = 0.25
# sig.level = 0.05
# power = 0.8
# 
# NOTE: n is number in each group
# 
# pwr.2p.test(h = 0.15, n = NULL , sig.level = 0.05, power =0.8 )

#####################
"Power analysis for SEM"
#####################
# http://timo.gnambs.at/en/scripts/powerforsem

require(semTools)

findRMSEAsamplesize(rmsea0=.05, rmseaA=.08, df=20, power=0.80, group=3)
# 433

# rmsea0   Null RMSEA
# rmseaA	 Alternative RMSEA
# df	 Model degrees of freedom
# power	 Desired statistical power to reject misspecified model 
# alpha	 Alpha level used in power calculations
# group	 The number of group that is used to calculate RMSEA.

