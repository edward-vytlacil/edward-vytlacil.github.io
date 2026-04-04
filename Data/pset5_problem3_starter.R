# ==============================================================
# Econ 2136 Problem Set 5, Problem 3: Starter Code
# Post-Model-Selection Inference — Monte Carlo Simulation
# ==============================================================
# Instructions: search for "### FILL IN ###" to find the parts
# you need to complete.  There are 8 places to fill in.
# ==============================================================

library(ggplot2)

# ---- DGP parameters ----
beta_0    <- 1
beta_1    <- 2       # parameter of interest
sigma     <- 1
n         <- 100
rho       <- 0.5
alpha_sel <- 0.05    # significance level for model selection test
B         <- 10000   # number of MC replications

# ==============================================================
# Part (b): Complete the simulation function
# ==============================================================

sim_one_rep <- function(n, beta_0, beta_1, beta_2, sigma, rho, alpha_sel) {
  ## --- Step 1: Generate data ---
  Z1 <- rnorm(n)
  Z2 <- rnorm(n)
  X1 <- Z1
  X2 <- rho * Z1 + sqrt(1 - rho^2) * Z2
  eps <- rnorm(n, 0, sigma)
  Y  <- beta_0 + beta_1 * X1 + beta_2 * X2 + eps

  ## --- Step 2: Long regression (always full) ---
  fit_full  <- lm(Y ~ X1 + X2)
  b1_full   <- coef(fit_full)["X1"]
  se_full   <- summary(fit_full)$coefficients["X1", 2]
  ci_full   <- b1_full + c(-1, 1) * qnorm(0.975) * se_full
  cov_full  <- ### FILL IN ###  # TRUE/FALSE: does ci_full cover beta_1?

  ## --- Step 3: Short regression (always restricted) ---
  fit_short  <- ### FILL IN ###  # regress Y on X1 only
  b1_short   <- ### FILL IN ###
  se_short   <- ### FILL IN ###
  ci_short   <- b1_short + c(-1, 1) * qnorm(0.975) * se_short
  cov_short  <- ### FILL IN ###

  ## --- Step 4: Post-model-selection ---
  p_val_b2 <- summary(fit_full)$coefficients["X2", 4]

  if (p_val_b2 < alpha_sel) {
    ## Reject H0: beta_2 = 0 --> keep full model
    fit_sel <- fit_full
  } else {
    ## Fail to reject --> drop X2
    fit_sel <- ### FILL IN ###
  }

  b1_post  <- coef(fit_sel)["X1"]
  se_post  <- summary(fit_sel)$coefficients["X1", 2]
  ci_post  <- b1_post + c(-1, 1) * qnorm(0.975) * se_post
  cov_post <- ### FILL IN ###
  selected_full <- as.numeric(p_val_b2 < alpha_sel)

  ## --- Return named vector ---
  c(b1_full  = b1_full,  se_full  = se_full,  cov_full  = cov_full,
    b1_short = b1_short, se_short = se_short, cov_short = cov_short,
    b1_post  = b1_post,  se_post  = se_post,  cov_post  = cov_post,
    selected_full = selected_full)
}

# ==============================================================
# Part (c): Run the simulation for three values of beta_2
# ==============================================================

set.seed(2136)

# Case 1: beta_2 = 0
res_00 <- replicate(B, sim_one_rep(n, beta_0, beta_1,
                                   beta_2 = 0, sigma, rho, alpha_sel))

# Case 2: beta_2 = 0.2
res_02 <- replicate(B, sim_one_rep(n, beta_0, beta_1,
                                   beta_2 = ### FILL IN ###,
                                   sigma, rho, alpha_sel))

# Case 3: beta_2 = 1
res_10 <- replicate(B, sim_one_rep(n, beta_0, beta_1,
                                   beta_2 = ### FILL IN ###,
                                   sigma, rho, alpha_sel))

# ---- Helper function to summarize one case ----
summarize_case <- function(res, beta_2_val) {
  cat("\n======================================\n")
  cat("beta_2 =", beta_2_val, "\n")
  cat("======================================\n")
  cat("Fraction selecting full model:",
      round(mean(res["selected_full", ]), 3), "\n\n")

  cat("--- Always Full (Long Regression) ---\n")
  cat("  Bias:    ", round(mean(res["b1_full", ]) - beta_1, 4), "\n")
  cat("  Coverage:", round(mean(res["cov_full", ]), 4), "\n\n")

  cat("--- Always Restricted (Short Regression) ---\n")
  cat("  Bias:    ", round(mean(res["b1_short", ]) - beta_1, 4), "\n")
  cat("  Coverage:", round(mean(res["cov_short", ]), 4), "\n\n")

  cat("--- Post-Selection ---\n")
  cat("  Bias:    ", round(mean(res["b1_post", ]) - beta_1, 4), "\n")
  cat("  Coverage:", round(mean(res["cov_post", ]), 4), "\n")
}

summarize_case(res_00, 0)
summarize_case(res_02, 0.2)
summarize_case(res_10, 1)

# ==============================================================
# Part (d): Histogram vs. normal density for beta_2 = 0.2
# ==============================================================

b1_post_vals <- res_02["b1_post", ]
avg_var_post <- mean(res_02["se_post", ]^2)

df_hist <- data.frame(b1 = b1_post_vals)
x_grid  <- seq(min(b1_post_vals) - 0.1, max(b1_post_vals) + 0.1,
               length.out = 300)
df_norm <- data.frame(x = x_grid,
                      y = dnorm(x_grid, mean = beta_1,
                                sd = sqrt(avg_var_post)))

ggplot() +
  geom_histogram(data = df_hist, aes(x = b1, y = after_stat(density)),
                 bins = 60, fill = "steelblue", alpha = 0.5) +
  geom_line(data = df_norm, aes(x = x, y = y),
            color = "darkred", linewidth = 0.8) +
  labs(x = expression(hat(beta)[1]^{post}),
       y = "Density",
       title = expression(
         "Sampling Distribution of " * hat(beta)[1]^{post} *
         " vs. Normal  (" * beta[2] * " = 0.2)")) +
  theme_minimal()
