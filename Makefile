RAYLIB_SRC := clibs/raylib/src
PROJECT_LIB := src/libraylib.a
RAYLIB_OBJECTS := $(wildcard $(RAYLIB_SRC)/*.o)

CRYSTAL_FLAGS ?=
CFLAGS ?= -O2 -Wall

.PHONY: all build run clean deps rebuild help setup-raylib

all: build

help:
	@echo "Targets:"
	@echo "  make          - Build raylib and project"
	@echo "  make run      - Build and run the game"
	@echo "  make clean    - Remove build artifacts"
	@echo "  make rebuild  - Clean and rebuild"
	@echo "  make deps     - Install Crystal dependencies"
	@echo "  make setup-raylib - Download and setup raylib from source"
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

$(RAYLIB_SRC)/libraylib.a: $(RAYLIB_OBJECTS)
	@echo "Creating libraylib.a from object files..."
	ar rcs $@ $(RAYLIB_OBJECTS)

setup-raylib:
	@echo "Cloning raylib..."
	git clone --depth=1 https://github.com/raysan5/raylib.git /tmp/raylib-build
	@echo "Building raylib..."
	cd /tmp/raylib-build/src && $(MAKE) CFLAGS="$(CFLAGS)" -j$$(nproc)
	@echo "Installing raylib to clibs/raylib/src..."
	rm -rf clibs/raylib/src
	cp -r /tmp/raylib-build/src clibs/raylib/
	rm -rf /tmp/raylib-build
	@echo "Raylib setup complete."

run: build
	./bin/crystal_game

clean:
	rm -f $(PROJECT_LIB)
	shards clean

rebuild: clean build
