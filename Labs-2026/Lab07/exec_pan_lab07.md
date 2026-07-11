# Plano Execituvo do Lab07

# 1. Princípio técnico do roteiro

O laboratório implementa **2SLS com uma variável endógena (crescimento) e um instrumento (chuva)**.

Formalização:

* Variável dependente: (Y) = conflito
* Variável endógena: (D) = crescimento
* Instrumento: (Z) = chuva

Pipeline econométrico:

1. First stage: (D = f(Z, X))
2. Reduced form: (Y = f(Z, X))
3. 2SLS: (Y = f(\hat{D}, X))

Essa estrutura segue a definição padrão de IV: primeiro prever (D) com (Z), depois usar o componente exógeno de (D) na regressão estrutural ([Wikipedia][1])

---

# 2. Roteiro técnico executável

## 2.1. Preparação do ambiente

### Objetivo

Garantir reprodutibilidade.

### Tarefas

1. Definir linguagem (R ou Python)
2. Carregar pacotes:

* R:

  * tidyverse
  * fixest ou AER
  * sandwich
  * lmtest

* Python:

  * pandas
  * statsmodels
  * linearmodels

3. Definir diretório de trabalho

4. Importar base de dados de replicação

### Output esperado

* dataset carregado em memória
* log de dimensões (n, k)

---

## 2.2. Inspeção e limpeza dos dados

### Objetivo

Garantir consistência do banco

### Tarefas

1. Verificar estrutura:

* número de observações
* painel (país-ano)

2. Checar missing values nas variáveis-chave:

* conflito
* crescimento
* chuva

3. Criar dataset analítico:

* remover NA
* manter apenas variáveis necessárias

4. Criar identificadores:

* país
* ano

### Output esperado

* dataset limpo (`df_analysis`)
* tabela resumo de missing

---

## 2.3. Definição das variáveis do modelo

### Objetivo

Formalizar o modelo empírico

### Variáveis mínimas

* `conflict_it` (Y)
* `growth_it` (D)
* `rain_it` (Z)

### Controles (se disponíveis no dataset)

* efeitos fixos de país
* efeitos fixos de tempo
* covariáveis econômicas/políticas

### Output esperado

* lista explícita de variáveis
* documentação no script

---

## 2.4. Estimação OLS (benchmark)

### Objetivo

Estabelecer comparação

### Especificação

[
conflict_{it} = \beta_0 + \beta_1 growth_{it} + \epsilon_{it}
]

### Tarefas

1. Estimar modelo OLS
2. Armazenar coeficientes
3. Calcular erros robustos

### Output esperado

* coeficiente de crescimento
* erro padrão
* significância

---

## 2.5. First stage

### Objetivo

Testar relevância do instrumento

### Especificação

[
growth_{it} = \pi_0 + \pi_1 rain_{it} + u_{it}
]

### Tarefas

1. Estimar regressão
2. Extrair:

* coeficiente de chuva
* estatística F

3. Avaliar força do instrumento

### Fundamento técnico

Instrumentos fracos produzem estimativas inconsistentes ([Schmidheiny][2])

### Output esperado

* coeficiente de chuva
* F-statistic

---

## 2.6. Reduced form

### Objetivo

Estimar efeito total do instrumento

### Especificação

[
conflict_{it} = \gamma_0 + \gamma_1 rain_{it} + v_{it}
]

### Tarefas

1. Estimar regressão
2. Interpretar coeficiente

### Output esperado

* coeficiente de chuva sobre conflito

---

## 2.7. Estimação IV (2SLS)

### Objetivo

Obter efeito causal

### Especificação

[
conflict_{it} = \beta_0 + \beta_1 growth_{it} + \epsilon_{it}
]

com:

[
growth_{it} \text{ instrumentado por } rain_{it}
]

### Tarefas

1. Rodar 2SLS via pacote apropriado
2. NÃO implementar manualmente (problema de erro padrão)
3. Extrair:

* coeficiente IV
* erro padrão robusto

### Fundamento técnico

2SLS substitui (D) por sua parte explicada por (Z) ([Kevin Li][3])

### Output esperado

* coeficiente IV
* comparação com OLS

---

## 2.8. Comparação OLS vs IV

### Objetivo

Interpretar diferença

### Tarefas

1. Construir tabela:

* OLS
* IV

2. Comparar:

* sinal
* magnitude
* significância

### Output esperado

* tabela comparativa

---

## 2.9. Diagnósticos mínimos

### Objetivo

Avaliar validade

### Tarefas

1. Verificar:

* força do instrumento (F > 10, regra prática)
* coerência de sinais

2. Discutir (não estimar):

* exclusão
* LATE

### Fundamento

IV depende fortemente da validade das suposições ([ScienceDirect][4])

---

## 2.10. Outputs finais obrigatórios

O agente deverá gerar:

1. Tabela OLS
2. Tabela First stage
3. Tabela Reduced form
4. Tabela IV (2SLS)
5. Tabela comparativa final

Opcional:

* gráfico simples (rain vs growth)

---

# 3. Estrutura do script (template lógico)

O script do agente deverá seguir exatamente esta ordem:

1. Setup
2. Load data
3. Clean data
4. Define variables
5. OLS
6. First stage
7. Reduced form
8. IV (2SLS)
9. Comparison
10. Diagnostics

Sem desvios.

---

# 4. Checkpoints de validação (críticos)

O roteiro inclui pontos de parada obrigatórios:

### Checkpoint 1 — Dados

* dataset carregado corretamente

### Checkpoint 2 — First stage

* coeficiente de chuva significativo

### Checkpoint 3 — IV

* coeficiente IV estimado sem erro

### Checkpoint 4 — Coerência

* sinais compatíveis com teoria

Se qualquer checkpoint falhar, o agente deve interromper.

---

# 5. Limites explícitos desta fase

Este roteiro:

* NÃO contém código executável completo
* NÃO define linguagem final
* NÃO gera outputs
* NÃO inclui prompt para agente

Ele é um **documento intermediário técnico**, conforme exigido pelo Workflow.

---

# 6. Síntese

O Lab07 está agora traduzido em um pipeline técnico completo, alinhado com a literatura de IV:

* first stage identifica relevância
* reduced form captura efeito total
* 2SLS estima efeito causal
* comparação com OLS revela viés

