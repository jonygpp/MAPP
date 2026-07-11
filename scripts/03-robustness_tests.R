# ==============================================================================
# 03-robustness_tests.R
# Robustness — testes de estabilidade do Controle Sintético
# Projeto: MAPP2026 - Replicação Freire (2018)
#
# Referência: Freire, D. (2018). Evaluating the Effect of Homicide Prevention
#   Strategies in São Paulo, Brazil: A Synthetic Control Approach.
#   Latin American Research Review, 53(2), 231–249.
#   https://doi.org/10.25222/larr.334
#
# INSTRUÇÕES:
#   Execute APÓS 02-data-analysis.R.
#   Saídas: output/figures/ (EPS/PNG) e output/tables/ (TXT/CSV).
#
# ==============================================================================

rm(list = ls())

# ==============================================================================
# FUNÇÕES UTILITÁRIAS
# ==============================================================================

find_current_file <- function() {
  cmd_args <- commandArgs(trailingOnly = FALSE)
  file_arg  <- grep("^--file=", cmd_args, value = TRUE)
  if (length(file_arg) > 0) {
    return(normalizePath(sub("^--file=", "", file_arg[1]),
                         winslash = "/", mustWork = FALSE))
  }
  frames <- sys.frames()
  for (i in rev(seq_along(frames))) {
    ofile <- frames[[i]]$ofile
    if (!is.null(ofile)) {
      return(normalizePath(ofile, winslash = "/", mustWork = FALSE))
    }
  }
  return(NA_character_)
}

parents <- function(path, max_depth = 6) {
  path <- normalizePath(path, winslash = "/", mustWork = FALSE)
  out  <- path
  for (i in seq_len(max_depth)) {
    new_path <- dirname(out[length(out)])
    if (identical(new_path, out[length(out)])) break
    out <- c(out, new_path)
  }
  unique(out)
}

install_if_missing <- function(pkgs) {
  for (p in pkgs) {
    if (!requireNamespace(p, quietly = TRUE)) {
      message("Pacote ausente: ", p, ". Instalando via CRAN...")
      install.packages(p, repos = "https://cloud.r-project.org")
    }
    suppressPackageStartupMessages(library(p, character.only = TRUE))
  }
}

to_numeric_clean <- function(x) {
  if (is.numeric(x)) return(x)
  x        <- as.character(x)
  x        <- gsub("\\s", "", x)
  has_comma <- grepl(",", x)
  has_dot   <- grepl("\\.", x)
  both      <- has_comma & has_dot
  only_comma <- has_comma & !has_dot
  x[both]       <- gsub("\\.", "", x[both])
  x[both]       <- gsub(",", ".", x[both])
  x[only_comma] <- gsub(",", ".", x[only_comma])
  suppressWarnings(as.numeric(x))
}

# ==============================================================================
# LOCALIZAÇÃO DA RAIZ E CARREGAMENTO DA BASE
# ==============================================================================

install_if_missing("Synth")

find_project_root <- function() {
  this_file    <- find_current_file()
  start_dirs   <- c(getwd(),
                    if (!is.na(this_file)) dirname(this_file) else NA_character_)
  candidate_roots <- unique(unlist(lapply(na.omit(start_dirs), parents)))
  markers <- c(file.path("data", "raw", "df.csv"), "df.csv",
               file.path("data", "raw", "homicide-rates.csv"))
  for (root in candidate_roots) {
    if (any(file.exists(file.path(root, markers)))) {
      return(normalizePath(root, winslash = "/", mustWork = TRUE))
    }
  }
  stop(
    "Raiz do projeto nao localizada.\n",
    "Execute 01 e 02 primeiro.\n",
    "Diretorio atual: ", getwd()
  )
}

project_root <- find_project_root()
setwd(project_root)
cat("Raiz do projeto:", getwd(), "\n")

dir.create("output/figures", recursive = TRUE, showWarnings = FALSE)
dir.create("output/tables",  recursive = TRUE, showWarnings = FALSE)

if (!file.exists("data/raw/df.csv") && !file.exists("df.csv")) {
  script_01 <- "01-data-wrangling_corrigido_final.R"
  if (file.exists(script_01)) source(script_01, local = FALSE)
  else stop("df.csv nao encontrado. Execute 01-data-wrangling_corrigido_final.R.")
}

path_df  <- if (file.exists("data/raw/df.csv")) "data/raw/df.csv" else "df.csv"
df       <- read.csv(path_df, header = TRUE, stringsAsFactors = FALSE)
df$state <- as.character(df$state)

numeric_vars <- c(
  "code", "year", "homicide.rates", "state.gdp.capita",
  "state.gdp.growth.percent", "population.projection",
  "population.projection.ln", "years.schooling.imp",
  "proportion.extreme.poverty", "gini.imp"
)
for (v in intersect(numeric_vars, names(df))) df[[v]] <- to_numeric_clean(df[[v]])

variaveis_necessarias <- c(
  "abbreviation", "code", "state", "year", "homicide.rates",
  "state.gdp.capita", "state.gdp.growth.percent",
  "population.projection.ln", "years.schooling.imp",
  "proportion.extreme.poverty", "gini.imp"
)
faltantes <- setdiff(variaveis_necessarias, names(df))
if (length(faltantes) > 0) stop("Variaveis ausentes: ", paste(faltantes, collapse = ", "))

cat("Base carregada:", path_df, "—", paste(dim(df), collapse = " x "), "\n\n")

# ==============================================================================
# PARÂMETROS E FUNÇÕES DE ESTIMAÇÃO
# ==============================================================================

sp_id      <- 35
donor_pool <- c(11:17, 21:27, 31:33, 41:43, 50:53)
all_states <- c(donor_pool, sp_id)
years_main <- 1990:2009

# Encapsula dataprep() + synth() em uma única função para reduzir repetição.
run_synth <- function(treated_id, controls_id, prior_years, plot_years) {
  dp <- dataprep(
    foo       = df,
    predictors = c("state.gdp.capita", "state.gdp.growth.percent",
                   "population.projection.ln", "years.schooling.imp"),
    special.predictors = list(
      list("homicide.rates",            prior_years, "mean"),
      list("proportion.extreme.poverty", prior_years, "mean"),
      list("gini.imp",                  prior_years, "mean")
    ),
    predictors.op        = "mean",
    dependent            = "homicide.rates",
    unit.variable        = "code",
    time.variable        = "year",
    unit.names.variable  = "state",
    treatment.identifier = treated_id,
    controls.identifier  = controls_id,
    time.predictors.prior = prior_years,
    time.optimize.ssr    = prior_years,
    time.plot            = plot_years
  )
  sy <- synth(dp)
  list(dataprep = dp, synth = sy)
}

# Calcula o gap (Y1 − Y_sintético) a partir de um objeto fit.
get_gap <- function(fit) {
  as.numeric(fit$dataprep$Y1plot -
               (fit$dataprep$Y0plot %*% fit$synth$solution.w))
}

# Extrai a série sintética.
get_synthetic_series <- function(fit) {
  as.numeric(fit$dataprep$Y0plot %*% fit$synth$solution.w)
}

# Calcula RMSPE para um subconjunto de anos.
get_rmspe <- function(gap, years, period) {
  idx <- years %in% period
  sqrt(mean(gap[idx]^2, na.rm = TRUE))
}

# ==============================================================================
# MODELO PRINCIPAL (reestimado neste script como referência para os testes)
# ==============================================================================

cat("--- Estimando modelo principal (referência) ---\n")

fit_main <- run_synth(
  treated_id  = sp_id,
  controls_id = donor_pool,
  prior_years = 1990:1998,
  plot_years  = years_main
)

synth.tables_main <- synth.tab(dataprep.res = fit_main$dataprep,
                               synth.res    = fit_main$synth)
print(synth.tables_main)

capture.output(print(synth.tables_main),
               file = "output/tables/main_synth_tables_for_robustness.txt")

gap_main       <- get_gap(fit_main)
synthetic_main <- get_synthetic_series(fit_main)

cat("  Modelo principal estimado.\n\n")

# ==============================================================================
# A. TESTE PLACEBO TEMPORAL
# Desloca artificialmente o início da intervenção para 1995.
# Hipótese: se o modelo já estimasse efeito expressivo antes de 1999, isso
# seria evidência de tendência pré-existente não capturada pelo contrafactual.
# ==============================================================================

cat("--- Teste A: Placebo temporal (intervencao ficticia em 1995) ---\n")

fit_placebo <- run_synth(
  treated_id  = sp_id,
  controls_id = donor_pool,
  prior_years = 1990:1994,
  plot_years  = 1990:1998
)

synth.tables_placebo <- synth.tab(dataprep.res = fit_placebo$dataprep,
                                  synth.res    = fit_placebo$synth)
capture.output(print(synth.tables_placebo),
               file = "output/tables/placebo_synth_tables.txt")

png(file = "output/figures/placebo.png", width = 7, height = 5.25, units = "in", res = 300)

path.plot(synth.res       = fit_placebo$synth,
          dataprep.res    = fit_placebo$dataprep,
          Ylab            = "Homicide Rates",
          Xlab            = "Year",
          Legend          = c("São Paulo", "Synthetic São Paulo"),
          Legend.position = "bottomleft",
          Ylim            = c(0, 50))

abline(v = 1995, lty = 2)
arrows(1994, 40, 1995, 40, col = "black", length = .1)
text(1993, 40, "Placebo \nPolicy Change", cex = .8)

dev.off()
cat("  Salvo: output/figures/placebo.png\n\n")

# ==============================================================================
# B. LEAVE-ONE-OUT
# Remove sucessivamente cada um dos principais doadores do pool e reestima.
# Avalia se o resultado depende desproporcionalmente de um único estado.
# Estados omitidos: RR (14), RJ (33), SC (42), DF (53) — maiores pesos no
# modelo principal.
# ==============================================================================

cat("--- Teste B: Leave-one-out ---\n")

omit_states  <- c(14, 33, 42, 53)   # RR, RJ, SC, DF
store_synth  <- matrix(NA_real_,
                       nrow = length(years_main),
                       ncol = length(omit_states))
colnames(store_synth) <- as.character(omit_states)

for (k in seq_along(omit_states)) {
  omit         <- omit_states[k]
  donor_loo    <- setdiff(donor_pool, omit)
  fit_loo      <- run_synth(sp_id, donor_loo, 1990:1998, years_main)
  store_synth[, k] <- get_synthetic_series(fit_loo)
  cat("  Leave-one-out: estado", omit, "removido.\n")
}

png(file = "output/figures/leave-one-out.png", width = 7, height = 5.25, units = "in", res = 300)

path.plot(synth.res       = fit_main$synth,
          dataprep.res    = fit_main$dataprep,
          Ylab            = "Homicide Rates",
          Xlab            = "Year",
          Legend          = c("São Paulo", "Synthetic São Paulo"),
          Legend.position = "bottomleft")

abline(v = 1999, lty = 2)
arrows(1997, 50, 1999, 50, col = "black", length = .1)
text(1995, 50, "Policy Change", cex = .8)

for (i in seq_len(ncol(store_synth))) {
  lines(years_main, store_synth[, i], col = "darkgrey", lty = "solid", lwd = 1)
}

lines(years_main, synthetic_main, col = "black", lty = "dashed", lwd = 2)

legend(x      = "bottomleft",
       legend = c("São Paulo",
                  "Synthetic São Paulo",
                  "Synthetic São Paulo (leave-one-out)"),
       lty    = c("solid", "dashed", "solid"),
       col    = c("black", "black", "darkgrey"),
       lwd    = c(2, 2, 1),     # CORRIGIDO: lwdc(2,2,1) → lwd = c(2,2,1)
       cex    = .8,
       bg     = "white")

dev.off()
cat("  Salvo: output/figures/leave-one-out.png\n\n")

# ==============================================================================
# C. PLACEBOS POR PERMUTAÇÃO ENTRE ESTADOS
# Aplica o mesmo procedimento de controle sintético a todos os estados,
# tratando cada um como se tivesse recebido a intervenção.
# Produz distribuição empírica de gaps para comparação com SP.
# ==============================================================================

cat("--- Teste C: Placebos por permutacao ---\n")

fits_perm  <- list()
gaps       <- list()
rmspe_table <- data.frame(
  code        = integer(),
  rmspe_pre   = numeric(),
  rmspe_post  = numeric(),
  rmspe_ratio = numeric(),
  stringsAsFactors = FALSE
)

for (i in all_states) {
  controls_i <- setdiff(all_states, i)
  
  fit_i <- tryCatch(
    run_synth(i, controls_i, 1990:1998, years_main),
    error = function(e) {
      warning("Synth falhou para o estado ", i, ": ", conditionMessage(e))
      NULL
    }
  )
  
  if (is.null(fit_i)) next
  
  fits_perm[[as.character(i)]] <- fit_i
  gap_i                        <- get_gap(fit_i)
  gaps[[as.character(i)]]      <- gap_i
  
  rmspe_pre  <- get_rmspe(gap_i, years_main, 1990:1998)
  rmspe_post <- get_rmspe(gap_i, years_main, 1999:2009)
  
  rmspe_table <- rbind(rmspe_table, data.frame(
    code        = i,
    rmspe_pre   = rmspe_pre,
    rmspe_post  = rmspe_post,
    rmspe_ratio = rmspe_post / rmspe_pre
  ))
  
  cat("  Estado", i, "concluido. RMSPE pre:", round(rmspe_pre, 3),
      "| RMSPE pos:", round(rmspe_post, 3), "\n")
}

if (!as.character(sp_id) %in% names(gaps)) {
  stop("Modelo de Sao Paulo falhou no teste de permutacao.")
}

write.csv(rmspe_table, "output/tables/rmspe_placebos.csv", row.names = FALSE)
cat("  Tabela RMSPE salva: output/tables/rmspe_placebos.csv\n\n")

# Resultado do RMSPE de SP para referência no relatório
sp_rmspe_pre  <- rmspe_table$rmspe_pre[rmspe_table$code == sp_id]
sp_rmspe_post <- rmspe_table$rmspe_post[rmspe_table$code == sp_id]
sp_ratio      <- rmspe_table$rmspe_ratio[rmspe_table$code == sp_id]
cat("  SP RMSPE pre-tratamento:", round(sp_rmspe_pre,  3), "\n")
cat("  SP RMSPE pos-tratamento:", round(sp_rmspe_post, 3), "\n")
cat("  SP Razao pos/pre:       ", round(sp_ratio,       3), "\n\n")

# Gráfico completo (todos os estados)
png(file = "output/figures/permutation-gaps2.png", width = 7, height = 5.25, units = "in", res = 300)

plot(x    = years_main,
     y    = rep(NA_real_, length(years_main)),
     type = "n",
     ylim = c(-30, 30),
     xlim = c(1990, 2009),
     ylab = "Gap in Homicide Rates",
     xlab = "Year")

for (i in names(gaps)) {
  if (as.integer(i) != sp_id) {
    lines(years_main, gaps[[i]], col = "lightgrey", lty = "solid", lwd = 2)
  }
}

lines(years_main, gaps[[as.character(sp_id)]], col = "black", lty = "solid", lwd = 2)
abline(v = 1999, lty = 2)
abline(h = 0,    lty = 1, lwd = 1)
arrows(1997, 25, 1999, 25, col = "black", length = .1)
text(1995, 25, "Policy Change", cex = .8)

legend(x      = "bottomleft",
       legend = c("São Paulo", "Control States"),
       lty    = c("solid", "solid"),
       col    = c("black", "darkgrey"),
       lwd    = c(2, 2),        # CORRIGIDO: lwdc(2,2,1) → lwd = c(2,2)
       cex    = .8,
       bg     = "white")

dev.off()
cat("  Salvo: output/figures/permutation-gaps2.png\n")

# ==============================================================================
# D. PLACEBOS RESTRITOS POR RMSPE (filtro ≤ 2× RMSPE de SP)
# Estados com ajuste pré-tratamento ruim não constituem bons contrafactuais.
# Este gráfico restringe a comparação a estados com RMSPE_pre ≤ 2 × RMSPE_SP.
# ==============================================================================

cat("\n--- Teste D: Placebos com baixo RMSPE pre-tratamento ---\n")

if (length(sp_rmspe_pre) != 1 || is.na(sp_rmspe_pre)) {
  stop("Nao foi possivel calcular RMSPE pre de SP.")
}

low_mspe_codes <- rmspe_table$code[rmspe_table$rmspe_pre <= 2 * sp_rmspe_pre]
low_mspe_codes <- intersect(low_mspe_codes, as.integer(names(gaps)))

cat("  Estados que passaram no filtro RMSPE (<= 2x SP):",
    length(low_mspe_codes), "de", nrow(rmspe_table), "\n")
cat("  Codigos:", paste(sort(low_mspe_codes), collapse = ", "), "\n")

# Registra os estados filtrados para uso no relatório
write.csv(
  rmspe_table[rmspe_table$code %in% low_mspe_codes, ],
  "output/tables/rmspe_low_mspe_states.csv",
  row.names = FALSE
)

png(file = "output/figures/low-mspe.png", width = 7, height = 5.25, units = "in", res = 300)

plot(x    = years_main,
     y    = rep(NA_real_, length(years_main)),
     type = "n",
     ylim = c(-30, 30),
     xlim = c(1990, 2009),
     ylab = "Gap in Homicide Rates",
     xlab = "Year")

for (i in low_mspe_codes) {
  if (i != sp_id) {
    lines(years_main, gaps[[as.character(i)]], col = "lightgrey", lty = "solid", lwd = 2)
  }
}

lines(years_main, gaps[[as.character(sp_id)]], col = "black", lty = "solid", lwd = 2)
abline(v = 1999, lty = 2)
abline(h = 0,    lty = 1, lwd = 1)
arrows(1997, 25, 1999, 25, col = "black", length = .1)
text(1995, 25, "Policy Change", cex = .8)

legend(x      = "bottomleft",
       legend = c("São Paulo",
                  "Control States (MSPE Less Than Two Times That of São Paulo)"),
       lty    = c("solid", "solid"),
       col    = c("black", "darkgrey"),
       lwd    = c(2, 2),
       cex    = .8,
       bg     = "white")

dev.off()
cat("  Salvo: output/figures/low-mspe.png\n\n")



# ==============================================================================
# E. CHECAGEM FINAL DE OUTPUTS
# ==============================================================================

outputs_robustez <- c(
  "output/figures/placebo.png",
  "output/figures/leave-one-out.png",
  "output/figures/permutation-gaps2.png",
  "output/figures/low-mspe.png",
  "output/tables/placebo_synth_tables.txt",
  "output/tables/main_synth_tables_for_robustness.txt",
  "output/tables/rmspe_placebos.csv",
  "output/tables/rmspe_low_mspe_states.csv"
)

check_outputs <- data.frame(arquivo = outputs_robustez,
                            existe  = file.exists(outputs_robustez))
print(check_outputs)

write.csv(check_outputs,
          "output/tables/check_outputs_03_robustness.csv",
          row.names = FALSE)

if (any(!check_outputs$existe)) {
  stop("Outputs incompletos. Verifique a tabela acima.")
}

# ==============================================================================
# G. DOCUMENTAÇÃO DO AMBIENTE
# ==============================================================================

capture.output(sessionInfo(),
               file = "output/tables/sessionInfo_03_robustness.txt")

cat("\n=================================================================\n")
cat("  03-robustness-tests concluido com sucesso.\n")
cat("  Outputs em output/figures/ e output/tables/\n")
cat("=================================================================\n")

sessionInfo()