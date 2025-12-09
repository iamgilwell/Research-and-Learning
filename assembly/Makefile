# Assembly Tutorial Makefile

# Default target
.PHONY: all clean test help examples

# Variables
ASM = nasm
ASMFLAGS = -f elf32
ASMFLAGS_DEBUG = -f elf32 -g -F dwarf
LD = ld
LDFLAGS = -m elf_i386

# Source directories
EXAMPLES_DIR = examples
SOLUTIONS_DIR = solutions
BUILD_DIR = build

# Create build directory
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Pattern rule for assembly files
$(BUILD_DIR)/%.o: $(EXAMPLES_DIR)/%.asm | $(BUILD_DIR)
	$(ASM) $(ASMFLAGS) $< -o $@

$(BUILD_DIR)/%: $(BUILD_DIR)/%.o
	$(LD) $(LDFLAGS) $< -o $@

# Build all examples
examples: $(BUILD_DIR) \
	$(BUILD_DIR)/01-hello \
	$(BUILD_DIR)/02-calculator \
	$(BUILD_DIR)/03-bitops \
	$(BUILD_DIR)/04-datatypes \
	$(BUILD_DIR)/05-functions

# Build solutions
solutions: $(BUILD_DIR) \
	$(BUILD_DIR)/exercise01 \
	$(BUILD_DIR)/exercise02 \
	$(BUILD_DIR)/exercise03 \
	$(BUILD_DIR)/exercise04

$(BUILD_DIR)/exercise01: $(SOLUTIONS_DIR)/exercise01.asm | $(BUILD_DIR)
	$(ASM) $(ASMFLAGS) $< -o $(BUILD_DIR)/exercise01.o
	$(LD) $(LDFLAGS) $(BUILD_DIR)/exercise01.o -o $@

$(BUILD_DIR)/exercise02: $(SOLUTIONS_DIR)/exercise02.asm | $(BUILD_DIR)
	$(ASM) $(ASMFLAGS) $< -o $(BUILD_DIR)/exercise02.o
	$(LD) $(LDFLAGS) $(BUILD_DIR)/exercise02.o -o $@

$(BUILD_DIR)/exercise03: $(SOLUTIONS_DIR)/exercise03.asm | $(BUILD_DIR)
	$(ASM) $(ASMFLAGS) $< -o $(BUILD_DIR)/exercise03.o
	$(LD) $(LDFLAGS) $(BUILD_DIR)/exercise03.o -o $@

$(BUILD_DIR)/exercise04: $(SOLUTIONS_DIR)/exercise04.asm | $(BUILD_DIR)
	$(ASM) $(ASMFLAGS) $< -o $(BUILD_DIR)/exercise04.o
	$(LD) $(LDFLAGS) $(BUILD_DIR)/exercise04.o -o $@

# Run tests
test:
	cd tests && ./run_tests.sh all

# Test specific module
test-module1:
	cd tests && ./run_tests.sh module01

test-module2:
	cd tests && ./run_tests.sh module02

test-module3:
	cd tests && ./run_tests.sh module03

# Clean build artifacts
clean:
	rm -rf $(BUILD_DIR)
	rm -f *.o

# Build everything
all: examples solutions

# Help target
help:
	@echo "Assembly Tutorial Makefile"
	@echo "=========================="
	@echo "Available targets:"
	@echo "  examples     - Build all example programs"
	@echo "  solutions    - Build all exercise solutions"
	@echo "  all          - Build examples and solutions"
	@echo "  test         - Run all tests"
	@echo "  test-module1 - Test module 1 only"
	@echo "  test-module2 - Test module 2 only"
	@echo "  test-module3 - Test module 3 only"
	@echo "  clean        - Remove build artifacts"
	@echo "  help         - Show this help message"
	@echo ""
	@echo "To build a specific file:"
	@echo "  make $(BUILD_DIR)/01-hello"
	@echo ""
	@echo "To run a program:"
	@echo "  ./$(BUILD_DIR)/01-hello"
