# =============================================================================
#### Info #### 
# =============================================================================
# binomial globe example
#
# Lei Zhang 
# lei.zhang@univie.ac.at
#
# Adapted from McElreath, 2016

# =============================================================================
#### Construct Data #### 
# =============================================================================
# clear workspace
rm(list=ls(all=TRUE))

w <- c(6,7)
N <- 9
dataList <- list(w=w, N=N)

# =============================================================================
#### Running Stan #### 
# =============================================================================
library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = 2)

modelFile <- '_scripts/binomial_globe_model_v3.stan'
nIter     <- 2000
nChains   <- 4 
nWarmup   <- floor(nIter/2)
nThin     <- 1

cat("Estimating", modelFile, "model... \n")
startTime = Sys.time(); print(startTime)
cat("Calling", nChains, "simulations in Stan... \n")

fit_globe <- stan(modelFile, 
                  data    = dataList, 
                  chains  = nChains,
                  iter    = nIter,
                  warmup  = nWarmup,
                  thin    = nThin,
                  init    = "random",
                  seed    = 1450154626)

cat("Finishing", modelFile, "model simulation ... \n")
endTime = Sys.time(); print(endTime)  
cat("It took",as.character.Date(endTime - startTime), "\n")

# =============================================================================
#### Model Summary and Diagnostics #### 
# =============================================================================
print(fit_globe)

plot_trace_excl_warm_up <- stan_trace(fit_globe, pars = 'p', inc_warmup = F)
plot_trace_incl_warm_up <- stan_trace(fit_globe, pars = 'p', inc_warmup = T)

plot_dens_cmb <- stan_dens(fit_globe, separate_chains = F, fill = 'skyblue')
plot_dens_sep <- stan_dens(fit_globe, separate_chains = T)
