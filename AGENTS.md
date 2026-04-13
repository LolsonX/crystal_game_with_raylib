# AGENTS.md

## Commands

- `make deps` — install Crystal shards + build raylib from source (required first)
- `make run` — build and run game
- `make` — build only
- `crystal spec` — run all tests
- `crystal spec spec/game/entities/tile_spec.cr` — run single test file
- `bin/ameba` — lint (Crystal static analyzer)
- `bin/ameba --fix` — auto-fix lint issues
- `crystal tool format` — format code (no config file; uses Crystal defaults)

## Architecture

- **Entry point**: `src/game_main.cr` → `Game.new.run`
- **Game core**: `src/game/game.cr` — assembles layer stack and runs main loop
- **Raylib bindings**: `src/raylib/` — Crystal FFI bindings to raylib C library
- **Raylib C source**: `clibs/raylib/` — git submodule (pinned to v5.5), built into `src/libraylib.a`
- **Key game modules** (all under `src/game/`):
  - `core/` — geometry, style primitives
  - `entities/` — game objects (tiles, etc.)
  - `events/` — event bus system (`Events::Bus`)
  - `layers/` — renderable/updateable layer stack
  - `ui/` — UI components (buttons, etc.)
  - `debug/` — debug overlay registry
  - `traits/` — shared behaviors (WorldDrawable, ScreenDrawable, Updateable, Eventable)
  - `macros/` — Crystal macros
  - `settings/` — config

## Testing

- Tests mock all raylib calls via `spec/spec_helper.cr` — no window/display needed
- `Spec.before_each` resets event bus, debug registry, mouse position, frame time, and window state
- Mirror `src/game/` structure in `spec/game/`

## Testing conventions (CONVENTIONS.md)

- Gherkin-style BDD: `describe` / `context` / `it`
- **Do NOT test**: property assignment, getter delegation, singleton identity, Hash/Array ops, default params, array accumulation
- **DO test**: algorithms/calculations, business rules, custom methods w/ logic, integration btw components, edge cases/error handling

## Style

- 2-space indentation, LF line endings, trim trailing whitespace (`.editorconfig`)
- Branch naming: `feature/<name>`
- Commit format: imperative subject line, optional body (no conventional commits prefix)

