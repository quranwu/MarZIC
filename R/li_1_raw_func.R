li_1_raw_func <- function(para_vec, yi, m_star, x_i, confound_vec) {
  num_conf <- length(confound_vec)
  k <- (length(para_vec) - 9 - 3 * num_conf) / 3
  
  beta_0 <- para_vec[1]
  beta_1 <- para_vec[2]
  beta_2 <- para_vec[3]
  beta_3 <- para_vec[4]
  beta_4 <- para_vec[5]
  beta_5 <- para_vec[6]
  
  gamma_0 <- para_vec[7]
  gamma_1 <- para_vec[8]
  phi <- para_vec[9]
  delta <- para_vec[10]
  
  alpha_0_vec <- para_vec[11:(10 + k)]
  alpha_1_vec <- para_vec[(11 + k):(10 + 2 * k)]
  
  if (k == 1) {
    psi_vec <- 1
    beta_conf <- para_vec[seq(13, 12 + num_conf)]
    alpha_conf <-
      para_vec[seq(13 + num_conf, 12 + 2 * num_conf)]
    gamma_conf <-
      para_vec[seq(13 + 2 * num_conf, 12 + 3 * num_conf)]
  } else {
    psi_temp <- para_vec[(11 + 2 * k):(9 + 3 * k)]
    psi_vec <- c(psi_temp, 1 - sum(psi_temp))
    beta_conf <- para_vec[seq(10 + 3 * k, 9 + 3 * k + num_conf)]
    alpha_conf <-
      para_vec[seq(10 + 3 * k + num_conf, 9 + 3 * k + 2 * num_conf)]
    gamma_conf <-
      para_vec[seq(10 + 3 * k + 2 * num_conf, 9 + 3 * k + 3 * num_conf)]
  }
  
  
  
  mu_1 <-
    expit(alpha_0_vec + alpha_1_vec * x_i + sum(alpha_conf * confound_vec))
  delta_i <-
    expit(gamma_0 + gamma_1 * x_i + sum(gamma_conf * confound_vec))
  norm_part <-
    (
      yi - beta_0 - beta_1 * m_star - beta_2 - (beta_3 + beta_4) * x_i - beta_5 * x_i * m_star - sum(beta_conf *
                                                                                                       confound_vec)
    ) ^ 2 / (2 * delta ^ 2)
  beta_part <-
    log((1 - delta_i) * sum(psi_vec * dbeta(m_star, mu_1 * phi, (1 - mu_1) * phi)))
  lh_value <-
    -0.5 * log(2 * pi) - log(delta) - norm_part + beta_part
  return(lh_value)
}
