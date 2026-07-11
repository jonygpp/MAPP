# MAPP2026-Lab07 — Replicação didática MSS (2004)

## O que é este projeto

Este repositório implementa, em etapas, um laboratório de replicação didática baseado em Miguel, Satyanath e Sergenti (2004).

A pergunta empírica central é como choques econômicos, com foco em crescimento, se relacionam com conflito civil em painel país-ano africano.

## Para que serve

- Apoiar o ensino de métodos quantitativos e inferência causal no curso MAPP.
- Treinar leitura de especificações empíricas, construção de amostras e interpretação de resultados.
- Diferenciar explicitamente associação, tratada aqui pelo benchmark OLS, de interpretação causal, tratada pela estratégia IV.

## Status do projeto

- Fase 3A: concluída.
- Fase 3B: concluída.
- Fase 3C: concluída.
- Fase 3D: concluída.
- Fase 3E: concluída.
- **Laboratório empírico finalizado.**
- Nova fase de produção pedagógica, integrador em Quarto: aberta.
- Subfase 1, arquitetura técnica e editorial do integrador: concluída.
- Subfase 2, preenchimento didático do integrador com leitura de outputs validados: concluída.
- Subfase 3, refinamento editorial, gráficos didáticos e renderização HTML do integrador: concluída.
- Subfase 4, consolidação didática focal dos Blocos 3, 4 e 5 do integrador: concluída.
- Subfase 5, consolidação didática do Bloco 6 e da Síntese final do integrador: concluída.

## Estrutura do repositório

- `Data/`: base canônica e arquivos de replicação, incluindo `mss_repdata_feb07.dta`.
- `outputs/`: tabelas, objetos e diagnósticos gerados por fase.
- `docs/`: artefatos `.Rmd`, `.qmd`, `.html` e handoffs por fase.
- `R/`: scripts auxiliares de renderização e execução por fase.

## Como usar / como executar

### Pré-requisitos

Em R:

- `dplyr`
- `readr`
- `tidyr`
- `tibble`
- `stringr`
- `purrr`
- `fixest`
- `broom`
- `haven`
- `fs`
- `rmarkdown`
- `knitr`

### Ferramentas de publicação e execução

- Quarto CLI instalado e disponível no sistema.
- Ambiente configurado para execução de documentos Quarto com R.

### Artefato principal da fase pedagógica em curso

- `docs/lab07_integrador_alunos_v1.qmd`

### Output principal da fase pedagógica em curso

- `docs/lab07_integrador_alunos_v1.html`

### Renderização recomendada do integrador

Executar, a partir da raiz do projeto:

```bash
quarto render docs/lab07_integrador_alunos_v1.qmd --to html
```

### Artefato principal da fase empírica já finalizada

- `docs/lab07_phase3e.Rmd`

## Principais arquivos e outputs

### Artefatos estruturantes do pipeline empírico

- `docs/lab07_phase3a.Rmd`
- `docs/lab07_phase3b.Rmd`
- `docs/lab07_phase3c.Rmd`
- `docs/lab07_phase3d.Rmd`
- `docs/lab07_phase3e.Rmd`

### Artefatos estruturantes da fase pedagógica

- `docs/lab07_integrador_alunos_v1.qmd`
- `docs/lab07_integrador_alunos_v1.html`

### Outputs centrais da Fase 3D

- `outputs/lab07_phase3d_consistency_check.csv`
- `outputs/lab07_phase3d_first_stage_tidy.csv`
- `outputs/lab07_phase3d_first_stage_diagnostics.csv`
- `outputs/lab07_phase3d_reduced_form_tidy.csv`
- `outputs/lab07_phase3d_iv_main_tidy.csv`
- `outputs/lab07_phase3d_models_comparison_tidy.csv`
- `outputs/lab07_phase3d_models_comparison_table.txt`

### Outputs centrais da Fase 3E

- `outputs/lab07_phase3e_prerequisites_check.csv`
- `outputs/lab07_phase3e_consistency_check.csv`
- `outputs/lab07_phase3e_narrow_availability.csv`
- `outputs/lab07_phase3e_warprio_ols_simple.csv`
- `outputs/lab07_phase3e_warprio_ols_full.csv`
- `outputs/lab07_phase3e_warprio_rf.csv`
- `outputs/lab07_phase3e_warprio_iv.csv`
- `outputs/lab07_phase3e_iv_narrow.csv`
- `outputs/lab07_phase3e_final_models_comparison.csv`
- `outputs/lab07_phase3e_final_key_coefs_wide.csv`
- `outputs/lab07_phase3e_final_models_table.txt`
- `outputs/lab07_phase3e_iv_models_etable.txt`

### Outputs e insumos importantes de fases anteriores

- `outputs/lab07_phase3b_df_main.rds`
- `outputs/lab07_phase3c_consistency_check.csv`
- `outputs/lab07_phase3c_ols_simple_tidy.csv`
- `outputs/lab07_phase3c_ols_full_tidy.csv`
- `outputs/lab07_phase3c_ols_comparison_tidy.csv`
- `outputs/lab07_phase3c_ols_comparison_table.txt`

## Pontos de contato / manutenção

- Responsável acadêmico: Prof. Ricardo Ceneviva.
- Fluxo operacional implementado com apoio de Agente de IA executor, seguindo `AGENTS.md` e `Workflow-Projeto.md`.

## Documentação adicional

### Handoffs do pipeline empírico

- `docs/lab07_phase3a_handoff_2026-03-27.md`
- `docs/lab07_phase3b_handoff_2026-03-27.md`
- `docs/lab07_phase3c_handoff_2026-03-27.md`
- `docs/lab07_phase3d_handoff_2026-03-27.md`
- `docs/lab07_phase3e_handoff_2026-03-27.md`

### Handoffs da fase pedagógica do integrador

- `docs/lab07_integrador_subfase1_handoff_2026-03-30.md`
- `docs/lab07_integrador_subfase2_handoff_2026-03-30.md`
- `docs/lab07_integrador_subfase3_handoff_2026-03-30.md`
- `docs/lab07_integrador_subfase4_handoff_2026-03-30.md`
- `docs/lab07_integrador_subfase5_handoff_2026-03-30.md`

### Arquivos auxiliares relevantes

- `outputs/lab07_phase3a_variable_mapping.csv`
- `outputs/lab07_phase3b_name_standardization.csv`
- `outputs/lab07_phase3b_variable_classification.csv`
- `docs/files_list.md`

## Nova fase pedagógica — integrador para alunos em Quarto

- Arquivo-fonte canônico: `docs/lab07_integrador_alunos_v1.qmd`
- Output principal canônico: `docs/lab07_integrador_alunos_v1.html`

## Metodologia

- Benchmarks OLS foram implementados na Fase 3C, com interpretação associativa.
- Na Fase 3D, foram implementados first stage, reduced form e IV/2SLS principal com `fixest`.
- Na Fase 3E, foi implementada a robustez com `war_prio`, incluindo OLS simples, OLS ampliado, reduced form e IV.
- Extensões narrow, `any_prio_nar` e `war_prio_nar`, também foram estimadas.
- A fase pedagógica posterior não reestima modelos. Ela integra e documenta resultados já validados.

## Histórico de atualizações

- 2026-03-27 — Fase 3A: auditoria de arquivos, ingestão da base canônica e mapeamento inicial de variáveis.
- 2026-03-27 — Fase 3B: validação de integridade, padronização controlada, construção de `df_main` e descritivas mínimas.
- 2026-03-27 — Fase 3C: validação de consistência com a 3B, estimação dos benchmarks OLS, comparação OLS e atualização do README. IV permaneceu para a Fase 3D.
- 2026-03-27 — Fase 3D: validação de consistência com 3B/3C, estimação de first stage, reduced form e IV/2SLS principal, diagnóstico explícito de first stage, comparação OLS vs IV e atualização incremental do README.
- 2026-03-27 — Fase 3E: robustez com `war_prio`, extensões narrow, comparação final consolidada, interpretação causal integrada, conclusões do laboratório e atualização final do README. Laboratório empírico finalizado.
- 2026-03-30 — Nova fase de produção pedagógica iniciada. Subfase 1 concluída com criação do esqueleto do integrador em Quarto e registro técnico em handoff próprio.
- 2026-03-30 — Subfase 2 concluída com preenchimento didático de `docs/lab07_integrador_alunos_v1.qmd`, usando apenas leitura de outputs já validados, sem reestimação e sem sobrescrita em `outputs/`.
- 2026-03-30 — Subfase 3 concluída com refinamento editorial do integrador, inclusão de gráficos didáticos gerados apenas por leitura de outputs existentes e renderização de `docs/lab07_integrador_alunos_v1.html`.
- 2026-03-30 — Subfase 4 concluída: consolidação didática focal dos Blocos 3, 4 e 5 do integrador. Cada bloco recebeu texto pedagógico expandido, pelo menos uma tabela adicional formatada, pelo menos um gráfico derivado de outputs existentes e checkpoint conceitual ampliado. Nenhum modelo foi reestimado. Handoff em `docs/lab07_integrador_subfase4_handoff_2026-03-30.md`.
- 2026-03-30 — Subfase 5 concluída: consolidação didática do Bloco 6 e da Síntese final, com integração crítica entre OLS, reduced form e IV, ampliação de checkpoints, inclusão de perguntas de revisão e fechamento didático do documento. Nenhum modelo foi reestimado. Handoff em `docs/lab07_integrador_subfase5_handoff_2026-03-30.md`.
