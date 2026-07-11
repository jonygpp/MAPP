suppressPackageStartupMessages({
  library(rmarkdown)
})

args <- commandArgs(trailingOnly = FALSE)
script_arg <- "--file="
script_path <- sub(script_arg, "", args[grep(script_arg, args)])

if (length(script_path) > 0) {
  project_root <- normalizePath(file.path(dirname(script_path), ".."))
  setwd(project_root)
}

if (!dir.exists("logs")) dir.create("logs", recursive = TRUE)
log_file <- file.path("logs", "lab07_phase3b_render_2026-03-27.log")

log_con <- file(log_file, open = "wt")
sink(log_con, split = TRUE)
sink(log_con, type = "message")

on.exit({
  sink(type = "message")
  sink()
  close(log_con)
}, add = TRUE)

cat("=== INÍCIO DA RENDERIZAÇÃO FASE 3B ===\n")
cat("Diretório de trabalho:", getwd(), "\n")

render(
  input = "docs/lab07_phase3b.Rmd",
  output_file = "lab07_phase3b.html",
  output_dir = "docs",
  envir = new.env(parent = globalenv())
)

cat("=== FIM DA RENDERIZAÇÃO FASE 3B ===\n")
