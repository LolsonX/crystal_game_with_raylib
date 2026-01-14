RAYLIB_SRC := clibs/raylib/src
RAYLIB_OBJECTS := $(wildcard $(RAYLIB_SRC)/*.o)
RAYLIB_A := $(RAYLIB_SRC)/libraylib.a

CRYSTAL_FLAGS ?=
CFLAGS ?= -O2 -Wall

.PHONY: all build run clean deps rebuild help ensure-raylib setup-raylib

all: build

help:
	@echo "Targets:"
	@echo "  make          - Build raylib and project"
	@echo "  make run      - Build and run the game"
	@echo "  make clean    - Remove build artifacts"
	@echo "  make rebuild  - Clean and rebuild"
	@echo "  make deps     - Install Crystal dependencies + ensure raylib"
	@echo "  make setup-raylib - Download and setup raylib from source"
	@echo ""
	@echo "Custom flags:"
	@echo "  make CRYSTAL_FLAGS='--release' build  # Release build"
	@echo "  make CFLAGS='-O3 -march=native' build"

$(RAYLIB_A): $(RAYLIB_OBJECTS)
	@echo "Creating libraylib.a from object files..."
	ar rcs $@ $(RAYLIB_OBJECTS)

src/libraylib.a: $(RAYLIB_A)
	@echo "Copying libraylib.a to src/"
	cp $< $@

.PHONY: ensure-raylib
ensure-raylib: src/libraylib.a
	@echo "Raylib ready."

deps: ensure-raylib
	shards install

build: src/libraylib.a
	shards build $(CRYSTAL_FLAGS)

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
	rm -f src/libraylib.a $(RAYLIB_A)
	shards clean

rebuild: clean build
