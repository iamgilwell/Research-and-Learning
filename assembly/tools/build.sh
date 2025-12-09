#!/bin/bash

# Assembly Build Helper Script
# Usage: ./build.sh filename.asm [debug]

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <filename.asm> [debug]"
    echo "Example: $0 hello.asm"
    echo "Example: $0 hello.asm debug"
    exit 1
fi

FILENAME="$1"
DEBUG_MODE="$2"
BASENAME=$(basename "$FILENAME" .asm)

# Check if file exists
if [ ! -f "$FILENAME" ]; then
    echo "Error: File '$FILENAME' not found!"
    exit 1
fi

echo "Building $FILENAME..."

# Assemble
if [ "$DEBUG_MODE" = "debug" ]; then
    echo "Assembling with debug info..."
    nasm -f elf32 -g -F dwarf "$FILENAME" -o "${BASENAME}.o"
else
    echo "Assembling..."
    nasm -f elf32 "$FILENAME" -o "${BASENAME}.o"
fi

# Link
echo "Linking..."
ld -m elf_i386 "${BASENAME}.o" -o "$BASENAME"

# Clean up object file
rm "${BASENAME}.o"

echo "Build complete: $BASENAME"

# If debug mode, show how to debug
if [ "$DEBUG_MODE" = "debug" ]; then
    echo ""
    echo "To debug, run:"
    echo "  gdb ./$BASENAME"
    echo "  (gdb) break _start"
    echo "  (gdb) run"
    echo "  (gdb) stepi"
fi
