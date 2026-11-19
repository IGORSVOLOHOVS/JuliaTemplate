# julia-template: software requirements specification

Reverse-engineered from the code at commit `26fc43e` on 2026-11-18. Documentation hub:
[docs/README.md](docs/README.md).

## 1. Purpose and scope

**In scope:**
- the stamping scripts `JuliaTemplate.sh` and `JuliaTemplate.bat`;
- the scaffold under `template/` that they copy: Julia module `Template`, config,
  tests, docs build, Dockerfile, CI workflow and report skeleton.

**Out of scope:**
- the lab tooling shared with repo-quality-template (`recipe.ps1`, `.claude/`, `.gitea/`);
- the content a user writes into a stamped project.

## 2. Context

| Element | Description | Source |
|---|---|---|
| Actor: person running the script | Starts `JuliaTemplate.sh` or `.bat`. `README.md` names coursework as the use | `README.md` |
| GitHub repository | `https://github.com/IGORSVOLOHOVS/JuliaTemplate.git`. The scripts clone it, not the local checkout | `JuliaTemplate.sh:7`, `JuliaTemplate.bat:22` |
| git | Clone, sparse-checkout, `git init` | `JuliaTemplate.sh:17-29` |
| VS Code (optional) | Opens the new project | `JuliaTemplate.sh:32-36`, `JuliaTemplate.bat:80` |
| Runtime, scripts | Bash with `date`, `mktemp` and `cp`; or Windows cmd with `wmic`, `xcopy` and `rmdir` | the two scripts |
| Runtime, stamped project | Julia (1.9 per `template/Dockerfile:1`; `Test` compat 1.11.0 per `template/Project.toml:21`), optionally Docker and GitHub Actions | as cited |

## 3. Functional requirements

### 3.1 Stamping a project

- **FR-1** The system shall build a timestamp in the form `YYYYMMDD-HHMMSS` from local time.
  Source: `JuliaTemplate.sh:4`, `JuliaTemplate.bat:4-19`. Verification: no test.
- **FR-2** The system shall create the directory `$HOME/Projects/Task-<timestamp>`
  (`%USERPROFILE%\Projects\Task-<timestamp>` on Windows), including missing parents.
  Source: `JuliaTemplate.sh:11-14`, `JuliaTemplate.bat:25-32`. Verification: no test.
- **FR-3** The system shall clone the GitHub repository with `-n --depth=1 --filter=tree:0`
  into a temporary directory and check out only `template/` through a non-cone sparse checkout.
  Source: `JuliaTemplate.sh:17-22`. Verification: no test.
- **FR-4** The system shall copy the contents of `template/`, including hidden files, into
  the target directory. Source: `JuliaTemplate.sh:25`, `JuliaTemplate.bat:60`. Verification: no test.
- **FR-5** The system shall run `git init` in the target directory.
  Source: `JuliaTemplate.sh:28-29`. Verification: no test.
- **FR-6** The system shall open the target directory in VS Code. The Bash script does this
  only when `code` is on `PATH`; otherwise it prints a skip message.
  Source: `JuliaTemplate.sh:32-36`, `JuliaTemplate.bat:80`. Verification: no test.
- **FR-7** The system shall delete the temporary clone, print a warning if deletion fails,
  and print the project path on success. Source: `JuliaTemplate.sh:39-41`,
  `JuliaTemplate.bat:83-89`. Verification: no test.
- **FR-8** The system shall stop with exit code 1 and a message naming the failed step
  when directory creation, clone, sparse checkout, checkout, copy or `git init` fails.
  Source: `JuliaTemplate.sh:14-29`. Verification: no test.

### 3.2 Template module

- **FR-9** The module shall, when loaded, read `config.yaml` from the current directory
  and expose its `name` key as `config_name`. Source: `template/src/jl/config.jl:4-6`. Verification: no test.
- **FR-10** The module shall, when loaded, install a `ConsoleLogger` as the global logger
  and log `Log is working!` at info level. Source: `template/src/jl/log.jl:3-7`. Verification: no test.
- **FR-11** The module shall, when loaded, create `build/` if it is missing and open the
  SQLite database `build/tmp.db` as `db`. Source: `template/src/jl/db.jl:3-7`. Verification: no test.
- **FR-12** `Template.main()` shall print `config_name`. Source: `template/src/Template.jl:6-8`.
  Verification: `template/test/runtests.jl` "Template test" (does not run as written; see 3.4).

### 3.3 Developer support files

- **FR-13** `test/cover.jl` shall process `src`, `test`, `docs` and `build` with
  Coverage.jl and write `coverage.info` in LCOV format. Source: `template/test/cover.jl:3-8`. Verification: no test.
- **FR-14** `test/prof.jl` shall profile `Template.main()` and call `pprof()`.
  Source: `template/test/prof.jl:4-10`. Verification: no test.
- **FR-15** `docs/make.jl` shall build Documenter docs with site name `Template.jl` and
  `remotes = nothing`. Source: `template/docs/make.jl:4`. Verification: no test.
- **FR-16** `src/jl/lib/install.jl` shall activate the current directory as a project,
  `Pkg.add` the ten listed packages, then instantiate and precompile.
  Source: `template/src/jl/lib/install.jl:1-14`. Verification: no test.

### 3.4 Declared but not implemented

| Item | Declared where | State |
|---|---|---|
| Passing test suite | `template/test/runtests.jl` | No `using Template`, so `UndefVarError` (`README.md`) |
| CI test run | `template/.github/workflows/ci.yaml:24` | Runs `src/jl/cov.jl`, which does not exist |
| Docker image that runs tests | `template/Dockerfile:9` | `.dockerignore:2` excludes `test/` (inference: `Pkg.test()` finds no tests) |
| Network services on ports 8000 and 514 | `template/Dockerfile:6-7` | No code opens a socket |
| CLI argument parsing | `ArgParse` in `template/Project.toml:7` | No `.jl` file uses it |
| Syslog logging, Revise, PackageCompiler builds | `template/Project.toml` | Declared, not used in code |
| Report chapters: use case, component diagram, ERD, file structure | `template/README.md:15,95,98,108` | Marked "(not implemented)" |

## 4. Interfaces

| Interface | Form | Source |
|---|---|---|
| `./JuliaTemplate.sh` | No arguments. Exit 0 on success, 1 on a failed step | `JuliaTemplate.sh` |
| `JuliaTemplate.bat` | No arguments. Waits on `pause` at the end and after errors | `JuliaTemplate.bat` |
| `Template.main()` | Julia function, no arguments, prints to stdout | `template/src/Template.jl:6` |
| `config.yaml` | YAML mapping, key `name` (string) | `template/config.yaml:1` |
| `build/tmp.db` | SQLite file, no schema defined | `template/src/jl/db.jl:7` |
| `coverage.info` | LCOV output of `test/cover.jl` | `template/test/cover.jl:8` |
| CI trigger | push / pull_request on `main` | `template/.github/workflows/ci.yaml:3-7` |

## 5. Data

- `config.yaml`: one entry, `name: 'Template'`.
- `build/tmp.db`: SQLite database the module opens. No tables are created.
- `games.csv`: the notebook reads it (`template/src/notebook.ipynb`, cell 4). It is not in
  the repository, and `template/.gitignore` excludes `*.csv`, `*.db` and `/build/`.

## 6. Non-functional requirements

- **NFR-1** Each run writes to a new directory named with a second-resolution timestamp,
  so earlier projects are not overwritten. Source: `JuliaTemplate.sh:4,11`.
- **NFR-2** The clone transfers only the tip commit and the trees it needs (`--depth=1 --filter=tree:0`).
  Source: `JuliaTemplate.sh:17`.
- **NFR-3** In the stamped project, `Manifest.toml`, coverage, profile and database
  outputs are git-ignored. Source: `template/.gitignore:2-15,34,40`.
- **NFR-4** This repository carries the repo-quality-template tooling. Its test verb covers
  `.claude` only, not `template/` or the scripts. Source: `recipe.ps1:41-55`, `README.md`.

## 7. Constraints and dependencies

There is no lock file: `Manifest.toml` is ignored (`template/.gitignore:13`). From
`template/Project.toml`:

| Package | Compat |
|---|---|
| ArgParse | 1.2.0 |
| Test | 1.11.0 |
| Coverage, Documenter, Logging, PackageCompiler, Profile, Revise, SQLite, SyslogLogging, YAML | none |

Used but not declared: `PProf` (`test/prof.jl:2`) and the packages in
`src/jl/lib/datascience.jl:2-11` (DataFrames, CSV, Makie, GLMakie, Distributions, MLJ,
Clustering, StatsBase). Statistics, Random and LinearAlgebra are standard libraries, also not declared.
Julia version: `julia:1.9` (`template/Dockerfile:1`), `1.9` (`ci.yaml:18`), notebook kernel
`Julia 1.11.0-rc3` (notebook metadata).

## 8. Acceptance

1. Run `./JuliaTemplate.sh` (or `.bat`). Check that `~/Projects/Task-<timestamp>` exists,
   holds the files of `template/` including `.github/` and `.gitignore`, and contains a
   `.git` directory. Check that the temporary clone is gone (FR-1 to FR-8).
2. In the stamped project, run `julia --project=. -e 'using Template; Template.main()'`.
   This command is not in the project files; it is an acceptance step proposed here.
   Expect the info log line and `Template` on stdout, and `build/tmp.db` created (FR-9 to FR-12).
3. Items in 3.4 are expected to fail until fixed.

## 9. Open questions

- Who uses the scaffold beyond "coursework" (`README.md`), and which Julia version is the target: 1.9 or 1.11?
- What are ports 8000 and 514 in the `Dockerfile` for? 514 is the syslog port (inference), and `SyslogLogging` is a dependency, but no code uses either.
- Should the scripts clone GitHub, while `README.md` says changes made on the Gitea copy do not reach it?
- Should `ci.yaml` run `test/cover.jl` or `Pkg.test()`? Which one is meant by `src/jl/cov.jl`?
- Should `datascience.jl`'s packages be declared in `Project.toml`, or is the notebook expected to run `install.jl` first, which does not add them either?
- Should `git init` in the scripts name the initial branch `main` to match the CI trigger?
