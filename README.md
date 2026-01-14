# crystal_game

A Crystal game project using raylib for graphics.

## Installation

```bash
shards install
```

## Building

This project uses a Makefile for building. Raylib is bundled and compiled automatically.

### Commands

| Command | Description |
|---------|-------------|
| `make` | Build raylib and the project |
| `make run` | Build and run the game |
| `make clean` | Remove build artifacts |
| `make rebuild` | Clean and rebuild |
| `make deps` | Install Crystal dependencies |
| `make help` | Show available targets |

### Custom Flags

Debug mode is default. Use `--release` for optimized builds.

```bash
# Release build (optimized)
make CRYSTAL_FLAGS='--release' run

# Custom CFLAGS for raylib
make CFLAGS='-O3 -march=native' build
```

## Development

1. Create a feature branch: `git checkout -b feature/<name>`
2. Make changes following [CONVENTIONS.md](CONVENTIONS.md)
3. Commit: `git commit -m "Add feature description"`
4. Push: `git push origin feature/<name>`

## Contributing

1. Fork it (https://github.com/your-github-user/crystal_game/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Karol Ostrowski](https://github.com/your-github-user) - creator and maintainer
