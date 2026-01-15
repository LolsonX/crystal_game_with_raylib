# crystal_game

A Crystal game project using raylib for graphics.

## Installation

```bash
# Clone with submodules
git clone --recurse-submodules <repo-url>
cd crystal_game_vibe

# Install dependencies and build raylib
make deps
```

## Building

This project uses a Makefile for building. Raylib is included as a git submodule.

### Commands

| Command | Description |
|---------|-------------|
| `make deps` | Install Crystal deps + build raylib from source |
| `make` | Build the project |
| `make run` | Build and run the game |
| `make clean` | Remove build artifacts |
| `make rebuild` | Clean and rebuild |
| `make setup-raylib` | Re-clone and rebuild raylib from source |
| `make help` | Show available targets |

### Custom Flags

Debug mode is default. Use `--release` for optimized builds.

```bash
# Release build (optimized)
make CRYSTAL_FLAGS='--release' run

# Custom CFLAGS for raylib
make CFLAGS='-O3 -march=native' build
```

## Raylib Version

Raylib is pinned to version **5.5** via git submodule.

To update:
```bash
make setup-raylib  # Re-clones and rebuilds raylib 5.5
```

## Development

1. Create a feature branch: `git checkout -b feature/<name>`
2. Make changes following [CONVENTIONS.md](CONVENTIONS.md)
3. Commit: `git commit -m "Add feature description"`
4. Push: `git push origin feature/<name>`

## Contributing

1. Fork it (https://github.com/LolsonX/crystal_game_with_raylib/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Karol Ostrowski](https://github.com/LolsonX) - creator and maintainer

## Kudos

Huge thanks to [Raysan5](https://github.com/raysan5) for creating and maintaining [raylib](https://www.raylib.com), an amazing and easy-to-use graphics library. This project wouldn't exist without it.
