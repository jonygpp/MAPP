# ==============================================================================
# PROJETO: MAPP2026 - Desafio de Replicação (Relatório T2: Verifiability)
# OBJETIVO: Setup automático 
# ==============================================================================

# ------------------------------------------------------------------------------
# 0. LIMPEZA TOTAL (RESET DO AMBIENTE)
# ------------------------------------------------------------------------------
message("Limpando ficheiros antigos para garantir a integridade da replicação...")

# Remove as pastas de dados e output se existirem
pastas_para_apagar <- c("data", "output", "scripts")
for (pasta in pastas_para_apagar) {
  if (dir.exists(pasta)) {
    unlink(pasta, recursive = TRUE)
  }
}
# Nota: Também limpamos o ambiente de trabalho (variáveis na memória)
rm(list = ls())


# 1. GERENCIAMENTO DO AMBIENTE (renv)
if (!requireNamespace("renv", quietly = TRUE)) install.packages("renv")
renv::init(bare = TRUE, restart = FALSE)
pacotes_necessarios <- c("Synth", "reshape2", "foreign", "readr", "dplyr", "CausalImpact", "Matching", "MarketMatching", "ggplot2")
install.packages(pacotes_necessarios)
renv::snapshot(prompt = FALSE)

# 2. ESTRUTURA DE PASTAS
pastas_projeto <- c("data/raw", "data/processed", "scripts", "output/figures", "output/tables")
for (pasta in pastas_projeto) { dir.create(pasta, recursive = TRUE, showWarnings = FALSE) }

# 3. DOWNLOAD E EXTRAÇÃO
url_repositorio <- "https://github.com/danilofreire/homicides-sp-synth/archive/refs/heads/master.zip"
zip_temp <- tempfile(fileext = ".zip")
dir_temp <- tempfile()
dir.create(dir_temp)
download.file(url_repositorio, destfile = zip_temp, mode = "wb", quiet = TRUE)
unzip(zip_temp, exdir = dir_temp)

# 4. SEPARAÇÃO E EXTRAÇÃO
arquivos_codigo <- list.files(dir_temp, pattern = "\\.(R|r|Rmd|Rnw)$", recursive = TRUE, full.names = TRUE)
arquivos_dados <- list.files(dir_temp, pattern = "\\.(csv|dta|RData|rda|xlsx)$", ignore.case = TRUE, recursive = TRUE, full.names = TRUE)
file.copy(arquivos_codigo, "scripts/", overwrite = TRUE)
file.copy(arquivos_dados, "data/raw/", overwrite = TRUE)


# ------------------------------------------------------------------------------
# 5. EDIÇÃO AUTOMÁTICA (CAMINHOS, GRÁFICOS, BIBLIOTECAS, CONFLITOS E CORREÇÕES)
# ------------------------------------------------------------------------------
message("Ajustando caminhos, corrigindo blocos de plotagem e injetando dependências...")

scripts_extraidos <- list.files("scripts/", full.names = TRUE)
bibliotecas_essenciais <- c("ggplot2", "CausalImpact", "Matching", "MarketMatching", "dplyr")

for (script in scripts_extraidos) {
  linhas <- readLines(script, warn = FALSE)
  
  # 5.1 Corrigir sintaxe errada (duplo +)
  linhas <- gsub('\\+\\+', '\\+', linhas) 
  
  # 5.2 Ajuste de leitura de dados
  linhas <- gsub('read\\.csv\\(\\s*["\']([^/]+\\.csv)["\']', 'read.csv("data/raw/\\1"', linhas)
  
  # 5.3 Ajuste de caminhos para exportação (EPS)
  linhas <- gsub('file\\s*=\\s*["\'](.*)\\.eps["\']', 'file = "output/figures/\\1.eps"', linhas)
  
  # 5.4 Automacao para plot (Substitui o bloco com erro pelo bloco corrigido que voce enviou)
  # Usamos uma regex que captura o bloco que estava dando erro
  padrao_plot <- "results\\$PlotActualVersusExpected\\s*\\+\\s*ggtitle\\(.*\\)\\s*\\+\\s*theme_bw\\(\\)\\s*\\+\\s*geom_line\\(aes\\(.*\\),colour=.*\\)"
  
  substituicao_plot <- paste0(
    "dados_plot <- results$PlotActualVersusExpected$data\n",
    "dados_plot$test_market <- as.numeric(as.character(dados_plot$test_market))\n",
    "ggplot(data = dados_plot, aes(x = 1:nrow(dados_plot), y = test_market)) +\n",
    "  geom_line(colour='#000099') +\n",
    "  ggtitle('São Paulo versus Synthetic São Paulo') + \n",
    "  theme_bw()"
  )
  
  # Aplicar a substituição (lendo o arquivo como uma única string para facilitar a troca do bloco)
  texto_script <- paste(linhas, collapse = "\n")
  texto_script <- gsub(padrao_plot, substituicao_plot, texto_script)
  linhas <- strsplit(texto_script, "\n")[[1]]
  
  # 5.5 Injeção de bibliotecas
  for (bib in bibliotecas_essenciais) {
    if (!any(grepl(paste0("library\\(", bib, "\\)"), linhas))) {
      linhas <- c(paste0("library(", bib, ")"), linhas)
    }
  }
  
  # 5.6 Neutralização do rm(list=ls())
  linhas <- gsub('rm\\s*\\(\\s*list\\s*=\\s*ls\\(\\s*\\)\\s*\\)', 
                 '# rm(list = ls()) # Comentado automaticamente (MAPP)', linhas)
  
  # 5.7 Correção do conflito dplyr::select
  linhas <- gsub('select\\(', 'dplyr::select\\(', linhas)
  
  writeLines(linhas, script)
}

# 6. LIMPEZA
unlink(zip_temp)
unlink(dir_temp, recursive = TRUE)

message("===================================================================")
message("✅ SETUP CONCLUÍDO! Gráficos serão salvos como EPS e PNG.")
message("===================================================================")