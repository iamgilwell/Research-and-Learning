# Assembly Language Learning Tutorial

**Complete beginner-friendly guide to x86 Assembly Language**

## 📚 Tutorial Structure

### Module 1: Fundamentals
- [01-introduction.md](modules/01-introduction.md) - What is Assembly?
- [02-registers.md](modules/02-registers.md) - CPU Registers and Memory
- [03-basic-instructions.md](modules/03-basic-instructions.md) - Core Instructions

### Module 2: Data and Memory
- [04-data-types.md](modules/04-data-types.md) - Data Types and Storage
- [05-memory-addressing.md](modules/05-memory-addressing.md) - Memory Operations
- [06-strings.md](modules/06-strings.md) - String Manipulation

### Module 3: Control Flow
- [07-comparisons.md](modules/07-comparisons.md) - Flags and Comparisons
- [08-loops.md](modules/08-loops.md) - Loops and Iteration
- [09-functions.md](modules/09-functions.md) - Functions and Procedures

### Module 4: System Programming
- [10-system-calls.md](modules/10-system-calls.md) - Linux System Calls
- [11-file-operations.md](modules/11-file-operations.md) - File I/O
- [12-advanced-topics.md](modules/12-advanced-topics.md) - Advanced Concepts

## 🛠️ Setup

### Prerequisites
```bash
# Install NASM assembler
sudo apt-get install nasm

# Install GDB debugger
sudo apt-get install gdb

# Install 32-bit libraries (for 32-bit assembly)
sudo apt-get install gcc-multilib
```

### Quick Start
```bash
# Clone or navigate to tutorial
cd /mnt/RESEARCH/Projects/tutorials/os-learning/assembly

# Assemble and link first program
nasm -f elf32 examples/01-hello.asm -o hello.o
ld -m elf_i386 hello.o -o hello

# Run program
./hello
```

## 📖 Learning Path

**Beginner (Modules 1-3)**: 3-4 weeks
- Understand registers and basic instructions
- Work with data and memory
- Master basic control flow
- Complete exercises 1-4

**Intermediate (Modules 4-6)**: 3-4 weeks  
- Advanced data structures and memory
- String processing and manipulation
- Complete exercises 5-8

**Advanced (Modules 7-9)**: 4-5 weeks
- Comparisons, loops, and functions
- System programming concepts
- Complete final projects

## 🧪 Testing Your Knowledge

Each module includes:
- **Examples**: Working code with explanations
- **Exercises**: Practice problems with solutions
- **Tests**: Automated verification scripts

Run tests:
```bash
cd tests/
./run_tests.sh module01  # Test specific module
./run_tests.sh all       # Test everything
```

## 📁 Directory Structure

```
assembly/
├── README.md
├── modules/           # Tutorial modules
├── examples/          # Code examples
├── exercises/         # Practice problems
├── tests/            # Automated tests
├── solutions/        # Exercise solutions
└── tools/            # Helper scripts
```

## 🎯 Learning Objectives

By completing this tutorial, you will:
- Understand how CPUs execute instructions
- Write assembly programs from scratch
- Debug assembly code effectively
- Interface with the operating system
- Optimize code at the lowest level

## 🔗 Resources

- [NASM Documentation](https://www.nasm.us/docs.php)
- [Intel x86 Reference](https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html)
- [Linux System Call Reference](https://syscalls.kernelgrok.com/)

---

**Start with Module 1**: [Introduction to Assembly](modules/01-introduction.md)
