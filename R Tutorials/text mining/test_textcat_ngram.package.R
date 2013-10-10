
# N-Gram Based Language Detection: No use!!!
# 20131009

library(textcat)

# detect languge english and german
textcat(c("This is an english sentence.",
          "Das ist ein deutscher satz."))
## Compute cross-distances between the TextCat byte profiles using the
## CT out-of-place measure.
d <- textcat_xdist(TC_byte_profiles)
## Visualize results of hierarchical cluster analysis on the distances.
plot(hclust(as.dist(d)), cex = 0.7)

## Obtain the texts of the standard licenses shipped with R.
files <- dir(file.path(R.home("share"), "licenses"), "^[A-Z]",
             full.names = TRUE)
texts <- sapply(files,
                function(f) paste(readLines(f), collapse = "\n"))
names(texts) <- basename(files)
## Build a profile db using the same method and options as for building
## the ECIMCI character profiles.
profiles <- textcat_profile_db(texts, profiles = ECIMCI_profiles)
## Inspect the 10 most frequent n-grams in each profile.
lapply(profiles, head, 10L)
## Combine into one frequency table.
tab <- as.matrix(profiles)
tab[, 1 : 10]
## Determine languages.
textcat(profiles, ECIMCI_profiles)

## Languages in the the ECI/MCI profile db:
names(ECIMCI_profiles)
## Key options used for the profile:
attr(ECIMCI_profiles, "options")[c("n", "size", "reduce", "useBytes")]