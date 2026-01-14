# Git Conventions

## Branch Naming
feature/<name>
- Example: feature/build-system
- Create: git checkout -b feature/<name>

## Commit Format (Option B)
<subject>

<body (optional)>

Example:
```
Add Makefile build system

Build raylib, compile project, and run with single command:
- make (builds raylib and project)
- make run (builds and executes)
- make clean (removes artifacts)
```

## Common Commands
git checkout -b feature/<name>  # Create branch
git add <files>                 # Stage changes
git commit -m "message"         # Commit
git log --oneline               # View history
git branch                      # List branches

## Submodules

This project uses raylib as a git submodule (`clibs/raylib`).

### Cloning with Submodules
```bash
# Clone with submodules
git clone --recurse-submodules <repo-url>

# Or if already cloned without submodules
git submodule update --init --recursive
```

### Updating Submodules
```bash
# Update to latest in current branch
git submodule update --remote clibs/raylib

# Update to specific tag/branch
cd clibs/raylib
git fetch --all
git checkout 5.5
cd ../..
git add clibs/raylib
git commit -m "Update raylib to 5.5"
```

### Build Commands
```bash
make deps          # Install deps + build raylib from source
make setup-raylib  # Re-clone and rebuild raylib
make run           # Build project + run
make clean         # Remove artifacts
```
