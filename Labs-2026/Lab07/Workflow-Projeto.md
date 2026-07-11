# Workflow-Projeto.md

**Autor:** Ricardo Ceneviva  
**Versão:** 2026-03-26  
**Escopo:** fluxo operacional para produção, revisão, integração e validação de materiais pedagógicos do curso MAPP

---

# Protocolo operacional do projeto MAPP

## 1. Finalidade do workflow

Este workflow organiza a cooperação entre:

1. o professor e coordenador do curso;
2. o agente executor técnico;
3. o agente revisor metodológico e editorial.

O objetivo é garantir que a produção de materiais pedagógicos de MAPP seja:

- metodologicamente correta;
- pedagogicamente coerente;
- factual e bibliograficamente confiável;
- tecnicamente organizada;
- fácil de revisar, retomar e atualizar.

Este protocolo deve ser usado para:

- planos de aula;
- roteiros de aula;
- decks de slides;
- listas de exercícios;
- handouts;
- relatórios de apoio didático;
- integração de múltiplos rascunhos;
- revisão de materiais produzidos anteriormente.

---

## 2. Arquitetura de papéis

## 2.1. Papel do professor

O professor atua como:

- coordenador pedagógico;
- aprovador formal de cada fase;
- controlador do escopo;
- juiz final da adequação metodológica e didática;
- decisor final em caso de conflito entre fontes, versões ou estratégias de apresentação.

Em termos práticos:  
**Professor = autoridade final sobre conteúdo, escopo e aprovação.**

---

## 2.2. Papel do ChatGPT

Neste projeto, o ChatGPT deve ser usado para:

1. revisar e validar o plano operacional de cada fase;
2. verificar aderência ao `AGENTS.md`;
3. auditar coerência metodológica e conceitual;
4. verificar alinhamento entre material pedagógico e fontes primárias;
5. avaliar estrutura didática, sequência de exposição e densidade do conteúdo;
6. identificar redundâncias, lacunas e problemas de escopo;
7. revisar linguagem, transições e precisão da interpretação;
8. recomendar correções antes da aprovação de cada fase.

Em resumo:  
**ChatGPT = controle de qualidade metodológica, factual, editorial e pedagógica.**

---

## 2.3. Papel do Codex ou agente executor

Neste projeto, o Codex, ou outro agente executor, deve ser usado para:

1. criar e editar arquivos-fonte;
2. consolidar rascunhos;
3. editar scripts, `.tex`, `.md`, `.qmd`, `.Rmd`, `.docx` e outros artefatos autorizados;
4. gerar outputs técnicos quando necessário;
5. organizar figuras, tabelas, logs e documentação;
6. atualizar `README.md`, `HANDOFF.md`, `docs/EXEC_PLAN.md` e demais arquivos de acompanhamento;
7. executar apenas a fase autorizada;
8. respeitar estritamente o `AGENTS.md` e este `Workflow-Projeto.md`.

Em resumo:  
**Codex = executor técnico do plano validado.**

---

## 3. Tipos de tarefa cobertos por este workflow

O fluxo deve começar pela identificação do tipo principal de tarefa.

### Tipo A. Planejamento pedagógico
Exemplos:
- plano de aula;
- ementa expandida;
- sequência de módulos;
- objetivos de aprendizagem.

### Tipo B. Produção pedagógica
Exemplos:
- slides;
- roteiro de fala;
- exercícios;
- handouts;
- estudo dirigido.

### Tipo C. Integração de materiais
Exemplos:
- fusão de versões A e B de um deck;
- incorporação de notas em markdown ao `.tex`;
- consolidação de referências e figuras.

### Tipo D. Revisão e validação
Exemplos:
- auditoria de precisão factual;
- revisão metodológica;
- revisão didática;
- revisão final antes de uso em aula.

### Tipo E. Produção empírica de apoio
Exemplos:
- geração de figuras;
- tabelas;
- simulações;
- gráficos diagnósticos;
- outputs para inserir em slides.

Escolher um tipo principal é obrigatório.  
Se a tarefa combinar dois ou mais tipos, a sequência deve ser explicitada antes da execução.

---

## 4. Hierarquia de fontes

Em tarefas pedagógicas do MAPP, use sempre esta ordem de prioridade:

1. instruções explícitas do professor;
2. materiais validados pelo professor;
3. programa da disciplina;
4. textos obrigatórios da aula;
5. fontes primárias:
   - artigos originais
   - livros
   - capítulos
   - documentos oficiais
6. rascunhos internos `.tex`, `.md`, `.qmd`, `.Rmd`;
7. resumos derivados ou notas auxiliares.

Regras obrigatórias:

1. um resumo em markdown nunca substitui o artigo original quando houver números, coeficientes, estatísticas, interpretações causais ou citações;
2. quando duas versões do deck divergirem, deve-se definir uma versão canônica antes de editar;
3. nenhum dado empírico deve ser incorporado sem conferência na fonte primária;
4. se faltar uma fonte obrigatória, a fase deve parar antes da implementação.

---

## 5. Princípio geral do fluxo

Cada fase deve seguir um ciclo curto e auditável.  
A lógica é:

1. solicitar plano da fase;
2. validar o plano;
3. autorizar a execução;
4. executar apenas a fase aprovada;
5. auditar a entrega;
6. aprovar ou corrigir;
7. só então abrir a próxima fase.

Esse ciclo vale tanto para tarefas técnicas quanto para produção pedagógica.

---

## 6. Ciclo-padrão de cada fase

## Etapa A. Definição do escopo imediato

Antes de qualquer ação, registrar:

- qual é a fase;
- qual é o artefato a ser produzido;
- qual é o material de base;
- o que está fora do escopo.

Sem isso, a fase não começa.

---

## Etapa B. Solicitação do plano operacional

O agente executor deve apresentar apenas o plano da fase.

O plano deve informar:

1. objetivo da fase;
2. arquivos a consultar;
3. arquivos a criar ou modificar;
4. artefatos esperados;
5. critérios de validação;
6. itens explicitamente fora do escopo;
7. riscos ou dependências.

Nesta etapa, não se executa nada.

---

## Etapa C. Validação do plano

O professor submete o plano ao ChatGPT.  
O ChatGPT avalia:

- aderência ao `AGENTS.md`;
- aderência a este workflow;
- coerência com o escopo aprovado;
- pertinência pedagógica;
- riscos metodológicos;
- riscos editoriais;
- necessidade de reconciliação entre fontes ou rascunhos.

Sem validação, não há autorização.

---

## Etapa D. Autorização formal

Somente após a validação o professor autoriza a execução.

A autorização deve indicar:

- nome da fase;
- artefato autorizado;
- limites da fase;
- proibição de avançar para a fase seguinte.

---

## Etapa E. Execução da fase

O agente executor:

- edita apenas os arquivos autorizados;
- produz apenas os artefatos da fase;
- registra decisões relevantes;
- atualiza documentação mínima;
- não muda o escopo;
- não inicia novas fases por conta própria.

---

## Etapa F. Relatório de conclusão

Ao final, o agente executor deve informar:

1. arquivos criados ou modificados;
2. conteúdo principal implementado;
3. fontes efetivamente usadas;
4. outputs gerados;
5. testes ou verificações realizados;
6. pendências;
7. pontos que exigem decisão humana.

---

## Etapa G. Auditoria da entrega

O professor traz o relatório e, se necessário, trechos do material.

O ChatGPT avalia:

- se a fase foi realmente concluída;
- se o artefato corresponde ao plano;
- se há erros factuais;
- se há problemas de coerência didática;
- se houve extrapolação de escopo;
- se a próxima fase pode ser aberta.

---

## Etapa H. Aprovação ou correção

Depois da auditoria, há apenas três saídas possíveis:

1. fase aprovada;
2. fase aprovada com ressalvas documentadas;
3. fase devolvida para correção pontual.

Só depois disso o ciclo recomeça.

---

## 7. Fluxos específicos para produção pedagógica em MAPP

## 7.1. Fluxo para plano de aula

Sequência recomendada:

1. definir tema e posição da aula no curso;
2. definir objetivos de aprendizagem;
3. definir bibliografia obrigatória e complementar;
4. propor módulos com progressão lógica;
5. revisar aderência metodológica;
6. validar o plano antes de passar ao roteiro.

**Produto da fase:** plano estruturado da aula.  
**Não produzir ainda:** slides, script ou exercícios.

---

## 7.2. Fluxo para roteiro de aula

Sequência recomendada:

1. partir apenas do plano validado;
2. detalhar o encadeamento entre os módulos;
3. incluir transições, mensagens-chave e perguntas de checagem;
4. garantir que a linguagem esteja ajustada ao público;
5. revisar coerência com a bibliografia;
6. validar o roteiro antes do deck.

**Produto da fase:** roteiro detalhado da aula.  
**Não produzir ainda:** deck final, salvo autorização explícita.

---

## 7.3. Fluxo para deck de slides

Sequência recomendada:

1. partir do plano e do roteiro validados;
2. definir a sequência de slides;
3. atribuir função pedagógica a cada lâmina;
4. integrar fórmulas, DAGs, tabelas e figuras apenas quando tiverem função explicativa;
5. manter uma ideia principal por slide;
6. validar coerência do deck antes de gerar código final em `.tex`.

**Produto da fase:** estrutura do deck e conteúdo dos slides.  
**Produto posterior, se autorizado:** código Beamer.

---

## 7.4. Fluxo para integração de múltiplos rascunhos

Quando houver versões A, B, C ou notas auxiliares, o fluxo correto é:

1. definir a versão canônica;
2. tratar as demais como suplementos;
3. mapear:
   - sobreposição
   - conflito
   - adição única
   - conteúdo descartável
4. construir matriz de reconciliação;
5. só então fundir o material.

É proibido:

- concatenar arquivos diretamente;
- duplicar capa, objetivos, introduções e referências;
- reaproveitar números empíricos sem reconciliação com a fonte primária.

---

## 7.5. Fluxo para exercícios e listas

Sequência recomendada:

1. definir objetivo de aprendizagem;
2. definir tipo de exercício:
   - conceitual
   - interpretativo
   - computacional
   - metodológico
3. graduar a dificuldade;
4. indicar claramente o que o aluno deve entregar;
5. revisar se o exercício mede o objetivo definido.

---

## 8. Checkpoints obrigatórios de qualidade

Nenhuma fase pode ser aprovada sem passar por todos os checkpoints aplicáveis.

## 8.1. Checkpoint de escopo
Pergunta:
**a fase entregou exatamente o que foi autorizado?**

Verificar:

- aderência ao pedido;
- ausência de expansão indevida;
- respeito aos limites da fase.

---

## 8.2. Checkpoint factual
Pergunta:
**as afirmações factuais e empíricas estão corretas?**

Verificar:

- nomes;
- datas;
- definições;
- coeficientes;
- estatísticas;
- interpretações empíricas;
- fidelidade às fontes primárias.

---

## 8.3. Checkpoint pedagógico
Pergunta:
**o material ensina bem o que se propõe a ensinar?**

Verificar:

- clareza da progressão;
- densidade compatível com o público;
- bom uso de bullets;
- coerência entre conceito, exemplo e implicação;
- ausência de salto conceitual.

---

## 8.4. Checkpoint estrutural
Pergunta:
**o artefato é internamente coerente?**

Verificar:

- ausência de duplicações;
- boa ordem entre seções;
- ausência de bloco órfão;
- transições coerentes;
- título e subtítulo adequados.

---

## 8.5. Checkpoint de fontes e citações
Pergunta:
**o material está adequadamente ancorado em fontes?**

Verificar:

- citação no corpo quando apropriado;
- referências completas ao final;
- fonte indicada para figuras e tabelas;
- coerência entre texto e bibliografia.

---

## 8.6. Checkpoint técnico
Pergunta:
**o arquivo-fonte está utilizável e consistente?**

Verificar, quando aplicável:

- compilação limpa;
- ausência de preâmbulo duplicado;
- macros consistentes;
- `\includegraphics` apontando para os locais corretos;
- placeholders claros;
- nome de arquivo coerente.

---

## 9. Prompt-padrão para o agente executor

## 9.1. Prompt para pedir o plano de uma fase

```text
Leia o AGENTS.md e o Workflow-Projeto.md deste repositório.

Apresente o plano operacional da Fase X.

O plano deve informar:
1. objetivo da fase;
2. arquivos que serão consultados;
3. arquivos que poderão ser criados ou modificados;
4. artefatos esperados;
5. como a fase será validada;
6. o que ficará explicitamente fora do escopo;
7. riscos, conflitos de fonte ou dependências.

Não execute ainda. Aguarde autorização.