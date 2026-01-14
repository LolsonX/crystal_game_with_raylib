RAYLIB_SRC := clibs/raylib/src
PROJECT_LIB := src/libraylib.a

CRYSTAL_FLAGS ?=
CFLAGS ?= -O2 -Wall

.PHONY: all build run clean deps rebuild help

all: build

help:
	@echo "Targets:"
	@echo "  make          - Build raylib and project"
	@echo "  make run      - Build and run the game"
	@echo "  make clean    - Remove build artifacts"
	@echo "  make rebuild  - Clean and rebuild"
	@echo "  make deps     - Install Crystal dependencies"
	@echo ""
	@echo "Custom flags:"
	@echo "  make CRYSTAL_FLAGS='--release' build  # Release build"
	@echo "  make CFLAGS='-O3 -march=native' build"

deps:
	shards install

build: $(PROJECT_LIB)
	shards build $(CRYSTAL_FLAGS)

$(PROJECT_LIB): $(RAYLIB_SRC)/libraylib.a
	@echo "Copying libraylib.a to src/"
	cp $(RAYLIB_SRC)/libraylib.a $(PROJECT_LIB)

$(RAYLIB_SRC)/libraylib.a:
	@echo "Building raylib..."
	cd $(RAYLIB_SRC) && $(MAKE) CFLAGS="$(CFLAGS)"

run: build
	./bin/crystal_game

clean:
	rm -f $(PROJECT_LIB)
	shards clean
	cd $(RAYLIB_SRC) && $(MAKE) clean 2>/dev/null || true

rebuild: clean build
