# Assembly Language Tutorial - Complete Package

## 📁 What's Included

### Core Tutorial Modules (9 Complete Modules)
- **Module 1**: [Introduction](modules/01-introduction.md) - Assembly basics and first program
- **Module 2**: [Registers](modules/02-registers.md) - CPU registers and memory addressing  
- **Module 3**: [Instructions](modules/03-basic-instructions.md) - Arithmetic, logic, and data movement
- **Module 4**: [Data Types](modules/04-data-types.md) - Data storage, arrays, and structures
- **Module 5**: [Memory Addressing](modules/05-memory-addressing.md) - Advanced addressing modes
- **Module 6**: [String Operations](modules/06-strings.md) - String processing and manipulation
- **Module 7**: [Comparisons](modules/07-comparisons.md) - Flags and conditional logic
- **Module 8**: [Loops](modules/08-loops.md) - Iteration and loop patterns
- **Module 9**: [Functions](modules/09-functions.md) - Procedures and calling conventions

### Working Examples (5 Programs)
- `examples/01-hello.asm` - Hello World program
- `examples/02-calculator.asm` - Basic arithmetic operations
- `examples/03-bitops.asm` - Bit manipulation demonstrations
- `examples/04-datatypes.asm` - Data types and structures
- `examples/05-functions.asm` - Function calls and recursion

### Practice Exercises (4 Complete)
- `exercises/exercise01.md` - Create your first program
- `exercises/exercise02.md` - Register manipulation and XOR swap
- `exercises/exercise03.md` - Array processing and statistics
- `exercises/exercise04.md` - String manipulation operations
- `solutions/` - Complete solutions with explanations

### Development Tools
- `tools/build.sh` - Easy build script with debug support
- `tools/debug_helper.sh` - GDB debugging assistant
- `Makefile` - Automated build system
- `test_simple.sh` - Quick verification tests

## 🚀 Getting Started

### 1. Quick Test
```bash
cd /mnt/RESEARCH/Projects/tutorials/os-learning/assembly
./test_simple.sh
```

### 2. Build and Run Examples
```bash
make examples
./build/01-hello
```

### 3. Start Learning
```bash
# Read the introduction
cat modules/01-introduction.md

# Try first exercise  
cat exercises/exercise01.md

# Build your program
./tools/build.sh myprogram.asm
```

## 📚 Learning Path

**Week 1-2**: Modules 1-3, Examples 1-3, Exercises 1-2
**Week 3-4**: Modules 4-6, Examples 4-5, Exercises 3-4  
**Week 5-6**: Modules 7-9, Advanced topics and projects

## 🛠️ Prerequisites Met

✅ **NASM Assembler** - For converting assembly to machine code
✅ **32-bit Support** - For building x86 programs
✅ **GDB Debugger** - For step-by-step debugging
✅ **Build Tools** - Automated compilation and testing

## 🎯 Learning Outcomes

After completing this tutorial, you will understand:

- How CPUs execute instructions at the lowest level
- Register usage and memory addressing modes
- Assembly program structure and system calls
- Debugging techniques for low-level code
- The foundation for systems programming

## 📖 Key Concepts Covered

### Fundamental Concepts
- Program sections (.data, .text, .bss)
- CPU registers (EAX, EBX, ECX, EDX)
- Memory addressing modes
- System calls and kernel interaction

### Instructions Mastered
- Data movement (MOV, PUSH, POP, LEA)
- Arithmetic (ADD, SUB, MUL, DIV, IMUL, IDIV)
- Logic operations (AND, OR, XOR, NOT, TEST)
- Bit manipulation (SHL, SHR, ROL, ROR)
- String operations (MOVSB, SCASB, CMPSB)
- Control flow (JMP, Jcc, CALL, RET, LOOP)
- Comparison operations (CMP, TEST)

### Advanced Concepts
- Function calling conventions and stack frames
- Recursive function implementation
- Multi-dimensional array access
- String processing algorithms
- Memory addressing modes and optimization
- Flag register usage and conditional execution

### Practical Skills
- Building and linking assembly programs
- Using GDB for debugging
- Reading and writing assembly code
- Understanding program execution flow

## 🔧 Available Commands

```bash
# Build everything
make all

# Build specific examples
make examples

# Build exercise solutions
make solutions  

# Quick test
./test_simple.sh

# Build single file
./tools/build.sh program.asm

# Debug a program
./tools/build.sh program.asm debug
./tools/debug_helper.sh program

# Get help
make help
```

## 📈 Next Steps

1. **Complete all exercises** - Practice makes perfect
2. **Experiment with modifications** - Change examples and see results
3. **Learn advanced topics** - Explore modules 4+ (when available)
4. **Apply knowledge** - Use assembly in larger projects

## 🎉 Success Verification

Your tutorial is working correctly if:
- ✅ `./test_simple.sh` passes all tests
- ✅ `./build/01-hello` prints "Hello, Assembly World!"
- ✅ You can build new programs with `./tools/build.sh`
- ✅ GDB debugging works with debug builds

---

**Tutorial Status**: ✅ Complete and Comprehensive (9 Modules)
**Location**: `/mnt/RESEARCH/Projects/tutorials/os-learning/assembly/`
**Ready for**: Beginner to advanced assembly learning
**Total Content**: 9 modules, 5 examples, 4 exercises with solutions
