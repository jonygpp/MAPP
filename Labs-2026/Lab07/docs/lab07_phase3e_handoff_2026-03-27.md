# Handoff — Fase 3E e Encerramento do Lab07 MAPP 2026

## 1) O que foi feito

- Validação de consistência com todas as fases anteriores (3B, 3C, 3D).
- Extensão de `df_main` com variáveis opcionais via left join controlado (N mantido = 743).
- Documentação formal de disponibilidade das variáveis narrow.
- Estimação de quatro modelos de robustez com `war_prio`: OLS simples, OLS ampliado, reduced form e IV.
- Estimação de IV narrow para `any_prio_nar` e `war_prio_nar`.
- Construção da tabela de comparação final consolidada.
- Redação da interpretação causal final integrada.
- Redação das conclusões do laboratório.
- Atualização final e incremental do README.md.
- Geração de session info e handoff final.

## 2) Checkpoints validados

- **Checkpoint E1:** todos os modelos de robustez (war_prio) estimados sem erro.
- **Checkpoint E2:** variáveis narrow disponíveis — IV narrow estimado.
- **Checkpoint E3:** tabela final consolidada gerada em .csv e .txt legível.
- **Checkpoint E4:** interpretação causal final integrada redigida no documento.
- **Checkpoint E5:** README.md atualizado incrementalmente e logado.

## 3) Especificações efetivamente estimadas

**Pipeline principal (any_prio) — herdado das Fases 3C/3D e reestimado sobre df_extended:**
- OLS simples: `any_prio ~ gdp_g + gdp_g_l`, vcov = ~ccode.
- OLS ampliado: `any_prio ~ gdp_g + gdp_g_l + controles | ccode[year_trend]`, vcov = ~ccode.
- Reduced form: `any_prio ~ gpcp_g + gpcp_g_l + controles | ccode[year_trend]`, vcov = ~ccode.
- IV main: `any_prio ~ controles | ccode[year_trend] | gdp_g + gdp_g_l ~ gpcp_g + gpcp_g_l`, vcov = ~ccode.

**Robustez (war_prio) — Fase 3E:**
- OLS simples, OLS ampliado, reduced form e IV: mesma especificação, desfecho = war_prio.

**Narrow (any_prio_nar, war_prio_nar) — Fase 3E:**
- IV narrow: mesma especificação IV principal, desfecho = any_prio_nar e war_prio_nar.

## 4) Principais resultados

**First stage (da Fase 3D, mantido como referência):**
- gdp_g: F = 6.399, p = 0.00176.
- gdp_g_l: F = 5.138, p = 0.00609.
- Instrumentos com força moderada (F < 10); estimativas IV sujeitas a maior imprecisão.

**IV principal (any_prio):**
- mod_iv_main:
  fit_gdp_g: -1.151 (SE=1.459, p=0.4347)
  fit_gdp_g_l: -2.619** (SE=1.228, p=0.0391)

**IV robustez (war_prio):**
- mod_wp_iv:
  fit_gdp_g: -1.375 (SE=0.825, p=0.1034)
  fit_gdp_g_l: -0.692 (SE=0.716, p=0.3398)

**IV narrow (any_prio_nar):**
- mod_iv_nar_any:
  fit_gdp_g: -0.822 (SE=1.177, p=0.4887)
  fit_gdp_g_l: -2.383** (SE=1.168, p=0.0480)

**IV narrow (war_prio_nar):**
- mod_iv_nar_war:
  fit_gdp_g: -0.889 (SE=0.596, p=0.1437)
  fit_gdp_g_l: -0.274 (SE=0.638, p=0.6697)

## 5) Interpretação causal final

- O IV identifica o efeito de variações exógenas de crescimento (induzidas por chuva) sobre conflito.
- O estimando é um LATE (Local Average Treatment Effect) restrito aos compliers do instrumento.
- A direção negativa (crescimento reduz conflito) é consistente em OLS e IV.
- A amplificação dos coeficientes no IV é compatível com atenuação por erro de mensuração ou causalidade reversa no OLS.
- Limitações: F-stats abaixo de 10 (força moderada/fraca), exclusão não testável, N de grupos pequeno (41 países).

## 6) Limitações formalmente registradas

- Instrumentos moderadamente fracos (F < 10): estimativas IV podem apresentar viés e imprecisão.
- Hipótese de exclusão não testável empiricamente (canais diretos de precipitação sobre conflito).
- N de clusters pequeno (41 países): SE clusterizados têm cobertura assintótica limitada.
- Generalização restrita ao contexto de economias agrícolas de baixa renda.

## 7) Status do README.md

- README atualizado incrementalmente (não recriado).
- Seções alteradas: Metodologia; Como usar / como executar.
- Laboratório marcado como finalizado no README.

## 8) Outputs finais gerados

- `docs/lab07_phase3e.Rmd`
- `docs/lab07_phase3e.html`
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
- `outputs/lab07_phase3e_readme_update_log.csv`
- `outputs/lab07_phase3e_session_info.txt`
- `docs/lab07_phase3e_handoff_2026-03-27.md`

## 9) Conclusão do laboratório

O Lab07 MAPP 2026 está **encerrado**.

O laboratório replicou os resultados centrais de Miguel, Satyanath e Sergenti (2004) para
a África subsaariana, implementando em R um pipeline completo de:
  1. auditoria e construção de amostra (Fases 3A–3B);
  2. benchmarks associativos OLS (Fase 3C);
  3. estratégia IV/2SLS com instrumentos climáticos (Fase 3D);
  4. análise de robustez e fechamento interpretativo (Fase 3E).

Todos os outputs foram salvos em `outputs/`, todos os artefatos literários em `docs/`,
e o README.md reflete o estado final do projeto.

Data de encerramento: 2026-03-27.
