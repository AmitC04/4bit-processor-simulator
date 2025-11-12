
# 4-bit Processor Simulator

A fully functional 4-bit processor simulator with 11-bit machine code architecture, built in Python with Tkinter GUI. Perfect for learning computer architecture, assembly programming, and understanding how processors work at the fundamental level.

![Python Version](https://img.shields.io/badge/python-3.7+-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20macOS-lightgrey.svg)

## 🚀 Features

- **11-bit Machine Code Architecture** - 3-bit opcode + 8-bit operands
- **4-bit Data Width** - All registers and ALU operations are 4-bit
- **2048 Bytes RAM** - 11-bit addressable memory space
- **Real-time Visualization** - Watch registers and memory update as code executes
- **Assembly Language Support** - Write code in human-readable assembly
- **Step-by-Step Execution** - Debug your code instruction by instruction
- **Multiple Number Formats** - View values in Hex, Decimal, and Binary
- **Modern Dark Theme UI** - Easy on the eyes for long coding sessions

## 📸 Screenshot

```
┌─────────────────────────────────────┬──────────────────────────────┐
│   Assembly Code Editor              │      Registers               │
│   ┌─────────────────────────────┐   │   ┌──────────────────────┐   │
│   │ ; Sample Program            │   │   │ A  │ 0x0 │ 0 │ 0000 │   │
│   │ LXI H, 0000H                │   │   │ B  │ 0x0 │ 0 │ 0000 │   │
│   │ MVI H, 006H                 │   │   │ C  │ 0x0 │ 0 │ 0000 │   │
│   │ MOV D, A                    │   │   │ D  │ 0x0 │ 0 │ 0000 │   │
│   │ ADD B                       │   │   │ ...                  │   │
│   │ STA 4H                      │   │   └──────────────────────┘   │
│   │ INV H                       │   │                              │
│   │ HLT                         │   │      Memory View             │
│   └─────────────────────────────┘   │   ┌──────────────────────┐   │
│                                     │   │ 0000 │ 006 │   6     │   │
│   Machine Code                      │   │ 0001 │ 096 │  150    │   │
│   ┌─────────────────────────────┐   │   │ 0002 │ 210 │  528    │   │
│   │ 0000: 056 (00000110110)     │   │   │ ...                  │   │
│   │ 0001: 096 (00001100000)     │   │   └──────────────────────┘   │
│   │ 0002: 210 (00011010010)     │   │                              │
│   └─────────────────────────────┘   │      Console                 │
└─────────────────────────────────────┴──────────────────────────────┘
```

## 🛠️ Installation

### Prerequisites
- Python 3.7 or higher
- Tkinter (usually comes with Python)

### Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/AmitC04/4bit-processor-simulator.git
   cd 4bit-processor-simulator
   ```

2. **Run the simulator**
   ```bash
   python processor_sim.py
   ```

That's it! No external dependencies required.

## 📖 Usage

### Basic Workflow

1. **Write Assembly Code** - Type your program in the Assembly Code Editor
2. **Compile** - Click the "Compile" button to generate machine code
3. **Execute** - Use "Step" for single instruction or "Run" for full execution
4. **Observe** - Watch registers and memory update in real-time
5. **Reset** - Clear everything and start over

### Example Programs

#### Hello World (Basic Operations)
```assembly
; Load and add numbers
LXI H, 0000H    ; Load H with 0
MVI H, 006H     ; Move 6 into H
MOV D, A        ; Copy A to D
ADD B           ; Add B to A
STA 4H          ; Store A at memory address 4
INV H           ; Invert H register
HLT             ; Halt execution
```

#### Simple Counter
```assembly
; Count from 0 to 15
MVI A, 000H     ; Initialize A to 0
MVI B, 001H     ; B = 1 (increment value)
ADD B           ; A = A + 1
ADD B           ; A = A + 1
ADD B           ; A = A + 1
STA 5H          ; Store result
HLT
```

#### Data Movement
```assembly
; Move data between registers
MVI A, 00AH     ; A = 10
MOV B, A        ; B = A
MOV C, B        ; C = B
MOV D, C        ; D = C
HLT
```

## 🏗️ Architecture

### Instruction Set Architecture (ISA)

| Instruction | Opcode | Format | Description |
|-------------|--------|--------|-------------|
| **LXI** | 000 | `LXI R, nn` | Load register with immediate value |
| **MVI** | 001 | `MVI R, nn` | Move immediate value to register |
| **MOV** | 010 | `MOV D, S` | Move from source to destination register |
| **ADD** | 011 | `ADD R` | Add register to accumulator (A) |
| **STA** | 100 | `STA addr` | Store accumulator to memory address |
| **INV** | 101 | `INV R` | Invert (NOT) register contents |
| **HLT** | 111 | `HLT` | Halt processor execution |

### Register Set

- **General Purpose Registers**: A, B, C, D, E, H, L (4-bit each)
- **Special Registers**:
  - **PC** (Program Counter): 11-bit, points to next instruction
  - **SP** (Stack Pointer): 11-bit, points to top of stack
  - **FLAGS**: Status flags for ALU operations

### Memory Organization

```
┌──────────────────────┐
│  0x0000 - 0x00FF     │  Code Segment (256 bytes)
├──────────────────────┤
│  0x0100 - 0x03FF     │  Data Segment (768 bytes)
├──────────────────────┤
│  0x0400 - 0x07FF     │  Stack/Free Space (1024 bytes)
└──────────────────────┘
Total: 2048 bytes (11-bit addressable)
```

### Machine Code Format (11-bit)

```
┌─────────────────────────────────────┐
│  10  9  8  │  7  6  5  4  │  3  2  1  0  │
├────────────┼─────────────┼──────────────┤
│  Opcode    │  Operand 1  │  Operand 2   │
│  (3 bits)  │  (4 bits)   │  (4 bits)    │
└─────────────────────────────────────┘
```

**Example**: `MVI H, 006H`
- Opcode: `001` (MVI)
- Operand 1: `0101` (H register = 5)
- Operand 2: `0110` (value = 6)
- Machine Code: `00101010110` = `0x156` (342 decimal)

## 🎮 Controls

### Button Functions

| Button | Shortcut | Function |
|--------|----------|----------|
| **Compile** | - | Assemble code to machine code |
| **Run** | - | Execute all instructions until HLT |
| **Step** | - | Execute single instruction |
| **Reset** | - | Clear registers, memory, and reset PC |

## 🧪 Technical Details

### ALU Operations
- **Addition**: 4-bit binary addition with carry flag
- **Logical NOT**: Bitwise inversion of 4-bit values
- All operations respect 4-bit boundaries (values wrap at 15)

### Execution Cycle
1. **Fetch**: Read instruction from memory at PC
2. **Decode**: Extract opcode and operands
3. **Execute**: Perform operation
4. **Update**: Increment PC, update flags
5. **Display**: Refresh GUI with new values

### Performance
- **Execution Speed**: ~1000 instructions/second in run mode
- **Memory Access**: O(1) constant time
- **GUI Update**: Real-time, non-blocking

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/AmazingFeature`)
3. **Commit your changes** (`git commit -m 'Add some AmazingFeature'`)
4. **Push to the branch** (`git push origin feature/AmazingFeature`)
5. **Open a Pull Request**

### Ideas for Contributions
- Add more instructions (SUB, MUL, JMP, etc.)
- Implement interrupts and I/O
- Add breakpoint support
- Create a disassembler
- Add syntax highlighting to editor
- Export/Import program files
- Add more example programs

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🎓 Educational Use

This simulator is perfect for:
- **Computer Science Students** learning computer architecture
- **Educators** teaching assembly programming
- **Hobbyists** interested in how processors work
- **Interview Preparation** for systems programming roles

## 📚 Resources

- [Computer Organization and Design](https://www.amazon.com/Computer-Organization-Design-RISC-V-Architecture/dp/0128122757) - Patterson & Hennessy
- [Digital Design and Computer Architecture](https://www.amazon.com/Digital-Design-Computer-Architecture-Harris/dp/0123944244) - Harris & Harris
- [Ben Eater's 8-bit Computer Series](https://www.youtube.com/playlist?list=PLowKtXNTBypGqImE405J2565dvjafglHU) - Excellent YouTube series

## ⭐ Star History

If you find this project helpful, please consider giving it a star! It helps others discover the project.

## 🐛 Bug Reports

Found a bug? Please open an issue with:
- Description of the bug
- Steps to reproduce
- Expected vs actual behavior
- Screenshots (if applicable)

## 📧 Contact


Project Link: [https://github.com/AmitC04/4bit-processor-simulator](https://github.com/AmitC04/4bit-processor-simulator)

## 🙏 Acknowledgments

- Inspired by classic 4-bit processors like the Intel 4004
- UI design influenced by modern code editors
- Thanks to the open-source community for inspiration

---

Made with ❤️ for computer architecture enthusiasts

**[⬆ back to top](#4-bit-processor-simulator)**
