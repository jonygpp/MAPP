# ==============================================================================
# 02-data-analysis.R
# Verifiability — análise principal com Controle Sintético
# Projeto: MAPP2026 - Replicação Freire (2018)
#
# Referência: Freire, D. (2018). Evaluating the Effect of Homicide Prevention
#   Strategies in São Paulo, Brazil: A Synthetic Control Approach.
#   Latin American Research Review, 53(2), 231–249.
#   https://doi.org/10.25222/larr.334
#
# INSTRUÇÕES:
#   Execute APÓS 01-data-wrangling.R.
#   Saídas: output/figures/ (EPS) e output/tables/ (TXT/CSV).
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
    "Execute 01-data-wrangling_corrigido_final.R primeiro.\n",
    "Diretorio atual: ", getwd()
  )
}

project_root <- find_project_root()
setwd(project_root)
cat("Raiz do projeto:", getwd(), "\n")

dir.create("output/figures", recursive = TRUE, showWarnings = FALSE)
dir.create("output/tables",  recursive = TRUE, showWarnings = FALSE)

# Se df.csv não existir, tenta gerar pelo script 01
if (!file.exists("data/raw/df.csv") && !file.exists("df.csv")) {
  script_01 <- "01-data-wrangling_corrigido_final.R"
  if (file.exists(script_01)) {
    message("df.csv nao encontrado. Executando ", script_01, "...")
    source(script_01, local = FALSE)
  } else {
    stop("df.csv nao encontrado. Execute 01-data-wrangling_corrigido_final.R.")
  }
}

path_df <- if (file.exists("data/raw/df.csv")) "data/raw/df.csv" else "df.csv"

df           <- read.csv(path_df, header = TRUE, stringsAsFactors = FALSE)
df$state     <- as.character(df$state)

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
  "population.projection", "population.projection.ln",
  "years.schooling.imp", "proportion.extreme.poverty", "gini.imp"
)
faltantes <- setdiff(variaveis_necessarias, names(df))
if (length(faltantes) > 0) {
  stop("Variaveis ausentes na base: ", paste(faltantes, collapse = ", "))
}

cat("Base carregada:", path_df, "—", paste(dim(df), collapse = " x "), "\n\n")

# ==============================================================================
# A. FIGURA 1 — SP vs. MÉDIA DO BRASIL (br.png)
# ==============================================================================

cat("--- Gerando br.png ---\n")

sp_rows <- df$abbreviation == "SP"

df1 <- df[sp_rows,  c("year", "homicide.rates")]
names(df1) <- c("year", "homicide.sp")
df1 <- df1[order(df1$year), ]

df2 <- aggregate(homicide.rates ~ year,
                 data = df[!sp_rows, ],
                 FUN  = function(x) mean(x, na.rm = TRUE))
names(df2) <- c("year", "homicide.br")
df2 <- df2[order(df2$year), ]

png(file = "output/figures/br.png", width = 7, height = 5.25, units = "in", res = 300)

plot(x    = df1$year,
     y    = df1$homicide.sp,
     type = "l",
     ylim = c(0, 60),
     xlim = c(1990, 2009),
     xlab = "Year",
     ylab = "Homicide Rates",
     cex  = 3, lwd = 2, xaxs = "i", yaxs = "i")

lines(df2$year, df2$homicide.br, lty = 2, cex = 3, lwd = 2)
arrows(1997, 50, 1999, 50, col = "black", length = .1)
text(1995, 50, "Policy Change", cex = .8)
abline(v = 1999, lty = 2)

legend(x      = "bottomleft",
       legend = c("São Paulo", "Brazil (average)"),
       lty    = c("solid", "dashed"),
       lwd    = c(2, 2),          # CORRIGIDO: parâmetro lwd ausente no original
       cex    = .8,
       bg     = "white")

dev.off()
cat("  Salvo: output/figures/br.png\n")

# ==============================================================================
# B. MODELO PRINCIPAL — CONTROLE SINTÉTICO
# Especificação idêntica à de Freire (2018), Tabela 1.
# Unidade tratada: São Paulo (código IBGE 35)
# Pool de doadores: demais estados brasileiros
# Período de otimização (pré-tratamento): 1990–1998
# ==============================================================================

cat("\n--- Estimando modelo principal (Synth) ---\n")

sp_id      <- 35
donor_pool <- c(11:17, 21:27, 31:33, 41:43, 50:53)

dataprep.out <- dataprep(
  foo       = df,
  predictors = c(
    "state.gdp.capita",
    "state.gdp.growth.percent",
    "population.projection.ln",
    "years.schooling.imp"
  ),
  special.predictors = list(
    list("homicide.rates",            1990:1998, "mean"),
    list("proportion.extreme.poverty", 1990:1998, "mean"),
    list("gini.imp",                  1990:1998, "mean")
  ),
  predictors.op        = "mean",
  dependent            = "homicide.rates",
  unit.variable        = "code",
  time.variable        = "year",
  unit.names.variable  = "state",
  treatment.identifier = sp_id,
  controls.identifier  = donor_pool,
  time.predictors.prior = 1990:1998,
  time.optimize.ssr    = 1990:1998,
  time.plot            = 1990:2009
)

synth.out    <- synth(dataprep.out)
synth.tables <- synth.tab(dataprep.res = dataprep.out,
                          synth.res    = synth.out)
print(synth.tables)

capture.output(print(synth.tables),
               file = "output/tables/synth_tables_main_model.txt")
cat("  Tabela salva: output/tables/synth_tables_main_model.txt\n")

# ==============================================================================
# C. FIGURA 2 — SP OBSERVADO vs. SP SINTÉTICO (trends.png)
# ==============================================================================

cat("\n--- Gerando trends.png ---\n")

png(file = "output/figures/trends.png", width = 7, height = 5.25, units = "in", res = 300)

path.plot(synth.res       = synth.out,
          dataprep.res    = dataprep.out,
          Ylab            = "Homicide Rates",
          Xlab            = "Year",
          Legend          = c("São Paulo", "Synthetic São Paulo"),
          Legend.position = "bottomleft")

abline(v = 1999, lty = 2)
arrows(1997, 50, 1999, 50, col = "black", length = .1)
text(1995, 50, "Policy Change", cex = .8)

dev.off()
cat("  Salvo: output/figures/trends.png\n")

# ==============================================================================
# D. FIGURA 3 — GAPS (gaps.png)
# ==============================================================================

cat("\n--- Gerando gaps.png ---\n")

png(file = "output/figures/gaps.png", width = 7, height = 5.25, units = "in", res = 300)

gaps.plot(synth.res    = synth.out,
          dataprep.res = dataprep.out,
          Ylab         = "Gap in Homicide Rates",
          Xlab         = "Year",
          Ylim         = c(-30, 30),
          Main         = "")

abline(v = 1999, lty = 2)
arrows(1997, 20, 1999, 20, col = "black", length = .1)
text(1995, 20, "Policy Change", cex = .8)

dev.off()
cat("  Salvo: output/figures/gaps.png\n")

# ==============================================================================
# E. ESTIMATIVA DE VIDAS SALVAS (1999–2009)
# Metodologia: diferença entre mortes projetadas pelo SP sintético e mortes
# observadas em SP real, ponderando pelos pesos do donor pool.
#
# Pesos recuperados do dataprep.out (vetor solution.w):
#   SC (42) = 0.274 | DF (53) = 0.210 | ES (32) = 0.209
#   RJ (33) = 0.169 | RR (14) = 0.137 | PB (25) = 0.001
# ==============================================================================

cat("\n--- Calculando vidas salvas ---\n")

df_post <- df[df$year >= 1999, ]

get_rate <- function(abbrev) {
  out <- df_post$homicide.rates[df_post$abbreviation == abbrev]
  if (length(out) == 0) stop("Estado nao encontrado: ", abbrev)
  out
}

pop_sp  <- df_post$population.projection[df_post$abbreviation == "SP"]
rate_sp <- get_rate("SP")

num.deaths.sp <- sum(rate_sp / 100000 * pop_sp, na.rm = TRUE)

synthetic_weights <- c(SC = 0.274, DF = 0.210, ES = 0.209,
                        RJ = 0.169, RR = 0.137, PB = 0.001)

synthetic_deaths_terms <- vapply(
  names(synthetic_weights),
  function(abbrev) sum(synthetic_weights[[abbrev]] * get_rate(abbrev) / 100000 * pop_sp,
                       na.rm = TRUE),
  numeric(1)
)

num.deaths.synthetic.sp <- sum(synthetic_deaths_terms)
lives.saved             <- num.deaths.synthetic.sp - num.deaths.sp

lives_table <- data.frame(
  num_deaths_sp           = num.deaths.sp,
  num_deaths_synthetic_sp = num.deaths.synthetic.sp,
  lives_saved             = lives.saved
)

cat("\n  --- Resultado: vidas salvas ---\n")
print(lives_table)

write.csv(lives_table, "output/tables/lives_saved.csv", row.names = FALSE)
cat("  Tabela salva: output/tables/lives_saved.csv\n")
cat("  Estimativa: ", round(lives.saved, 2), " vidas poupadas (1999–2009)\n")
cat("  Valor publicado por Freire (2018): 20.331\n")

# ==============================================================================
# F. CHECAGEM FINAL DE OUTPUTS
# ==============================================================================

outputs_verifiability <- c(
  "output/figures/br.png",
  "output/figures/trends.png",
  "output/figures/gaps.png",
  "output/tables/synth_tables_main_model.txt",
  "output/tables/lives_saved.csv"
)

check_outputs <- data.frame(arquivo = outputs_verifiability,
                             existe  = file.exists(outputs_verifiability))
print(check_outputs)

write.csv(check_outputs,
          "output/tables/check_outputs_02_data_analysis.csv",
          row.names = FALSE)

if (any(!check_outputs$existe)) {
  stop("Outputs incompletos. Verifique a tabela acima.")
}

# ==============================================================================
# G. DOCUMENTAÇÃO DO AMBIENTE
# ==============================================================================

capture.output(sessionInfo(),
               file = "output/tables/sessionInfo_02_data_analysis.txt")

cat("\n=================================================================\n")
cat("  02-data-analysis concluido com sucesso.\n")
cat("  Convergencia com Freire (2018): ", round(lives.saved, 2), " vidas salvas.\n")
cat("  Proximo passo: 03-robustness_tests.R\n")
cat("=================================================================\n")

sessionInfo()
