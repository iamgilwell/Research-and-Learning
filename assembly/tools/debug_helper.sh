#!/bin/bash

# GDB Debug Helper for Assembly Programs
# Usage: ./debug_helper.sh program_name

if [ $# -eq 0 ]; then
    echo "Usage: $0 <program_name>"
    echo "Example: $0 hello"
    exit 1
fi

PROGRAM="$1"

if [ ! -f "$PROGRAM" ]; then
    echo "Error: Program '$PROGRAM' not found!"
    echo "Make sure to build with debug info: ./build.sh program.asm debug"
    exit 1
fi

echo "Starting GDB session for $PROGRAM"
echo "Useful GDB commands:"
echo "  break _start     - Set breakpoint at program start"
echo "  run              - Start program execution"
echo "  stepi            - Step one instruction"
echo "  info registers   - Show all register values"
echo "  x/4xw \$esp      - Examine stack (4 words in hex)"
echo "  x/s address      - Examine string at address"
echo "  continue         - Continue execution"
echo "  quit             - Exit GDB"
echo ""

gdb "$PROGRAM"
