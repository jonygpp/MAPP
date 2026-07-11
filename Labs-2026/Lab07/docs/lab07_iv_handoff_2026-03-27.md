# Lab07 — Handoff da execução IV (2SLS)

**Data:** 2026-03-27  
**Tarefa:** Pipeline completo OLS/First Stage/Reduced Form/IV com checkpoints  
**Base usada:** `Data/mss_repdata.dta`

## 1) O que foi feito

- Implementado script reprodutível em R:
  - `R/lab07_iv_pipeline.R`
- Executado pipeline completo com checkpoints sequenciais.
- Gerados outputs finais e log de execução.

## 2) Mapeamento de variáveis (dataset original -> padrão do exercício)

- `war_prio` -> `conflict`
- `gdp_g` -> `growth`
- `GPCP_g` -> `rain`

## 3) Checkpoints

- Checkpoint 1: OK (dataset carregado; 743 observações)
- Checkpoint 2: OK (variáveis presentes; sem NA após limpeza)
- Checkpoint 3: OK (Y, D, Z definidos)
- Checkpoint 4: OK (OLS estimado; coeficiente de `growth` disponível)
- Checkpoint 5: OK (first stage estimado; F-stat calculado)
- Checkpoint 6: OK (reduced form estimado)
- Checkpoint 7: OK (IV estimado; coeficiente endógeno disponível)
- Checkpoint 8: OK (tabela comparativa gerada)
- Checkpoint 9: OK (diagnósticos reportados)

## 4) Outputs gerados

- `outputs/lab07_iv_results_2026-03-27.rds`
- `outputs/dataset_limpo.csv`
- `logs/lab07_iv_pipeline_2026-03-27.log`

## 5) Observações técnicas

- O pacote `lmtest` foi instalado no ambiente para viabilizar `coeftest`.
- O repositório não contém `.csv`; foi utilizada a base oficial `.dta`.
- Em `fixest`, o coeficiente IV da variável endógena aparece como `fit_growth`.
