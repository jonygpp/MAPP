---

---

# **Replicação: Evaluating the Effect of Homicide Prevention Strategies in São Paulo, Brazil** 

Este repositório contém o material de replicação para o artigo: "Evaluating the Effect of Homicide Prevention Strategies in São Paulo, Brazil: A Synthetic Control Approach", publicado por Danilo Freire na Latin American Research Review (2018).

Este trabalho foi desenvolvido como trabalho final (Desafio de Replicação) da disciplina de Monitoramento e Avaliação de Políticas Públicas (MAPP) do Programa de Mestrado da UFABC (2026).

## **Visão Geral**

O objetivo deste projeto é validar a reprodutibilidade dos resultados de Freire (2018), que utiliza o Método de Controle Sintético (SCM) para estimar o impacto de políticas de segurança pública na redução das taxas de homicídio no Estado de São Paulo entre 1999 e 2009.

## **Estrutura do Repositório**

O repositório está organizado para garantir reprodutibilidade, conforme as seguintes estruturas de diretórios:

- 00_setup_projeto.R: Script orquestrador que automatiza o ambiente computacional, baixando dados, corrigindo dependências e gerando a estrutura do projeto.

- /data/raw/ (contém as bases de dados originais utilizadas no modelo) • /scripts/ (contém os roteiros de replicação: Wrangling, Análise e Testes de Robustez)

- /output/figures/ (Armazena as visualizações geradas: gráficos de trajetória, gaps, placebos e leave-one-out).

  ## **Como Reproduzir (Guia de Execução):** 

Para reproduzir este estudo, siga a sequência abaixo:

i.  Pré-requisitos: Certifique-se de ter o R e o RStudio instalados.

ii. Setup Automatizado: Abra o arquivo 00_setup_projeto.R e execute-o. Ele irá preparar todo o ambiente, baixar os dados e corrigir automaticamente inconsistências de sintaxe dos scripts legados.

iii. Execução: Após o setup, execute os scripts na ordem: 01-data-wrangling.R, 02-data-analysis.R, 03-robustness-tests.R.

## **Auditoria Computacional e Ambiente** 

Com intuito de garantir a reprodutibilidade, este projeto utilizou o gerenciador de pacotes renv. O estado da sessão computacional utilizada nesta validação, incluindo as versões exatas de todas as dependências, está documentado no arquivo renv.lock e detalhado no Relatório de Verificabilidade (Marco T2).

(O Relatório de Verificabilidade completo encontra-se disponível em /docs/Relatorio_Verificabilidade_V1.docx.)

## sessionInfo()

R version 4.5.2 (2025-10-31 ucrt) Platform: x86_64-w64-mingw32/x64 Running under: Windows 11 x64 (build 26200)

Matrix products: default LAPACK version 3.12.1

locale: [1] LC_COLLATE=Portuguese_Brazil.utf8 LC_CTYPE=Portuguese_Brazil.utf8\
[3] LC_MONETARY=Portuguese_Brazil.utf8 LC_NUMERIC=C\
[5] LC_TIME=Portuguese_Brazil.utf8

attached base packages: [1] stats graphics grDevices datasets utils methods base

other attached packages: [1] Synth_1.1-10 reshape2_1.4.5 ggplot2_4.0.3 CausalImpact_1.4.1\
[5] bsts_0.9.11 xts_0.14.2 zoo_1.8-15 BoomSpikeSlab_1.2.7\
[9] Boom_0.9.16 Matching_4.10-15 MASS_7.3-65 MarketMatching_1.2.1 [13] dplyr_1.2.1

**Este projeto foi licenciado sob a licença MIT.**
