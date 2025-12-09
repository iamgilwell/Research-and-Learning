#!/bin/bash

# Assembly Tutorial Test Runner
# Usage: ./run_tests.sh [module_name|all]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
TESTS_PASSED=0
TESTS_FAILED=0

# Function to print colored output
print_status() {
    local status=$1
    local message=$2
    
    if [ "$status" = "PASS" ]; then
        echo -e "${GREEN}[PASS]${NC} $message"
        ((TESTS_PASSED++))
    elif [ "$status" = "FAIL" ]; then
        echo -e "${RED}[FAIL]${NC} $message"
        ((TESTS_FAILED++))
    elif [ "$status" = "INFO" ]; then
        echo -e "${YELLOW}[INFO]${NC} $message"
    fi
}

# Function to test if a file can be assembled and linked
test_assembly_file() {
    local file=$1
    local name=$(basename "$file" .asm)
    
    print_status "INFO" "Testing $file"
    
    # Try to assemble
    if nasm -f elf32 "$file" -o "/tmp/${name}.o" 2>/dev/null; then
        # Try to link
        if ld -m elf_i386 "/tmp/${name}.o" -o "/tmp/${name}" 2>/dev/null; then
            print_status "PASS" "$name assembles and links successfully"
            # Clean up
            rm -f "/tmp/${name}.o" "/tmp/${name}"
            return 0
        else
            print_status "FAIL" "$name fails to link"
            rm -f "/tmp/${name}.o"
            return 1
        fi
    else
        print_status "FAIL" "$name fails to assemble"
        return 1
    fi
}

# Function to test example execution
test_example_execution() {
    local file=$1
    local name=$(basename "$file" .asm)
    
    print_status "INFO" "Testing execution of $name"
    
    # Assemble and link
    if nasm -f elf32 "$file" -o "/tmp/${name}.o" 2>/dev/null && \
       ld -m elf_i386 "/tmp/${name}.o" -o "/tmp/${name}" 2>/dev/null; then
        
        # Run the program and check exit status
        if "/tmp/${name}" >/dev/null 2>&1; then
            local exit_code=$?
            if [ $exit_code -eq 0 ]; then
                print_status "PASS" "$name executes successfully (exit code: $exit_code)"
            else
                print_status "FAIL" "$name exits with non-zero code: $exit_code"
            fi
        else
            print_status "FAIL" "$name execution failed"
        fi
        
        # Clean up
        rm -f "/tmp/${name}.o" "/tmp/${name}"
    else
        print_status "FAIL" "$name build failed"
        rm -f "/tmp/${name}.o"
    fi
}

# Function to run module tests
test_module() {
    local module=$1
    
    echo "=========================================="
    echo "Testing Module: $module"
    echo "=========================================="
    
    case $module in
        "module01"|"01")
            # Test basic examples
            if [ -f "examples/01-hello.asm" ]; then
                test_assembly_file "examples/01-hello.asm"
                test_example_execution "examples/01-hello.asm"
            fi
            
            # Test exercise solution
            if [ -f "solutions/exercise01.asm" ]; then
                test_assembly_file "solutions/exercise01.asm"
                test_example_execution "solutions/exercise01.asm"
            fi
            ;;
            
        "module02"|"02")
            # Test calculator example
            if [ -f "examples/02-calculator.asm" ]; then
                test_assembly_file "examples/02-calculator.asm"
                test_example_execution "examples/02-calculator.asm"
            fi
            
            # Test exercise solution
            if [ -f "solutions/exercise02.asm" ]; then
                test_assembly_file "solutions/exercise02.asm"
                test_example_execution "solutions/exercise02.asm"
            fi
            ;;
            
        "module03"|"03")
            # Test bitops example
            if [ -f "examples/03-bitops.asm" ]; then
                test_assembly_file "examples/03-bitops.asm"
                test_example_execution "examples/03-bitops.asm"
            fi
            ;;
            
        *)
            print_status "FAIL" "Unknown module: $module"
            ;;
    esac
}

# Main execution
main() {
    local target=${1:-"all"}
    
    echo "Assembly Tutorial Test Suite"
    echo "============================"
    
    # Change to parent directory if we're in tests/
    if [[ $(basename "$PWD") == "tests" ]]; then
        cd ..
    fi
    
    # Check if NASM is installed
    if ! command -v nasm &> /dev/null; then
        print_status "FAIL" "NASM assembler not found. Please install with: sudo apt-get install nasm"
        exit 1
    fi
    
    # Check if we can create 32-bit executables
    if ! ld -m elf_i386 --help &> /dev/null; then
        print_status "FAIL" "32-bit linking not supported. Please install: sudo apt-get install gcc-multilib"
        exit 1
    fi
    
    print_status "PASS" "Build environment check completed"
    echo
    
    if [ "$target" = "all" ]; then
        # Test all modules
        test_module "module01"
        test_module "module02" 
        test_module "module03"
    else
        # Test specific module
        test_module "$target"
    fi
    
    echo
    echo "=========================================="
    echo "Test Summary"
    echo "=========================================="
    echo "Tests Passed: $TESTS_PASSED"
    echo "Tests Failed: $TESTS_FAILED"
    echo "Total Tests:  $((TESTS_PASSED + TESTS_FAILED))"
    
    if [ $TESTS_FAILED -eq 0 ]; then
        print_status "PASS" "All tests passed!"
        exit 0
    else
        print_status "FAIL" "Some tests failed!"
        exit 1
    fi
}

# Run main function with all arguments
main "$@"
