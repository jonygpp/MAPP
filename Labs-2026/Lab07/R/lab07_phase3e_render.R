# R/lab07_phase3e_render.R
# Fase 3E — Renderização do laboratório final
# Lab07 MAPP 2026 — Miguel, Satyanath e Sergenti (2004)
# Autor: Agente executor IA | Data: 2026-03-27
#
# Uso:
#   Rscript R/lab07_phase3e_render.R
# OU (recomendado, evita quirk de terminal):
#   Rscript -e 'rmarkdown::render("docs/lab07_phase3e.Rmd", output_file="lab07_phase3e.html", output_dir="docs", envir=new.env(parent=globalenv()))'
#
# Pré-requisitos: todos os outputs das Fases 3B e 3D devem estar em outputs/.
# Output: docs/lab07_phase3e.html

rmarkdown::render(
  input       = "docs/lab07_phase3e.Rmd",
  output_file = "lab07_phase3e.html",
  output_dir  = "docs",
  envir       = new.env(parent = globalenv())
)
