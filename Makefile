RAYLIB_SRC := clibs/raylib/src
RAYLIB_A := $(RAYLIB_SRC)/libraylib.a

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
	@echo "  make deps     - Install Crystal dependencies + build raylib"
	@echo "  make setup-raylib - Re-clone and rebuild raylib from source"
	@echo ""
	@echo "Custom flags:"
	@echo "  make CRYSTAL_FLAGS='--release' build  # Release build"
	@echo "  make CFLAGS='-O3 -march=native' build"

deps: $(RAYLIB_A)
	shards install

$(RAYLIB_A):
	@echo "Building raylib from source..."
	cd $(RAYLIB_SRC) && $(MAKE) CUSTOM_CFLAGS="$(CFLAGS)" -j$$(nproc)

src/libraylib.a: $(RAYLIB_A)
	@echo "Copying libraylib.a to src/"
	cp $< $@

build: src/libraylib.a
	shards build $(CRYSTAL_FLAGS)

setup-raylib:
	@echo "Removing old raylib..."
	rm -rf clibs/raylib
	@echo "Cloning raylib 5.5..."
	git clone --branch 5.5 --depth 1 https://github.com/raysan5/raylib.git clibs/raylib
	@echo "Building raylib..."
	cd $(RAYLIB_SRC) && $(MAKE) CUSTOM_CFLAGS="$(CFLAGS)" -j$$(nproc)
	@echo "Raylib setup complete."

run: build
	./bin/crystal_game

clean:
	rm -f src/libraylib.a $(RAYLIB_A)
	find $(RAYLIB_SRC) -name "*.o" -delete 2>/dev/null || true
	rm -rf bin/
	rm -rf .crystal/

rebuild: clean build
