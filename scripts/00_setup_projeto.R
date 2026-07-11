y# ==============================================================================
# 00_setup_projeto.R
# Setup automático do ambiente de replicação
# Projeto: MAPP2026 - Desafio de Replicação (Freire, 2018)
#
# INSTRUÇÕES:
#   1. Abra este arquivo no RStudio com o projeto (.Rproj) ativo, OU
#      execute a partir da pasta raiz do repositório.
#   2. Execute o script inteiro (Ctrl+Shift+Enter ou Rscript 00_setup_projeto.R).
#   3. Após a conclusão, execute os scripts 01, 02 e 03 em sequência.
#
# O que este script faz:
#   - Instala e isola pacotes via renv
#   - Baixa o repositório original de Freire (2018) do GitHub
#   - Cria a estrutura de pastas do projeto
#   - Copia os dados brutos e scripts originais para os devidos diretórios
#   - NÃO altera os scripts originais (as correções estão nos scripts _corrigido)
# ==============================================================================

# ------------------------------------------------------------------------------
# 0. LIMPEZA SELETIVA DO AMBIENTE
# Apaga apenas outputs gerados anteriormente, preserva dados já baixados.
# ------------------------------------------------------------------------------
message("[ 0/6 ] Preparando ambiente...")

pastas_output <- c("output")
for (pasta in pastas_output) {
  if (dir.exists(pasta)) {
    unlink(pasta, recursive = TRUE)
    message("  Pasta removida: ", pasta)
  }
}

rm(list = ls())

# ------------------------------------------------------------------------------
# 1. GERENCIAMENTO DO AMBIENTE COM renv
# Isola as bibliotecas do projeto para garantir reprodutibilidade futura.
# Se o renv.lock já existir (replicação em nova máquina), usa renv::restore().
# ------------------------------------------------------------------------------
message("[ 1/6 ] Configurando ambiente renv...")

if (!requireNamespace("renv", quietly = TRUE)) {
  install.packages("renv", repos = "https://cloud.r-project.org")
}

if (file.exists("renv.lock")) {
  message("  renv.lock encontrado. Restaurando ambiente existente...")
  renv::restore(prompt = FALSE)
} else {
  message("  Primeiro uso. Inicializando renv e instalando pacotes...")
  renv::init(bare = TRUE, restart = FALSE)

  pacotes_necessarios <- c(
    "Synth",
    "reshape2",
    "dplyr",
    "ggplot2",
    "CausalImpact",
    "Matching",
    "MarketMatching"
  )

  for (pkg in pacotes_necessarios) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      message("  Instalando: ", pkg)
      install.packages(pkg, repos = "https://cloud.r-project.org")
    } else {
      message("  Já instalado: ", pkg)
    }
  }

  renv::snapshot(prompt = FALSE)
  message("  renv.lock gerado com sucesso.")
}

# ------------------------------------------------------------------------------
# 2. ESTRUTURA DE PASTAS
# ------------------------------------------------------------------------------
message("[ 2/6 ] Criando estrutura de pastas...")

pastas_projeto <- c(
  "data/raw",
  "data/processed",
  "scripts/originais",
  "output/figures",
  "output/tables"
)

for (pasta in pastas_projeto) {
  dir.create(pasta, recursive = TRUE, showWarnings = FALSE)
}

message("  Pastas criadas: ", paste(pastas_projeto, collapse = ", "))

# ------------------------------------------------------------------------------
# 3. DOWNLOAD DO REPOSITÓRIO ORIGINAL
# Fonte: https://github.com/danilofreire/homicides-sp-synth
# Baixa apenas se os dados brutos ainda não existirem (evita downloads repetidos).
# ------------------------------------------------------------------------------
message("[ 3/6 ] Verificando dados brutos...")

arquivos_esperados <- c(
  "data/raw/homicide-rates.csv",
  "data/raw/state-gdp-capita.csv",
  "data/raw/state-gdp-growth-percentage.csv",
  "data/raw/gini.csv",
  "data/raw/population-projection.csv",
  "data/raw/population-extreme-poverty.csv",
  "data/raw/years-schooling.csv"
)

dados_presentes <- all(file.exists(arquivos_esperados))

if (dados_presentes) {
  message("  Dados brutos já presentes em data/raw/. Download ignorado.")
} else {
  message("  Baixando repositório de Freire (2018)...")

  url_repositorio <- "https://github.com/danilofreire/homicides-sp-synth/archive/refs/heads/master.zip"
  zip_temp       <- tempfile(fileext = ".zip")
  dir_temp       <- tempfile()

  dir.create(dir_temp, recursive = TRUE)

  tryCatch({
    download.file(url_repositorio, destfile = zip_temp, mode = "wb", quiet = FALSE)
    message("  Download concluído. Extraindo arquivos...")
    unzip(zip_temp, exdir = dir_temp)
  }, error = function(e) {
    stop(
      "Falha no download do repositório.\n",
      "Verifique a conexão com a internet e tente novamente.\n",
      "URL: ", url_repositorio, "\n",
      "Erro: ", conditionMessage(e)
    )
  })

  # --------------------------------------------------------------------------
  # 4. CÓPIA DOS ARQUIVOS EXTRAÍDOS
  # --------------------------------------------------------------------------
  message("[ 4/6 ] Copiando arquivos para a estrutura do projeto...")

  # Dados brutos (CSV, DTA, RData, xlsx)
  arquivos_dados <- list.files(
    dir_temp,
    pattern     = "\\.(csv|dta|RData|rda|xlsx)$",
    ignore.case = TRUE,
    recursive   = TRUE,
    full.names  = TRUE
  )

  if (length(arquivos_dados) == 0) {
    stop("Nenhum arquivo de dados foi encontrado no repositório baixado.")
  }

  resultados_dados <- file.copy(arquivos_dados, "data/raw/", overwrite = TRUE)
  message("  ", sum(resultados_dados), " arquivo(s) de dados copiado(s) para data/raw/")

  # Scripts originais (R, Rmd) — preservados em scripts/originais/ sem modificação
  arquivos_codigo <- list.files(
    dir_temp,
    pattern   = "\\.(R|r|Rmd|Rnw)$",
    recursive = TRUE,
    full.names = TRUE
  )

  if (length(arquivos_codigo) > 0) {
    resultados_codigo <- file.copy(arquivos_codigo, "scripts/originais/", overwrite = TRUE)
    message("  ", sum(resultados_codigo), " script(s) original(is) copiado(s) para scripts/originais/")
  }

  # Limpeza dos temporários
  unlink(zip_temp)
  unlink(dir_temp, recursive = TRUE)
  message("  Arquivos temporários removidos.")
}

# ------------------------------------------------------------------------------
# 5. VERIFICAÇÃO FINAL DOS ARQUIVOS NECESSÁRIOS
# ------------------------------------------------------------------------------
message("[ 5/6 ] Verificando integridade dos dados brutos...")

checagem <- data.frame(
  arquivo = arquivos_esperados,
  existe  = file.exists(arquivos_esperados),
  stringsAsFactors = FALSE
)

print(checagem)

if (any(!checagem$existe)) {
  stop(
    "Os seguintes arquivos brutos estão ausentes após o setup:\n",
    paste("  -", checagem$arquivo[!checagem$existe], collapse = "\n"),
    "\n\nVerifique se o download foi concluído ou adicione os arquivos manualmente em data/raw/."
  )
}

message("  Todos os arquivos brutos verificados com sucesso.")

# ------------------------------------------------------------------------------
# 6. DOCUMENTAÇÃO DO AMBIENTE
# ------------------------------------------------------------------------------
message("[ 6/6 ] Documentando ambiente computacional...")

dir.create("output/tables", recursive = TRUE, showWarnings = FALSE)

capture.output(
  sessionInfo(),
  file = "output/tables/sessionInfo_00_setup.txt"
)

# ------------------------------------------------------------------------------
# CONCLUSÃO
# ------------------------------------------------------------------------------
message("")
message("=================================================================")
message("  SETUP CONCLUIDO COM SUCESSO")
message("=================================================================")
message("  Proximo passo: execute os scripts na seguinte ordem:")
message("    1. 01-data-wrangling.R")
message("    2. 02-data-analysis.R")
message("    3. 03-robustness_tests.R")
message("=================================================================")
