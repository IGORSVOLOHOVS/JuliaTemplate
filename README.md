# JuliaTemplate

A project scaffold for Julia, plus the one command that stamps a new project out
of it.

## Use

```bash
./JuliaTemplate.sh          # Linux and macOS
JuliaTemplate.bat           # Windows
```

The script clones this repository into a temporary directory and copies
`template/` into `~/Projects/Task-<timestamp>`, so each run gives a fresh,
dated project rather than overwriting anything.

## What the template contains

- `Project.toml` - the Julia project manifest
- `Dockerfile` and `.dockerignore` - a reproducible environment
- `.github/workflows/ci.yaml` - continuous integration from the first commit
- `docs/make.jl` and `docs/src/index.md` - Documenter.jl set up and ready
- `config.yaml`
- `README.md` - a report skeleton with the chapters an assignment expects:
  problem domain analysis, business and functional requirements, use cases

The scaffold is aimed at coursework where the write-up matters as much as the
code, which is why the README template is a report outline rather than a
description of a program.
