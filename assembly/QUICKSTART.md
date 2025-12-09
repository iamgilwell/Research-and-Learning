# Quick Start Guide

## 1. Build Examples
```bash
make examples
```

## 2. Run Your First Program
```bash
./build/01-hello
```

## 3. Test Everything Works
```bash
make test
```

## 4. Start Learning
1. Read [Module 1: Introduction](modules/01-introduction.md)
2. Try [Exercise 1](exercises/exercise01.md)
3. Build with: `./tools/build.sh your_program.asm`

## 5. Debug Programs
```bash
./tools/build.sh program.asm debug
./tools/debug_helper.sh program
```

## Example Output
```
$ ./build/01-hello
Hello, Assembly World!

$ ./build/02-calculator
(Runs silently - check with debugger to see results)
```

## Next Steps
- Complete exercises in order
- Use `make help` for build options
- Check solutions/ directory when stuck
