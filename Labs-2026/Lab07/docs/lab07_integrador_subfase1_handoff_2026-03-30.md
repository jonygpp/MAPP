# Handoff — Lab07 Integrador (Subfase 1)

**Data:** 2026-03-30  
**Status:** Concluída (Subfase 1)  

## 1) Classificação da tarefa (registrada)

- **Modo principal:** integração de materiais.
- **Modo secundário:** produção pedagógica.
- **Modo subordinado:** apoio empírico apenas para organização documental.

## 2) O que foi feito

1. Definidos os nomes canônicos do artefato integrador:
   - fonte: `docs/lab07_integrador_alunos_v1.qmd`
   - output principal: `docs/lab07_integrador_alunos_v1.html`
2. Criado o arquivo `.qmd` com YAML mínimo e compatível com Quarto.
3. Definida a estrutura macro do documento com as seções na ordem validada.
4. Registradas convenções técnicas de chunks, tabelas, figuras e referências cruzadas.
5. Registrada política de caminhos relativos e de reaproveitamento de outputs já validados.
6. Registrada regra central de não interferência nas análises e outputs das Fases 3A–3E.
7. Atualizado `README.md` de forma incremental para abrir a nova fase e apontar o handoff da subfase.

## 3) Por que foi feito

- Para estabelecer uma arquitetura técnica e editorial auditável do integrador em Quarto antes da redação pedagógica completa.
- Para garantir continuidade com decisões já validadas do Lab07 sem reabrir escolhas aprovadas.
- Para preparar a transição controlada para a Subfase 2, mantendo escopo e rastreabilidade.

## 4) Arquivos consultados

- `AGENTS.md`
- `Workflow-Projeto.md`
- `Ceneviva-2026-MAPP-UFABC.pdf`
- `docs/lab07_phase3e_handoff_2026-03-27.md`
- `docs/files_list.md`
- `README.md`
- `Miguel-etal-2004-paper.pdf` (fonte primária substantiva, sem iniciar nova análise)

## 5) Arquivos criados ou modificados

### Criados
- `docs/lab07_integrador_alunos_v1.qmd`
- `docs/lab07_integrador_subfase1_handoff_2026-03-30.md`

### Modificado
- `README.md` (incremental)

## 6) Decisões técnicas fixadas nesta subfase

1. **Formato principal:** HTML.
2. **Formato opcional futuro:** PDF (não implementado nesta subfase).
3. **Execução:** integração R via Quarto/knitr.
4. **Caminhos:** sempre relativos à raiz do projeto.
5. **Não sobrescrita:** proibida escrita/sobrescrita de outputs já validados.
6. **Chunks:** convenções de nome (`sf1-setup-*`, `b1-*...b6-*`, `tbl-*`, `fig-*`), com `echo: true`, `warning: false`, `message: false` e `eval: false` para qualquer risco de reestimação nesta etapa.
7. **Tabelas/Figuras:** política de rótulos e referências cruzadas futuras (`#tbl-*`, `#fig-*`, chamadas `@tbl-*`, `@fig-*`).

## 7) Política de não interferência (fixada)

O integrador `.qmd` nesta subfase:
- não reestima modelos;
- não sobrescreve outputs das Fases 3A–3E;
- não altera dados em `Data/`;
- não modifica handoffs anteriores;
- não substitui pipeline validado;
- não introduz novos resultados empíricos;
- não revisa interpretações causais validadas sem autorização explícita.

## 8) Como a Subfase 2 deve continuar

1. Preencher o conteúdo didático dos blocos já definidos, sem alterar a arquitetura aprovada na Subfase 1.
2. Inserir leitura de outputs já validados em `outputs/` com caminhos relativos.
3. Implementar placeholders de tabelas e figuras com rótulos consistentes e referências cruzadas.
4. Manter regra de não interferência: sem reestimação e sem sobrescrita de outputs.
5. Atualizar README e produzir novo handoff específico da Subfase 2.

## 9) Fora do escopo (mantido)

- redação completa dos blocos;
- produção final de tabelas e gráficos;
- renderização final obrigatória do `.qmd`;
- reestimação de modelos;
- revisão metodológica das Fases 3A–3E;
- slides, exercícios, roteiro de fala;
- PDF final.

## 10) Erros, bloqueios e pendências

- **Bloqueios críticos:** nenhum.
- **Pendências para Subfase 2:** preenchimento pedagógico dos blocos e integração controlada de outputs já validados.
