# Lab07 - Pipeline IV (2SLS) em R
# Base: Miguel, Satyanath e Sergenti (2004)
# Data: Data/mss_repdata.dta

# -----------------------------
# BLOCO 1 — SETUP DO AMBIENTE
# -----------------------------

suppressPackageStartupMessages({
  library(tidyverse)
  library(fixest)
  library(sandwich)
  library(lmtest)
  library(haven)
})

# Definir diretório de trabalho (raiz do projeto)
args <- commandArgs(trailingOnly = FALSE)
script_arg <- "--file="
script_path <- sub(script_arg, "", args[grep(script_arg, args)])

if (length(script_path) > 0) {
  project_root <- normalizePath(file.path(dirname(script_path), ".."))
  setwd(project_root)
}

# Configuração de log
log_file <- file.path("logs", "lab07_iv_pipeline_2026-03-27.log")
sink(log_file, split = TRUE)
on.exit(sink(), add = TRUE)

cat("=== INÍCIO DO PIPELINE IV (LAB07) ===\n")
cat("Diretório de trabalho:", getwd(), "\n")

# Importar base de dados
# Observação: o repositório não contém CSV; usa-se o .dta de replicação oficial.
data_file <- file.path("Data", "mss_repdata.dta")

if (!file.exists(data_file)) {
  stop("ERRO CRÍTICO: arquivo de dados não encontrado: ", data_file)
}

df_raw <- read_dta(data_file)

# Exibir estrutura
str(df_raw)
print(dim(df_raw))

# Checkpoint 1
if (nrow(df_raw) <= 0) {
  stop("Checkpoint 1 FALHOU: número de observações igual a zero.")
} else {
  cat("Checkpoint 1 OK: dataset carregado com", nrow(df_raw), "observações.\n")
}


# -----------------------------------
# BLOCO 2 — LIMPEZA E PREPARAÇÃO
# -----------------------------------

# Identificar variáveis presentes no dataset
# Mapeamento explícito para os nomes padrão do exercício:
# conflict -> war_prio
# growth   -> gdp_g
# rain     -> GPCP_g

required_map <- c(conflict = "war_prio", growth = "gdp_g", rain = "GPCP_g")

missing_vars <- required_map[!required_map %in% colnames(df_raw)]
if (length(missing_vars) > 0) {
  stop(
    "Checkpoint 2 FALHOU: variáveis ausentes no dataset: ",
    paste(names(missing_vars), "->", missing_vars, collapse = ", ")
  )
}

print(colnames(df_raw))

df_analysis <- df_raw %>%
  transmute(
    conflict = .data[[required_map[["conflict"]]]],
    growth = .data[[required_map[["growth"]]]],
    rain = .data[[required_map[["rain"]]]]
  ) %>%
  drop_na()

print(dim(df_analysis))
print(summary(df_analysis))

# Checkpoint 2
if (!all(c("conflict", "growth", "rain") %in% colnames(df_analysis))) {
  stop("Checkpoint 2 FALHOU: variáveis conflict, growth, rain não estão disponíveis.")
}

if (sum(is.na(df_analysis)) > 0) {
  stop("Checkpoint 2 FALHOU: ainda há NA no dataset final.")
} else {
  cat("Checkpoint 2 OK: variáveis identificadas e dataset sem NA.\n")
}


# -----------------------------------
# BLOCO 3 — DEFINIÇÃO DO MODELO
# -----------------------------------

Y <- "conflict"
D <- "growth"
Z <- "rain"

cat("Modelo: conflict ~ growth | instrumento: rain\n")

# Checkpoint 3
if (!all(c(Y, D, Z) %in% colnames(df_analysis))) {
  stop("Checkpoint 3 FALHOU: Y, D e/ou Z não encontrados no dataset analítico.")
} else {
  cat("Checkpoint 3 OK: variáveis do modelo definidas corretamente.\n")
}


# ---------------------------
# BLOCO 4 — ESTIMAÇÃO OLS
# ---------------------------

model_ols <- feols(conflict ~ growth, data = df_analysis)

# Tentativa com coeftest + vcovHC conforme prompt
ols_robust <- tryCatch(
  coeftest(model_ols, vcov = vcovHC(model_ols, type = "HC1")),
  error = function(e) {
    cat("Aviso: coeftest(vcovHC) falhou para fixest; usando vcov hetero do fixest.\n")
    coeftable(model_ols, vcov = "hetero")
  }
)

print(ols_robust)
results_ols <- summary(model_ols)

# Checkpoint 4
coef_ols <- coef(model_ols)
if (!("growth" %in% names(coef_ols))) {
  stop("Checkpoint 4 FALHOU: coeficiente de growth não disponível no OLS.")
} else {
  cat("Checkpoint 4 OK: OLS estimado e coeficiente de growth disponível.\n")
}


# ---------------------------
# BLOCO 5 — FIRST STAGE
# ---------------------------

model_fs <- feols(growth ~ rain, data = df_analysis)
print(summary(model_fs))

fs_fstat <- fitstat(model_fs, "f")
print(fs_fstat)
fs_f_value <- suppressWarnings(as.numeric(fs_fstat[["f"]][["stat"]]))

# Checkpoint 5
coef_fs <- coef(model_fs)
if (!("rain" %in% names(coef_fs))) {
  stop("Checkpoint 5 FALHOU: coeficiente de rain não estimado no first stage.")
}

if (is.null(fs_fstat) || length(fs_fstat) == 0 || is.na(fs_f_value)) {
  stop("Checkpoint 5 FALHOU: F-stat não calculado.")
} else {
  cat("Checkpoint 5 OK: first stage estimado e F-stat calculado.\n")
}

if (fs_f_value < 10) {
  cat("AVISO: instrumento potencialmente fraco\n")
}


# ----------------------------
# BLOCO 6 — REDUCED FORM
# ----------------------------

model_rf <- feols(conflict ~ rain, data = df_analysis)
print(summary(model_rf))

# Checkpoint 6
if (length(coef(model_rf)) == 0) {
  stop("Checkpoint 6 FALHOU: reduced form não estimado.")
} else {
  cat("Checkpoint 6 OK: reduced form estimado sem erro.\n")
}


# --------------------------------
# BLOCO 7 — ESTIMAÇÃO IV (2SLS)
# --------------------------------

model_iv <- feols(conflict ~ 1 | growth ~ rain, data = df_analysis)
print(summary(model_iv))

iv_robust <- tryCatch(
  coeftest(model_iv, vcov = vcovHC(model_iv, type = "HC1")),
  error = function(e) {
    cat("Aviso: coeftest(vcovHC) falhou para IV em fixest; usando vcov hetero do fixest.\n")
    coeftable(model_iv, vcov = "hetero")
  }
)

print(iv_robust)

# Checkpoint 7
coef_iv <- coef(model_iv)
coef_iv_names <- names(coef_iv)
if (!("fit_growth" %in% coef_iv_names || "growth" %in% coef_iv_names)) {
  stop("Checkpoint 7 FALHOU: coeficiente de growth não disponível no IV.")
} else {
  cat("Checkpoint 7 OK: modelo IV estimado e coeficiente de growth disponível.\n")
}


# ------------------------------------
# BLOCO 8 — COMPARAÇÃO OLS vs IV
# ------------------------------------

comparison_table <- etable(model_ols, model_iv, vcov = "hetero")
print(comparison_table)

# Checkpoint 8
if (is.null(comparison_table) || nrow(comparison_table) == 0) {
  stop("Checkpoint 8 FALHOU: tabela comparativa não gerada.")
} else {
  cat("Checkpoint 8 OK: tabela comparativa OLS vs IV gerada.\n")
}


# -------------------------
# BLOCO 9 — DIAGNÓSTICOS
# -------------------------

cat("F-stat do first stage:", fs_f_value, "\n")

coef_ols_growth <- unname(coef_ols["growth"])
iv_coef_name <- if ("fit_growth" %in% names(coef_iv)) "fit_growth" else "growth"
coef_iv_growth <- unname(coef_iv[iv_coef_name])

cat("Sinal OLS (growth -> conflict):", ifelse(coef_ols_growth >= 0, "positivo", "negativo"), "\n")
cat("Sinal IV (growth -> conflict):", ifelse(coef_iv_growth >= 0, "positivo", "negativo"), "\n")
cat("Diferença (IV - OLS):", coef_iv_growth - coef_ols_growth, "\n")

# Checkpoint 9
cat("Checkpoint 9 OK: diagnósticos reportados.\n")


# -----------------------------
# BLOCO 10 — OUTPUT FINAL
# -----------------------------

# 1. Resultado OLS
# 2. First stage
# 3. Reduced form
# 4. IV (2SLS)
# 5. Tabela comparativa

output_list <- list(
  model_ols = model_ols,
  results_ols = results_ols,
  model_fs = model_fs,
  fs_fstat = fs_fstat,
  model_rf = model_rf,
  model_iv = model_iv,
  comparison_table = comparison_table,
  robust_ols = ols_robust,
  robust_iv = iv_robust
)

saveRDS(output_list, file = file.path("outputs", "lab07_iv_results_2026-03-27.rds"))
write.csv(df_analysis, file = file.path("outputs", "dataset_limpo.csv"), row.names = FALSE)

cat("Checkpoint final OK: outputs organizados e salvos em outputs/.\n")
cat("=== FIM DO PIPELINE IV (LAB07) ===\n")
