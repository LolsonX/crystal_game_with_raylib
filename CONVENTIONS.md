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

# Testing Conventions

## Test Style: Gherkin-style BDD

```crystal
describe "System under test" do        # Given: the component
  context "when a condition/scenario" do  # When: the trigger
    it "produces the expected outcome" do # Then: the result
    end
  end
end
```

## What NOT to Test

Avoid testing language/runtime behavior. These tests provide no value and increase maintenance burden.

### 1. Property Assignment Tests
Crystal's `property` and `getter` macros work by definition.

```crystal
# BAD - tests Crystal language feature
it "stores the x coordinate" do
  tile = Entities::Tile.new(x: 5, y: 10)
  tile.x.should eq(5)
end

# GOOD - skip, trust the language
```

### 2. Simple Getter Delegation
Methods that just delegate to another object's property.

```crystal
# BAD - tests trivial delegation
it "returns world_x from world position" do
  mouse_pos.world_x.should eq(123.5_f32)
end

# GOOD - skip, the implementation is self-evident
# def world_x; world_position.x; end
```

### 3. Singleton Pattern Tests
Singleton returns same instance - this is the pattern's guarantee.

```crystal
# BAD - tests singleton implementation
it "returns the same instance on every call" do
  DebugRegistry.instance.should be(DebugRegistry.instance)
end

# GOOD - skip, trust the pattern
```

### 4. Hash/Collection Operations
Crystal's Hash and Array work as documented.

```crystal
# BAD - tests Hash#[]=
it "stores the definition by key" do
  DebugRegistry.register("fps", "FPS", "perf")
  DebugRegistry.instance.definitions.has_key?("fps").should be_true
end

# BAD - tests Hash#[]?
it "returns nil for unknown key" do
  DebugRegistry.get("unknown").should be_nil
end

# GOOD - skip, trust the standard library
```

### 5. Default Parameter Values
Default constructor params are assignments.

```crystal
# BAD - tests default param
it "sets padding_top to 5" do
  location = DebugConfig::Location.new
  location.padding_top.should eq(5)
end

# GOOD - skip, the default is in the signature
# def initialize(@padding_top : Int32 = 5)
```

### 6. Array Accumulation
`Array#<<` and `Array#size` work by definition.

```crystal
# BAD - tests Array operations
it "adds the event to the events array" do
  obj.publish_event(event1)
  obj.publish_event(event2)
  obj.events.size.should eq(2)
end

# GOOD - skip, Array works
```

## What TO Test

### 1. Algorithms and Calculations
Business logic that transforms data.

```crystal
# GOOD - tests isometric conversion algorithm
it "calculates iso_x as (x - y) * WIDTH / 2" do
  tile = Entities::Tile.new(x: 3, y: 1)
  expected = (3 - 1) * Entities::Tile::WIDTH // 2
  tile.iso_x.should eq(expected)
end
```

### 2. Business Rules
Application-specific rules and constraints.

```crystal
# GOOD - tests priority dispatch rule
it "dispatches highest priority first" do
  bus.subscribe(low_handler, Events::KeyPressed, priority: 5)
  bus.subscribe(high_handler, Events::KeyPressed, priority: 20)
  bus.publish(Events::KeyPressed.new)
  order.should eq([2, 1])  # high before low
end
```

### 3. Custom Methods with Logic
Methods containing actual implementation code.

```crystal
# GOOD - tests custom equality with nil handling
it "considers any tile unequal to nil" do
  tile = Entities::Tile.new(x: 0, y: 0)
  tile.should_not eq(nil)
end

# GOOD - tests epsilon comparison
it "returns true for positions within EPSILON tolerance" do
  pos1.roughly_equals?(pos2).should be_true
end
```

### 4. Integration Between Components
How components interact.

```crystal
# GOOD - tests event flow from object to bus
it "publishes events to the global event bus" do
  obj.publish_event(event)
  obj.process_events
  received.should be_true
end
```

### 5. Edge Cases and Error Handling
Boundary conditions and error states.

```crystal
# GOOD - tests error on duplicate priority
it "raises ArgumentError when duplicate priority registered" do
  expect_raises(ArgumentError) do
    bus.subscribe(handler2, Events::KeyPressed, priority: 10)
  end
end

# GOOD - tests boundary
it "returns nil for coordinates outside map bounds" do
  map.tile_at(-1, 0).should be_nil
  map.tile_at(5, 0).should be_nil
end
```

## Summary

| Test Type | Decision |
|-----------|----------|
| Property assignment | ❌ Skip |
| Getter delegation | ❌ Skip |
| Singleton identity | ❌ Skip |
| Hash/Array ops | ❌ Skip |
| Default params | ❌ Skip |
| Algorithms | ✅ Test |
| Business rules | ✅ Test |
| Custom methods | ✅ Test |
| Integration | ✅ Test |
| Edge cases | ✅ Test |
