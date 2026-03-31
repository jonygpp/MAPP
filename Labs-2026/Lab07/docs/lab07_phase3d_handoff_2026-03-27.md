# Handoff — Fase 3D (Lab07)

## 1) O que foi feito

- Validação explícita de consistência com as Fases 3B e 3C.
- Estimação do IV principal (`mod_iv_main`) com recuperação de estágios.
- Estimação e documentação da reduced form principal (`mod_rf_main`).
- Geração de diagnóstico de first stage com F-stat explícita.
- Construção de comparação legível entre OLS, reduced form e IV.
- Atualização incremental e preservativa do `README.md`.

## 2) O que foi validado

- **Checkpoint D1:** consistência com amostra e convenções das Fases 3B/3C.
- **Checkpoint D2:** IV principal estimado sem erro e estágios recuperáveis.
- **Checkpoint D3:** first stage documentado com F-stat explícita.
- **Checkpoint D4:** reduced form estimada sem erro e registrada.
- **Checkpoint D5:** comparação OLS vs IV gerada em arquivos legíveis.
- **Checkpoint D6:** README.md atualizado e logado.

## 3) Especificação IV efetivamente estimada

- `any_prio ~ y_0 + polity2l + ethfrac + relfrac + oil + lmtnest + lpopl1 | ccode[year_trend] | gdp_g + gdp_g_l ~ gpcp_g + gpcp_g_l`, com cluster por `ccode`.
- Variáveis removidas por colinearidade no IV principal: y_0, ethfrac, relfrac, lmtnest.

## 4) Diagnósticos de first stage (F-stat)

- gdp_g: F = 6.399, p = 0.00176.
- gdp_g_l: F = 5.138, p = 0.00609.
- Interpretação: regra de bolso F>10 não é critério mecânico; leitura conjunta com hipótese de exclusão permanece necessária.

## 5) Interpretação causal

- OLS foi mantido como benchmark associativo.
- IV foi interpretado como identificação via variação exógena induzida pelos instrumentos climáticos, condicional às hipóteses de relevância e exclusão.
- Diferenças OLS vs IV foram tratadas como indicativas de possível viés em OLS, sem sobre-alegação causal.

## 6) Comparação OLS vs IV

- Comparação construída com quatro modelos: `mod_ols_simple`, `mod_ols_full`, `mod_rf_main`, `mod_iv_main`.
- Arquivos: `outputs/lab07_phase3d_models_comparison_tidy.csv` e `outputs/lab07_phase3d_models_comparison_table.txt`.

## 7) README.md

- README foi atualizado (não recriado).
- Seções alteradas: Como usar / como executar; Histórico de atualizações.

## 8) Arquivos e outputs gerados

- `docs/lab07_phase3d.Rmd`
- `docs/lab07_phase3d.html`
- `outputs/lab07_phase3d_prerequisites_check.csv`
- `outputs/lab07_phase3d_consistency_check.csv`
- `outputs/lab07_phase3d_iv_main_tidy.csv`
- `outputs/lab07_phase3d_iv_main_summary.txt`
- `outputs/lab07_phase3d_iv_stage12_summary.txt`
- `outputs/lab07_phase3d_iv_stage12_table.txt`
- `outputs/lab07_phase3d_first_stage_tidy.csv`
- `outputs/lab07_phase3d_first_stage_summary.txt`
- `outputs/lab07_phase3d_first_stage_diagnostics.csv`
- `outputs/lab07_phase3d_first_stage_note.txt`
- `outputs/lab07_phase3d_reduced_form_tidy.csv`
- `outputs/lab07_phase3d_reduced_form_summary.txt`
- `outputs/lab07_phase3d_models_comparison_tidy.csv`
- `outputs/lab07_phase3d_models_comparison_table.txt`
- `outputs/lab07_phase3d_readme_update_log.csv`
- `outputs/lab07_phase3d_session_info.txt`
- `docs/lab07_phase3d_handoff_2026-03-27.md`

## 9) Pendente para a Fase 3E

- Robustez mínima com `war_prio`.
- Extensões narrow.
- Comparação final incorporando robustez.
- Encerramento integral do laboratório.

Execução encerrada ao final da Fase 3D, sem avanço para a Fase 3E.
