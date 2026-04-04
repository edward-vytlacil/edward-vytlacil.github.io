# ==============================================================
# Econ 5551 Problem Set 8: Data Preparation
# ==============================================================
# Run this script (or source it) before starting Problem 2.
# It reads the PROGRESA data, extracts baseline covariates from
# wave 1, and creates the analysis data frame dfPost.
# ==============================================================

df_ <- read.csv(
  "https://edward-vytlacil.github.io/Data/PROGRESA.csv",
  header = TRUE, sep = ",")

df_$treat <- df_$progresa1
df_$girl  <- df_$sex1
df_$age1  <- ifelse(df_$age1 >= 6 & df_$age1 <= 18, df_$age1, NA)

balanced_ids <- intersect(
  df_[df_$wave == 4, "sooind_id"],
  df_[df_$wave == 1 & df_$age1 >= 6 & df_$age1 <= 16, "sooind_id"])

df_ <- df_[df_$sooind_id %in% balanced_ids, ]

# Extract baseline (wave 1) covariates
base_vars <- df_[df_$wave == 1, c("sooind_id", "hgc1", "age1", "girl")]
names(base_vars)[names(base_vars) == "hgc1"] <- "hgc0"
names(base_vars)[names(base_vars) == "age1"] <- "age0"

# Post-treatment data (wave 4)
dfPost <- subset(df_, wave == 4,
  select = c(sooloca, sooind_id, school, treat, girl, wave))

# Merge baseline covariates into post data
dfPost <- merge(dfPost, base_vars[, c("sooind_id", "hgc0", "age0")],
  by = "sooind_id", all.x = TRUE, sort = FALSE)

# Drop observations with missing values of any analysis variable
dfPost <- dfPost[complete.cases(dfPost[, c("school", "treat", "girl",
                                           "age0", "hgc0", "sooloca")]), ]

rm(df_, base_vars, balanced_ids)
