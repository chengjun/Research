JKcoefggplot <- function(coef, lower, upper, varnames, groupname, xlab, label.pos = c(0, 1, 2), fontsize = NULL, monochrome = NULL)
{
  
  # This function creates a dot-and-whisker plot for regression coefficients, first differences, etc.
  # It requires the following arguments:
  # coef: a (numeric) vector of coefficients/first differences/...
  ## If using groups of variables: enter NA for the empty coefficient designating a group
  # se: a vector of standard errors
  ## If using groups of variables: enter NA for the empty SE designating a group
  # varnames: a (character) vector of variable names
  ## If using groups of variables: enter the group name where you want it to appear
  # groupname: a (character) vector of variable groups with the same length as varnames
  # xlab: a character vector of length 1 with the label for the x-axis
  # label.pos: Position of the x-axis tick labels; 0 (default) for left, 0.5 for center, 1 for right
  # monochrome: 0 for colors, 1 for black dots and whiskers
  # Optional arguments:
  # fontsize: an optional numeric vector of varying font sizes (if using groups)
  
  var <- seq(length(varnames), 1, by = -1)
  group <- as.numeric(as.factor(groupname))
  if (is.null(fontsize) == FALSE) results <- data.frame(var=var, varnames=varnames, coef=coef, lower = lower, upper = upper, group=group, groupname=groupname, fontsize = fontsize)
  if (is.null(fontsize) == TRUE) results <- data.frame(var=var, varnames=varnames, coef=coef, lower = lower, upper = upper, group=group, groupname=groupname)
  
  require(ggplot2)
  
  if (is.null(fontsize) == FALSE && monochrome == 1) p <- ggplot(results, aes(x = coef, y = as.factor(var))) + geom_point(colour = "black") + geom_segment(aes(x = lower, xend = upper, y = var, yend = var), colour = "black") + theme_bw() + xlab(paste(xlab)) + ylab("") + scale_y_discrete(breaks=results$var, labels=results$varnames) + geom_vline(xintercept = 0, colour = "blue", linetype = 2) + theme(legend.position = "none", axis.text.y = element_text(colour = "black", hjust = label.pos, size = results$fontsize), axis.text.x = element_text(colour = "black"))
  
  if (is.null(fontsize) == FALSE && monochrome == 0) p <- ggplot(results, aes(x = coef, y = as.factor(var), colour = groupname)) + geom_point() + geom_segment(aes(x = lower, xend = upper, y = var, yend = var)) + theme_bw() + xlab(paste(xlab)) + ylab("") + scale_y_discrete(breaks=results$var, labels=results$varnames) + geom_vline(xintercept = 0, colour = "blue", linetype = 2) + theme(legend.position = "none", axis.text.y = element_text(colour = "black", hjust = label.pos, size = results$fontsize), axis.text.x = element_text(colour = "black"))
  
  if (is.null(fontsize) == TRUE && monochrome == 1) p <- ggplot(results, aes(x = coef, y = as.factor(var))) + geom_point(colour = "black") + geom_segment(aes(x = lower, xend = upper, y = var, yend = var), colour = "black") + theme_bw() + xlab(paste(xlab)) + ylab("") + scale_y_discrete(breaks=results$var, labels=results$varnames) + geom_vline(xintercept = 0, colour = "blue", linetype = 2) + theme(legend.position = "none", axis.text.y = element_text(colour = "black", hjust = label.pos), axis.text.x = element_text(colour = "black"))
  
  if (is.null(fontsize) == TRUE && monochrome == 0) p <- ggplot(results, aes(x = coef, y = as.factor(var), colour = groupname)) + geom_point() + geom_segment(aes(x = lower, xend = upper, y = var, yend = var)) + theme_bw() + xlab(paste(xlab)) + ylab("") + scale_y_discrete(breaks=results$var, labels=results$varnames) + geom_vline(xintercept = 0, colour = "blue", linetype = 2) + theme(legend.position = "none", axis.text.y = element_text(colour = "black", hjust = label.pos), axis.text.x = element_text(colour = "black"))
  
  print(p)
  
}