# ==============================================================================
# 01-data-wrangling.R
# Verifiability — preparação e consolidação da base de dados
# Projeto: MAPP2026 - Replicação Freire (2018)
#
# Referência: Freire, D. (2018). Evaluating the Effect of Homicide Prevention
#   Strategies in São Paulo, Brazil: A Synthetic Control Approach.
#   Latin American Research Review, 53(2), 231–249.
#   https://doi.org/10.25222/larr.334
#
# INSTRUÇÕES:
#   Execute APÓS 00_setup_projeto.R.
#   Os dados brutos devem estar em data/raw/.
#   Saída principal: data/raw/df.csv (base em painel longo, 1990–2009).
# ==============================================================================

rm(list = ls())

# ==============================================================================
# FUNÇÕES UTILITÁRIAS
# ==============================================================================

# Detecta o arquivo em execução para localização automática da raiz do projeto.
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

# Retorna lista de diretórios ancestrais até max_depth níveis acima.
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

# Instala pacote se ausente e o carrega.
install_if_missing <- function(pkgs) {
  for (p in pkgs) {
    if (!requireNamespace(p, quietly = TRUE)) {
      message("Pacote ausente: ", p, ". Instalando via CRAN...")
      install.packages(p, repos = "https://cloud.r-project.org")
    }
    suppressPackageStartupMessages(library(p, character.only = TRUE))
  }
}

# Converte strings numéricas nos formatos BR (1.234,56) e EN (1234.56) para numeric.
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
# LOCALIZAÇÃO DA RAIZ DO PROJETO
# ==============================================================================

find_project_root_raw <- function() {
  this_file    <- find_current_file()
  start_dirs   <- c(getwd(),
                    if (!is.na(this_file)) dirname(this_file) else NA_character_)
  candidate_roots <- unique(unlist(lapply(na.omit(start_dirs), parents)))
  required <- file.path("data", "raw", "homicide-rates.csv")
  for (root in candidate_roots) {
    if (file.exists(file.path(root, required))) {
      return(normalizePath(root, winslash = "/", mustWork = TRUE))
    }
  }
  stop(
    "Raiz do projeto nao localizada.\n",
    "Esperado: data/raw/homicide-rates.csv\n",
    "Diretorio atual: ", getwd(), "\n",
    "Execute 00_setup_projeto.R primeiro, ou abra o .Rproj na raiz do repositorio."
  )
}

project_root <- find_project_root_raw()
setwd(project_root)
cat("Raiz do projeto:", getwd(), "\n")

# ==============================================================================
# VERIFICAÇÃO DE ARQUIVOS BRUTOS
# ==============================================================================

dir.create("data/raw",          recursive = TRUE, showWarnings = FALSE)
dir.create("output/figures",    recursive = TRUE, showWarnings = FALSE)
dir.create("output/tables",     recursive = TRUE, showWarnings = FALSE)

arquivos_necessarios <- c(
  "data/raw/homicide-rates.csv",
  "data/raw/state-gdp-capita.csv",
  "data/raw/state-gdp-growth-percentage.csv",
  "data/raw/gini.csv",
  "data/raw/population-projection.csv",
  "data/raw/population-extreme-poverty.csv",
  "data/raw/years-schooling.csv"
)

checagem_entrada <- data.frame(
  arquivo = arquivos_necessarios,
  existe  = file.exists(arquivos_necessarios),
  stringsAsFactors = FALSE
)
print(checagem_entrada)

if (any(!checagem_entrada$existe)) {
  stop(
    "Arquivos brutos ausentes em data/raw/. Execute 00_setup_projeto.R primeiro.\n",
    "Ausentes: ",
    paste(checagem_entrada$arquivo[!checagem_entrada$existe], collapse = ", ")
  )
}

# ==============================================================================
# FUNÇÕES DE LEITURA E REESTRUTURAÇÃO
# ==============================================================================

# Lê CSV no formato largo do IPEA/DATASUS (cabeçalho na linha 2, colunas de ano).
read_wide_csv <- function(path) {
  read.csv(
    path,
    header           = TRUE,
    skip             = 1,
    stringsAsFactors = FALSE,
    check.names      = TRUE,
    encoding         = "UTF-8"
  )
}

# Reestrutura de formato largo (Estado x Ano) para longo (Estado-Ano).
# Detecta automaticamente as colunas de ano pelo padrão numérico de 4 dígitos.
melt_years <- function(data, value_name) {
  id_vars    <- c("Sigla", "Código", "Estado")
  missing_id <- setdiff(id_vars, names(data))
  if (length(missing_id) > 0) {
    stop("Colunas identificadoras ausentes: ", paste(missing_id, collapse = ", "))
  }
  year_cols <- setdiff(names(data), id_vars)
  year_cols <- year_cols[grepl("\\d{4}", year_cols)]
  if (length(year_cols) == 0) {
    stop("Nenhuma coluna anual localizada em: ", value_name)
  }
  long <- data.frame(
    abbreviation = rep(data[["Sigla"]],   each  = length(year_cols)),
    code         = rep(data[["Código"]],  each  = length(year_cols)),
    state        = rep(data[["Estado"]],  each  = length(year_cols)),
    year         = rep(year_cols,         times = nrow(data)),
    value        = as.vector(t(data[year_cols])),
    stringsAsFactors = FALSE
  )
  long$year  <- as.numeric(gsub("\\D", "", long$year))
  long$value <- to_numeric_clean(long$value)
  names(long)[names(long) == "value"] <- value_name
  long
}

# ==============================================================================
# 1. LEITURA DAS VARIÁVEIS
# ==============================================================================

cat("\n--- Lendo arquivos brutos ---\n")

dep     <- read_wide_csv("data/raw/homicide-rates.csv")
dep.molten <- melt_years(dep, "homicide.rates")

ind1     <- read_wide_csv("data/raw/state-gdp-capita.csv")
ind1.molten <- melt_years(ind1, "state.gdp.capita")

ind2     <- read_wide_csv("data/raw/state-gdp-growth-percentage.csv")
ind2.molten <- melt_years(ind2, "state.gdp.growth.percent")

ind3     <- read_wide_csv("data/raw/gini.csv")
ind3.molten <- melt_years(ind3, "gini")

ind4     <- read_wide_csv("data/raw/population-projection.csv")
ind4.molten <- melt_years(ind4, "population.projection")

ind5     <- read_wide_csv("data/raw/population-extreme-poverty.csv")
ind5.molten <- melt_years(ind5, "population.extreme.poverty")

ind6     <- read_wide_csv("data/raw/years-schooling.csv")
ind6.molten <- melt_years(ind6, "years.schooling")

cat("  Todas as bases lidas com sucesso.\n")

# ==============================================================================
# 2. MERGE E SUBSET TEMPORAL (1990–2009)
# ==============================================================================

cat("\n--- Consolidando base em painel longo ---\n")

data.list <- list(
  dep.molten, ind1.molten, ind2.molten, ind3.molten,
  ind4.molten, ind5.molten, ind6.molten
)

data1 <- Reduce(
  function(x, y) merge(x, y,
                        by  = c("abbreviation", "code", "state", "year"),
                        all = TRUE),
  data.list
)

data2 <- subset(data1, year >= 1990 & year <= 2009)
data2 <- data2[order(data2$state, data2$year), ]
rownames(data2) <- NULL

# Garantir tipos numéricos em todas as variáveis exceto identificadores textuais
numeric_vars <- setdiff(names(data2), c("abbreviation", "state"))
for (v in numeric_vars) {
  data2[[v]] <- to_numeric_clean(data2[[v]])
}

cat("  Dimensao da base consolidada:", paste(dim(data2), collapse = " x "), "\n")

# ==============================================================================
# 3. DIAGNÓSTICO DE VALORES AUSENTES
# ==============================================================================

cat("\n--- Diagnóstico de valores ausentes ---\n")

missing_table <- data.frame(
  variavel    = names(data2),
  n_missing   = as.integer(sapply(data2, function(x) sum(is.na(x)))),
  prop_missing = round(sapply(data2, function(x) mean(is.na(x))), 4),
  row.names   = NULL
)
print(missing_table)

write.csv(missing_table, "output/tables/missing_diagnostics.csv", row.names = FALSE)
cat("  Tabela salva em output/tables/missing_diagnostics.csv\n")

# ==============================================================================
# 4. IMPUTAÇÃO LINEAR E TRANSFORMAÇÕES DE VARIÁVEIS
# ==============================================================================
# Replicação exata do procedimento de Freire (2018): interpolação linear (approx)
# para Gini, escolaridade e extrema pobreza, que têm ~15% de ausência na série
# histórica do IPEA. A imputação é aplicada à série global (não por estado),
# exatamente como no script original do autor.

cat("\n--- Imputações lineares e transformações ---\n")

linear_impute <- function(x) {
  x   <- to_numeric_clean(x)
  idx <- seq_along(x)
  ok  <- !is.na(x)
  if (sum(ok) == 0) return(x)
  if (sum(ok) == 1) { x[!ok] <- x[ok][1]; return(x) }
  approx(x = idx[ok], y = x[ok], xout = idx, method = "linear", rule = 2)$y
}

data2$gini.imp                      <- linear_impute(data2$gini)
data2$population.extreme.poverty.imp <- linear_impute(data2$population.extreme.poverty)
data2$years.schooling.imp           <- linear_impute(data2$years.schooling)

data2$proportion.extreme.poverty <-
  data2$population.extreme.poverty.imp / data2$population.projection

data2$population.projection.ln <- log(data2$population.projection)

cat("  Variaveis imputadas: gini.imp, population.extreme.poverty.imp, years.schooling.imp\n")
cat("  Variaveis derivadas: proportion.extreme.poverty, population.projection.ln\n")

# ==============================================================================
# 5. VERIFICAÇÃO DAS VARIÁVEIS FINAIS
# ==============================================================================

variaveis_modelo <- c(
  "abbreviation", "code", "state", "year",
  "homicide.rates", "state.gdp.capita", "state.gdp.growth.percent",
  "population.projection", "population.projection.ln",
  "years.schooling.imp", "proportion.extreme.poverty", "gini.imp"
)

faltantes <- setdiff(variaveis_modelo, names(data2))
if (length(faltantes) > 0) {
  stop("Variaveis finais ausentes: ", paste(faltantes, collapse = ", "))
}
cat("  Todas as variaveis do modelo verificadas.\n")

# ==============================================================================
# 6. SALVAMENTO DA BASE FINAL
# ==============================================================================

write.csv(data2, "df.csv",           row.names = FALSE)
write.csv(data2, "data/raw/df.csv",  row.names = FALSE)

cat("\n  Base final salva em:\n")
cat("    - df.csv\n")
cat("    - data/raw/df.csv\n")
cat("  Dimensao:", paste(dim(data2), collapse = " x "), "\n\n")

print(head(data2))

# Checagem final
checagem_saida <- data.frame(
  arquivo = c("df.csv", "data/raw/df.csv", "output/tables/missing_diagnostics.csv"),
  existe  = file.exists(c("df.csv", "data/raw/df.csv", "output/tables/missing_diagnostics.csv"))
)
print(checagem_saida)

# ==============================================================================
# 7. DOCUMENTAÇÃO DO AMBIENTE
# ==============================================================================

capture.output(sessionInfo(),
               file = "output/tables/sessionInfo_01_data_wrangling.txt")

cat("\n=================================================================\n")
cat("  01-data-wrangling concluido com sucesso.\n")
cat("  Proximo passo: 02-data-analysis.R\n")
cat("=================================================================\n")

sessionInfo()
