#!/bin/bash

# Simple test script for assembly tutorial

echo "Testing Assembly Tutorial..."
echo "=========================="

# Test building examples
echo "Building examples..."
make examples

# Test running hello program
echo "Testing hello program..."
if ./build/01-hello > /dev/null; then
    echo "✓ Hello program works"
else
    echo "✗ Hello program failed"
fi

# Test calculator program
echo "Testing calculator program..."
if ./build/02-calculator > /dev/null; then
    echo "✓ Calculator program works"
else
    echo "✗ Calculator program failed"
fi

# Test bitops program
echo "Testing bitops program..."
if ./build/03-bitops > /dev/null; then
    echo "✓ Bitops program works"
else
    echo "✗ Bitops program failed"
fi

echo "All tests completed!"
