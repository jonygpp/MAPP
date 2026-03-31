# AGENTS.md

**Author:** Ricardo Ceneviva  
**Version:** 2026-03-26  
**Project scope:** produção de conteúdo pedagógico, pesquisa aplicada, análise de dados e fluxos reprodutíveis para as aulas e materiais do curso MAPP

## Purpose

This repository supports four types of work:

1. pedagogical content production for MAPP classes;
2. reproducible quantitative analysis;
3. academic writing and research support;
4. slide decks, lecture notes, exercises, handouts, and supporting appendices.

The agent must recognize which type of task is being requested before acting.  
Do not treat pedagogical production as if it were only a coding task.  
Do not treat data analysis as if it were only a writing task.

---

## Core principles

1. Reproducibility is mandatory.
2. Factual accuracy is mandatory.
3. Causal identification matters a lot.
4. Trust what has been validated. Be skeptical of what has not been validated.
5. Prefer simple, auditable workflows over clever but opaque solutions.
6. Prefer stable, common, well-documented packages and tools.
7. Every substantial output must leave a trace that another researcher or instructor can inspect.
8. For MAPP teaching materials, prioritize conceptual clarity, methodological precision, and didactic coherence.
9. Distinguish clearly between:
   - description
   - prediction
   - association
   - causal interpretation
10. Never present a causal claim unless the identification strategy supports it.
11. **Mandatory literate programming rule:** For any programming language used in this repository (including R, Python, LaTeX, and others), outputs must **always** follow literate programming standards: interleave code blocks with clear natural-language explanations (Portuguese or English), prioritizing human readability and simultaneous documentation of logic, assumptions, and analytical decisions.

---

## Source precedence and evidence rules

When multiple files or notes exist, use the following hierarchy:

1. user-approved plans, validated outlines, and explicit user instructions;
2. primary sources:
   - original articles
   - official course syllabus
   - original slides or code approved by the user
   - canonical project files
3. secondary internal materials:
   - draft `.tex` files
   - previous notes
   - markdown summaries
   - derivative summaries prepared by the assistant or others
4. general background sources.

Additional rules:

1. Do not let a derivative summary override a primary source.
2. If a markdown note conflicts with an original article, trust the article.
3. If two internal drafts conflict, treat the user-approved version as canonical.
4. When using numbers, coefficients, test statistics, quotations, or empirical claims, verify them against the primary source before reusing them.
5. If access to a required source is missing, stop and report what is missing before continuing.

---

## Task classification

Before doing any substantial work, classify the task into one of the following modes:

1. **Pedagogical design**
   - lecture plans
   - slide decks
   - lecture scripts
   - reading guides
   - exercises
   - discussion prompts
   - grading rubrics

2. **Empirical analysis**
   - data cleaning
   - estimation
   - replication
   - diagnostics
   - causal analysis
   - tables and figures

3. **Research writing**
   - article drafts
   - reports
   - literature reviews
   - referee reports
   - project memos

4. **Project integration**
   - merging drafts
   - reconciling conflicting files
   - version control of outputs
   - audit of references, figures, and appendices

Choose one primary mode.  
If the task spans multiple modes, state the sequence explicitly before implementation.

---

## How to interact

1. Start with clarification only when clarification is truly necessary.
2. Do not ask avoidable questions when the repository and the validated project context already answer them.
3. When questions are needed, always number them.
4. Ask only the minimum set of questions needed to reduce material uncertainty.
5. Before executing a multi-step task, present a short implementation plan.
6. Ask for approval before starting a new major phase.
7. Do not move to the next phase until the current phase has been reviewed and explicitly approved, unless the user has authorized full execution in advance.
8. When a task is already validated and the user explicitly asks to proceed, do not re-open settled design choices.
9. Prefer short, reviewable cycles.
10. Preserve continuity with prior validated decisions.

---

## Planning rules

1. If a task has multiple phases, write the plan before execution.
2. Store plans under `docs/` unless the repository already uses another documented location.
3. Treat plan files as living documents.
4. Keep plan files synchronized with actual implementation.
5. After each completed phase, update `HANDOFF.md` if it exists; otherwise update `README.md` or a file under `docs/`.
6. For pedagogical tasks, plans must include:
   - objective of the material
   - intended audience
   - pedagogical function of each component
   - required sources
   - validation criteria
7. For integration tasks, plans must include:
   - canonical source
   - files to reconcile
   - conflict resolution rule
   - approval checkpoints

---

## Repository conventions

Use the following folder structure by default, unless the repository already has a documented alternative:

- `data_raw/` for raw or original data files
- `data_processed/` for cleaned or analysis-ready data
- `R/` for R scripts and helper functions
- `python/` for Python scripts when Python is needed
- `outputs/` for generated tables, figures, reports, decks, and model outputs
- `logs/` for execution logs, diagnostics, and error records
- `docs/` for plans, notes, codebooks, validation memos, and supplementary documentation
- `slides/` for slide source files when the repository uses a separate deck folder
- `references/` for bibliographic files when needed

Additional conventions:

1. Preserve raw files exactly as obtained.
2. Do not overwrite raw data.
3. Keep paths relative to the project root.
4. Organize outputs so another researcher can identify which script or phase generated them.
5. Use descriptive file names with topic, version, and date when appropriate.

---

## Language and style preferences for MAPP pedagogical materials

Unless the user instructs otherwise:

1. Write in Brazilian Portuguese.
2. Use academic language.
3. Be clear, direct, and didactic.
4. Prefer short sentences.
5. Avoid unnecessary jargon.
6. Avoid inflated rhetoric.
7. Use bullet points when they improve teaching clarity.
8. Use notation only when it clarifies the concept.
9. Distinguish concept, method, identification logic, and substantive interpretation.
10. For slide decks:
    - one main idea per slide
    - avoid excessive text density
    - every slide must have a pedagogical function
    - equations must be interpretable in words
    - graphics, DAGs, and tables should explain, not decorate
11. For lecture scripts:
    - include transitions
    - include comprehension checks when useful
    - maintain coherence with the approved slide deck
12. For exercises:
    - state learning objective
    - specify difficulty level
    - identify whether the task is conceptual, computational, or interpretive

---

## Pedagogical production workflow

For MAPP class materials, follow this order unless the user requests otherwise:

1. identify the pedagogical objective;
2. identify the validated plan or canonical structure;
3. identify the required sources;
4. extract only the content relevant to the pedagogical objective;
5. reconcile inconsistencies across drafts and sources;
6. produce the requested artifact:
   - outline
   - lecture script
   - slide deck
   - exercise set
   - handout
7. validate factual accuracy;
8. validate pedagogical coherence;
9. validate formatting and references;
10. stop for approval before the next major deliverable.

For deck production specifically:

1. define the slide sequence before writing full slide text;
2. assign a clear role to each slide:
   - title
   - roadmap
   - concept
   - identification logic
   - empirical illustration
   - methodological caveat
   - synthesis
3. remove redundant slides across drafts;
4. prefer one integrated deck over concatenated sub-decks;
5. when merging multiple `.tex` drafts, use one canonical preamble and one canonical reference section;
6. verify that figures, tables, and DAGs appear exactly where the argument needs them.

---

## Anexo complementar: padrão para laboratórios computacionais em R / .Rmd

Este anexo se aplica a laboratórios práticos do curso MAPP que envolvam R, `.Rmd`, `.qmd` ou scripts associados.

### 1. Finalidade do laboratório computacional

Um laboratório computacional em MAPP não é apenas um artefato técnico.  
Ele deve cumprir simultaneamente quatro funções:

1. ensinar um conceito ou método;
2. operacionalizar uma estratégia analítica;
3. treinar interpretação substantiva dos resultados;
4. reforçar padrões de reprodutibilidade e documentação.

O laboratório deve ser legível por um estudante de pós-graduação que precise:
- executar o material do início ao fim;
- entender o que está sendo feito;
- interpretar o que foi estimado;
- reconhecer limites e pressupostos da estratégia.

---

### 2. Estrutura mínima recomendada

Todo laboratório em `.Rmd` ou `.qmd` deve conter, salvo justificativa explícita em contrário:

1. título;
2. objetivo de aprendizagem;
3. pergunta substantiva ou pergunta causal;
4. breve contexto do problema empírico;
5. setup do ambiente e pacotes;
6. importação e descrição dos dados;
7. exploração inicial dos dados;
8. bloco principal de análise;
9. interpretação dos resultados;
10. diagnóstico ou discussão crítica;
11. síntese final;
12. referências ou fontes utilizadas.

Quando a tarefa envolver inferência causal, o laboratório deve explicitar:
- estimando;
- estratégia de identificação;
- principais hipóteses;
- ameaças à validade;
- alcance substantivo da conclusão.

---

### 3. Princípios de escrita didática

No laboratório computacional:

1. código não substitui explicação;
2. cada bloco analítico deve ser antecedido por uma frase de objetivo;
3. cada resultado relevante deve ser seguido por interpretação textual;
4. a linguagem deve ser clara, direta e didática;
5. a explicação deve distinguir:
   - implementação
   - identificação
   - interpretação
   - limitação

Evitar:
- blocos longos de código sem comentário interpretativo;
- saídas não discutidas;
- jargão não introduzido;
- explicações puramente algorítmicas quando o objetivo é causal ou substantivo.

---

### 4. Padrão mínimo para métodos quantitativos

Quando o laboratório tratar de regressão, IV, DiD, RD, matching, experimentos ou métodos correlatos, ele deve conter explicitamente:

1. o que está sendo estimado;
2. por que o método é necessário;
3. o que o modelo identifica, e o que não identifica;
4. quais pressupostos precisam ser verdadeiros;
5. quais diagnósticos ajudam a sustentar a interpretação;
6. quais limitações permanecem.

Para IV, incluir sempre, quando aplicável:
- OLS como benchmark;
- first stage;
- reduced form;
- estimação IV/2SLS;
- comentário sobre força do instrumento;
- comentário sobre exclusão;
- comentário sobre o caráter local do estimando.

---

### 5. Requisitos técnicos mínimos

Todo laboratório computacional deve:

1. usar caminhos relativos;
2. ser executável ponta a ponta;
3. declarar pacotes utilizados;
4. evitar dependências ocultas;
5. preservar separação entre dados brutos e derivados;
6. ter chunks organizados e nomeados quando útil;
7. permitir que outro usuário reproduza a análise com documentação mínima.

Sempre que possível:
- incluir `set.seed()` em simulações;
- registrar sessão ou ambiente;
- salvar outputs importantes em local coerente com o repositório.

---

### 6. Checkpoints conceituais obrigatórios

Todo laboratório deve incluir checkpoints conceituais curtos ao longo do texto.  
Esses checkpoints podem aparecer como perguntas, boxes ou notas.

Exemplos:
- O que este coeficiente representa?
- Por que este resultado não é automaticamente causal?
- O que o first stage nos diz?
- O que muda entre OLS e IV?
- O que ameaça esta interpretação?

A função desses checkpoints é tornar o laboratório um instrumento de aprendizagem, e não apenas de execução.

---

### 7. Critérios de validação específicos para laboratórios

Um laboratório computacional só pode ser considerado concluído se atender, além das regras gerais do projeto, aos seguintes critérios:

1. executabilidade do arquivo;
2. clareza didática;
3. coerência entre código e interpretação;
4. aderência à pergunta substantiva;
5. explicitação de pressupostos e limites;
6. documentação suficiente para reexecução.


## Validation and quality control for pedagogical content

Every pedagogical deliverable must pass all of the following checks:

### 1. Factual validation
- names, dates, coefficients, definitions, quotations, and empirical claims are correct;
- claims drawn from primary sources have been checked against the original source;
- no result from a derivative note is reused without verification when precision matters.

### 2. Pedagogical validation
- each section has a clear teaching purpose;
- the order of exposition is coherent;
- the level matches the intended audience;
- the content does not assume knowledge that has not yet been introduced.

### 3. Structural validation
- no duplicated introduction, duplicated conclusion, or repeated slide logic;
- no orphan slide without pedagogical role;
- no disconnected appendix-like material inside the core teaching flow.

### 4. Citation validation
- every substantive section cites the relevant source when appropriate;
- direct empirical claims cite the primary source;
- references section is complete and consistent with the citations used.

### 5. Technical validation
- `.tex` files compile cleanly or are at least structurally coherent;
- macros are not duplicated unnecessarily;
- figure and table placeholders are correctly named;
- bibliography commands and package dependencies are consistent.

### 6. Critérios de validação específicos para laboratórios

Um laboratório computacional só pode ser considerado concluído se atender, além das regras gerais do projeto, aos seguintes critérios:

1. executabilidade do arquivo;
2. clareza didática;
3. coerência entre código e interpretação;
4. aderência à pergunta substantiva;
5. explicitação de pressupostos e limites;
6. documentação suficiente para reexecução.

---

## Reconciliation rules for multiple drafts

When the task involves merging drafts, notes, or competing versions:

1. define one canonical base file;
2. treat other files as candidate supplements, not as equal authorities;
3. compare the files by section or slide function, not by file order;
4. identify:
   - overlaps
   - contradictions
   - unique additions
   - sections to discard
5. create a reconciliation matrix with four fields:
   - item
   - source file
   - decision
   - justification
6. never merge by simple concatenation;
7. remove duplicated preambles, duplicated cover slides, duplicated agenda slides, and repeated conceptual definitions;
8. when a draft contains empirical claims not verified in the primary source, flag them for review before inclusion.

---

## Validation and data quality for empirical work

1. Do not assume data are clean because they loaded successfully.
2. Check logical date rules and incompatible values when applicable.
3. Explicitly document all filters, exclusions, recodes, transformations, and derived variables.
4. When estimation depends on a design choice, make that choice explicit and justify it.
5. For statistical workflows, validate both:
   - computational correctness
   - substantive plausibility
6. Save verifiable outputs:
   - tables
   - figures
   - model summaries
   - diagnostics
   - logs

---

## Statistical and causal standards

1. Distinguish clearly between:
   - description
   - prediction
   - association
   - causal interpretation
2. Do not present regression coefficients as causal effects unless the identification strategy supports that interpretation.
3. Discuss assumptions, threats to identification, and robustness checks whenever relevant.
4. When using simulated data, make the data-generating process explicit.
5. When using observational data, document:
   - sampling frame
   - population
   - limitations
   - measurement choices
6. When discussing IV, RD, DiD, matching, or experiments:
   - state the estimand
   - state the identification assumptions
   - state key threats
   - avoid causal overclaiming

---

## Package and implementation standards

1. Prefer R for data analysis, statistics, econometrics, reporting, and academic research workflows.
2. Prefer Python for machine learning, web scraping, text processing, web apps, and CLI tools.
3. Prefer stable, common packages unless there is a strong reason not to.
4. If a less common package is used, justify:
   - why it is necessary
   - what alternatives were considered
   - how it was verified
5. Keep scripts readable and commented, but avoid unnecessary verbosity.
6. Avoid hidden side effects.
7. Save important intermediate outputs when they improve traceability.
8. Separate computation from narrative when possible.

---

## Default deliverables

No phase is complete unless it generates all applicable deliverables for that phase.

### For empirical phases
1. at least one script;
2. at least one concrete output;
3. at least one documentation update.

### For pedagogical phases
1. at least one source artifact:
   - `.tex`
   - `.Rmd`
   - `.qmd`
   - `.md`
   - `.docx`
2. at least one reviewable output:
   - deck draft
   - outline
   - script
   - handout
   - exercise set
3. at least one validation or handoff note.

Code-only changes do not count as completion when the task is pedagogical.

---

## Academic project standards

Treat tables, figures, decks, appendices, and handouts as versioned research and teaching outputs.

1. Number figures and tables consistently.
2. Save major tables and figures as standalone files under `outputs/` when appropriate.
3. Use stable, descriptive file names that include:
   - object type
   - topic
   - version or date
   - optional phase identifier
4. If a figure, table, or deck is revised, create a new version rather than silently overwriting the old one, unless the repository explicitly adopts another documented policy.
5. If a manuscript, class plan, or slide deck refers to an object, ensure that the object exists and is synchronized with the latest approved version.
6. Document which script or source file generates each major output.

---

## Error handling

1. When a step fails, do not simply retry the same command.
2. Diagnose first.
3. Act on the diagnosis.
4. If the problem persists, log:
   - the exact error
   - what was tested
   - what remains blocked
5. For content tasks, if the blocker is factual uncertainty, stop and request the missing source or decision.
6. For integration tasks, if the blocker is a conflict between sources, document the conflict explicitly rather than guessing.

---

## Network and download rules

1. If a task requires internet access and fails because of DNS or connectivity, retry with the appropriate permissions or alternative access path.
2. If network retrieval fails again due to DNS, timeout, or HTTP 403:
   - retry once after a short delay
   - then try an alternative source
3. Log all network failures.
4. Always record source and access date for external materials used in research or pedagogy.

---

## Documentation and handoff

Every substantial task should leave a trace another researcher, instructor, or future agent can inspect.

Document:

1. what was done;
2. why it was done;
3. what sources were used;
4. what was validated;
5. how to rerun or continue the work;
6. what outputs were generated;
7. what remains pending.

Handoffs must make it possible to resume work without reconstructing context from chat history.

---

## Preferred execution style for this repository

1. Use phased execution.
2. Use short, reviewable implementation cycles.
3. Ask before moving on to a new major phase.
4. Favor correctness, transparency, pedagogical quality, and reproducibility over speed.
5. For complex tasks, use a written plan and follow it strictly.
6. For agentic tasks, define explicit approval criteria before implementation.
7. Keep context compact and high-signal:
   - use only the files relevant to the current phase
   - avoid carrying redundant drafts into later stages
   - summarize validated decisions in handoff notes
8. Prefer one clean, validated integrated artifact over multiple partially overlapping drafts.

---

## Completion checklist

Before marking any substantial task complete, verify:

1. the task mode was correctly identified;
2. the canonical sources were used;
3. the output matches the user-approved scope;
4. factual claims were validated;
5. pedagogical structure is coherent;
6. references and citations are consistent;
7. outputs are saved or ready to save in the correct location;
8. documentation was updated;
9. unresolved issues are explicitly listed.

If any item fails, the phase is not complete.