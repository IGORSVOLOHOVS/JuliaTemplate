# julia-template

A project scaffold for Julia, plus the one command that stamps a new project out
of it.

## Use

```bash
./JuliaTemplate.sh          # Linux and macOS
JuliaTemplate.bat           # Windows
```

The script clones the GitHub copy of this repository into a temporary folder and
copies `template/` into `~/Projects/Task-<timestamp>`, so each run gives a fresh,
dated project rather than overwriting anything. It then runs `git init` there.
Nothing pushes from this Gitea copy to GitHub, so a change made here does not reach
new projects by itself.

## What the template contains

- `Project.toml`, the Julia project manifest, and `config.yaml`
- `src/Template.jl` and `src/jl/`, a small module that reads `config.yaml`, sets a
  console logger and opens an SQLite file under `build/`, and `src/notebook.ipynb`
- `test/runtests.jl`, `test/cover.jl` and `test/prof.jl`
- `Dockerfile` and `.dockerignore`, for a reproducible environment
- `.github/workflows/ci.yaml`, continuous integration from the first commit
- `docs/make.jl` and `docs/src/index.md`, Documenter.jl set up and ready
- `README.md`, a report skeleton with the chapters an assignment expects: problem
  domain analysis, business and functional requirements, use cases

The scaffold is aimed at coursework where the write-up matters as much as the
code, which is why the README template is a report outline rather than a
description of a program.

## What does not work yet

No gate runs anything in `template/`, and parts of it do not work as they stand:

- `test/runtests.jl` calls `Template.main()` with no `using Template`, so it ends
  in `UndefVarError`.
- `.github/workflows/ci.yaml` runs `src/jl/cov.jl`, which does not exist.
- `test/prof.jl` uses `PProf`, which `Project.toml` does not list.
- `Dockerfile` and `ci.yaml` use Julia 1.9, while `Project.toml` holds `Test` at
  1.11.0.

## Working on it

This repository ships no program. `.\recipe.ps1` is still its whole interface:
`.\recipe.ps1 test` runs pytest and ruff over `.claude`, and nothing over
`template/` or the two scripts, because the standard names no tools for Julia.
`.\recipe.ps1 info` prints the metadata. The other verbs print `nothing to <verb>`.
`CLAUDE.md` holds the rules.

## License

MIT. See [LICENSE](LICENSE). `template/LICENSE.txt` is the licence a stamped project
starts with.
