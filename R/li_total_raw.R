li_total_raw <- function(para_vec, yi_vec, obs_m_vec, xi_vec, li_vec, confound_mat) {
  lk_value_vec <- numeric(length(yi_vec))
  for (i in seq_len(length(yi_vec))) {
    yi <- yi_vec[i]
    obs_m <- obs_m_vec[i]
    xi <- xi_vec[i]
    li <- li_vec[i]
    confound_vec <- confound_mat[i, ]

    if (obs_m > 1e-50) {
      lk_value_temp <- li_1_raw_func(para_vec, yi, obs_m, xi, confound_vec)
      lk_value_vec[i] <- lk_value_temp
    } else if (obs_m < 1e-50 && obs_m >= 0) {
      lk_value_temp <- li_2_raw_func(para_vec, yi, xi, li, confound_vec)
      lk_value_vec[i] <- lk_value_temp
    } else {
      warning("negative m")
    }
  }
  li_total <- -sum(lk_value_vec)
  return(li_total)
}
