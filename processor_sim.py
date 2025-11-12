import tkinter as tk
from tkinter import ttk, scrolledtext, messagebox

class Processor4Bit:
    def __init__(self):
        self.registers = {'A': 0, 'B': 0, 'C': 0, 'D': 0, 'E': 0, 'H': 0, 'L': 0}
        self.flags = 0
        self.pc = 0
        self.sp = 0x000F
        self.memory = [0] * 2048  # 11-bit addressable (2^11)
        self.running = False
        
        # 11-bit instruction: [3-bit opcode][4-bit reg/val][4-bit reg/val]
        self.opcodes = {
            'LXI': 0b000, 'MVI': 0b001, 'MOV': 0b010, 'ADD': 0b011,
            'STA': 0b100, 'INV': 0b101, 'HLT': 0b111
        }
        
        self.reg_codes = {'A': 0, 'B': 1, 'C': 2, 'D': 3, 'E': 4, 'H': 5, 'L': 6}
    
    def reset(self):
        self.registers = {k: 0 for k in self.registers}
        self.flags = 0
        self.pc = 0
        self.sp = 0x000F
        self.memory = [0] * 2048
        self.running = False
    
    def assemble(self, code):
        lines = [l.strip() for l in code.split('\n') if l.strip() and not l.strip().startswith(';')]
        self.memory = [0] * 2048
        addr = 0
        
        for line in lines:
            parts = line.split()
            if not parts:
                continue
            
            instr = parts[0].upper()
            
            if instr == 'LXI':  # LXI H, 0x00H
                reg = parts[1].rstrip(',').upper()
                val = int(parts[2].replace('H', ''), 16) & 0xF
                mc = (self.opcodes['LXI'] << 8) | (self.reg_codes.get(reg, 0) << 4) | val
                self.memory[addr] = mc
                addr += 1
                
            elif instr == 'MVI':  # MVI H, 0x0H
                reg = parts[1].rstrip(',').upper()
                val = int(parts[2].replace('H', ''), 16) & 0xF
                mc = (self.opcodes['MVI'] << 8) | (self.reg_codes.get(reg, 0) << 4) | val
                self.memory[addr] = mc
                addr += 1
                
            elif instr == 'MOV':  # MOV D, A
                dst = parts[1].rstrip(',').upper()
                src = parts[2].upper()
                mc = (self.opcodes['MOV'] << 8) | (self.reg_codes.get(dst, 0) << 4) | self.reg_codes.get(src, 0)
                self.memory[addr] = mc
                addr += 1
                
            elif instr == 'ADD':  # ADD B
                src = parts[1].upper()
                mc = (self.opcodes['ADD'] << 8) | (self.reg_codes.get(src, 0) << 4)
                self.memory[addr] = mc
                addr += 1
                
            elif instr == 'STA':  # STA 4H
                addr_val = int(parts[1].replace('H', ''), 16) & 0x7F
                mc = (self.opcodes['STA'] << 8) | (addr_val & 0xFF)
                self.memory[addr] = mc
                addr += 1
                
            elif instr == 'INV':  # INV H
                reg = parts[1].upper()
                mc = (self.opcodes['INV'] << 8) | (self.reg_codes.get(reg, 0) << 4)
                self.memory[addr] = mc
                addr += 1
                
            elif instr == 'HLT':
                mc = (self.opcodes['HLT'] << 8)
                self.memory[addr] = mc
                addr += 1
        
        return addr
    
    def step(self):
        if self.pc >= 2048:
            return False
            
        instr = self.memory[self.pc]
        opcode = (instr >> 8) & 0x7
        
        if opcode == self.opcodes['LXI']:
            reg = (instr >> 4) & 0xF
            val = instr & 0xF
            reg_name = list(self.reg_codes.keys())[reg] if reg < len(self.reg_codes) else 'A'
            self.registers[reg_name] = val
            self.pc += 1
            
        elif opcode == self.opcodes['MVI']:
            reg = (instr >> 4) & 0xF
            val = instr & 0xF
            reg_name = list(self.reg_codes.keys())[reg] if reg < len(self.reg_codes) else 'A'
            self.registers[reg_name] = val
            self.pc += 1
            
        elif opcode == self.opcodes['MOV']:
            dst = (instr >> 4) & 0xF
            src = instr & 0xF
            dst_name = list(self.reg_codes.keys())[dst] if dst < len(self.reg_codes) else 'A'
            src_name = list(self.reg_codes.keys())[src] if src < len(self.reg_codes) else 'A'
            self.registers[dst_name] = self.registers[src_name]
            self.pc += 1
            
        elif opcode == self.opcodes['ADD']:
            src = (instr >> 4) & 0xF
            src_name = list(self.reg_codes.keys())[src] if src < len(self.reg_codes) else 'B'
            self.registers['A'] = (self.registers['A'] + self.registers[src_name]) & 0xF
            self.pc += 1
            
        elif opcode == self.opcodes['STA']:
            addr = instr & 0xFF
            self.memory[addr] = self.registers['A']
            self.pc += 1
            
        elif opcode == self.opcodes['INV']:
            reg = (instr >> 4) & 0xF
            reg_name = list(self.reg_codes.keys())[reg] if reg < len(self.reg_codes) else 'H'
            self.registers[reg_name] = (~self.registers[reg_name]) & 0xF
            self.pc += 1
            
        elif opcode == self.opcodes['HLT']:
            return False
        else:
            self.pc += 1
        
        return True

class SimulatorGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("4-bit Processor Simulator")
        self.root.geometry("1400x800")
        self.root.configure(bg='#2b2b2b')
        
        self.processor = Processor4Bit()
        
        # Left Panel - Assembly Editor
        left_frame = tk.Frame(root, bg='#2b2b2b')
        left_frame.pack(side=tk.LEFT, fill=tk.BOTH, expand=True, padx=5, pady=5)
        
        tk.Label(left_frame, text="Assembly Code Editor", bg='#2b2b2b', fg='white', font=('Consolas', 12, 'bold')).pack()
        
        btn_frame = tk.Frame(left_frame, bg='#2b2b2b')
        btn_frame.pack(pady=5)
        
        tk.Button(btn_frame, text="Compile", command=self.compile, bg='#4CAF50', fg='white', font=('Consolas', 10)).pack(side=tk.LEFT, padx=2)
        tk.Button(btn_frame, text="Run", command=self.run, bg='#2196F3', fg='white', font=('Consolas', 10)).pack(side=tk.LEFT, padx=2)
        tk.Button(btn_frame, text="Step", command=self.step, bg='#FF9800', fg='white', font=('Consolas', 10)).pack(side=tk.LEFT, padx=2)
        tk.Button(btn_frame, text="Reset", command=self.reset, bg='#f44336', fg='white', font=('Consolas', 10)).pack(side=tk.LEFT, padx=2)
        
        self.asm_editor = scrolledtext.ScrolledText(left_frame, width=50, height=20, bg='#1e1e1e', fg='#d4d4d4', insertbackground='white', font=('Consolas', 10))
        self.asm_editor.pack(fill=tk.BOTH, expand=True, pady=5)
        self.asm_editor.insert('1.0', '''; Sample Program
LXI H, 0000H
MVI H, 006H
MOV D, A
ADD B
STA 4H
INV H
HLT''')
        
        tk.Label(left_frame, text="Machine Code", bg='#2b2b2b', fg='white', font=('Consolas', 12, 'bold')).pack(pady=(10,5))
        self.machine_code = scrolledtext.ScrolledText(left_frame, width=50, height=10, bg='#1e1e1e', fg='#4EC9B0', insertbackground='white', font=('Consolas', 9))
        self.machine_code.pack(fill=tk.BOTH, expand=True)
        
        # Right Panel - Registers and Memory
        right_frame = tk.Frame(root, bg='#2b2b2b', width=600)
        right_frame.pack(side=tk.RIGHT, fill=tk.BOTH, padx=5, pady=5)
        
        # Registers
        tk.Label(right_frame, text="Registers", bg='#2b2b2b', fg='white', font=('Consolas', 12, 'bold')).pack()
        
        reg_frame = tk.Frame(right_frame, bg='#1e1e1e')
        reg_frame.pack(fill=tk.X, pady=5)
        
        headers = ['Register', 'Hex', 'Dec', 'Bin']
        for i, h in enumerate(headers):
            tk.Label(reg_frame, text=h, bg='#1e1e1e', fg='#4EC9B0', font=('Consolas', 10, 'bold'), width=12).grid(row=0, column=i, padx=2, pady=2)
        
        self.reg_labels = {}
        for idx, reg in enumerate(['A', 'B', 'C', 'D', 'E', 'H', 'L', 'FLAGS']):
            tk.Label(reg_frame, text=reg, bg='#1e1e1e', fg='white', font=('Consolas', 10), width=12).grid(row=idx+1, column=0, padx=2, pady=2)
            self.reg_labels[reg] = {}
            for col, fmt in enumerate(['hex', 'dec', 'bin']):
                lbl = tk.Label(reg_frame, text='00', bg='#1e1e1e', fg='#d4d4d4', font=('Consolas', 10), width=12)
                lbl.grid(row=idx+1, column=col+1, padx=2, pady=2)
                self.reg_labels[reg][fmt] = lbl
        
        # PC and SP
        pc_sp_frame = tk.Frame(right_frame, bg='#1e1e1e')
        pc_sp_frame.pack(fill=tk.X, pady=5)
        tk.Label(pc_sp_frame, text="PC:", bg='#1e1e1e', fg='#4EC9B0', font=('Consolas', 10, 'bold')).grid(row=0, column=0, padx=5)
        self.pc_label = tk.Label(pc_sp_frame, text='0x0000', bg='#1e1e1e', fg='white', font=('Consolas', 10))
        self.pc_label.grid(row=0, column=1, padx=5)
        tk.Label(pc_sp_frame, text="SP:", bg='#1e1e1e', fg='#4EC9B0', font=('Consolas', 10, 'bold')).grid(row=0, column=2, padx=5)
        self.sp_label = tk.Label(pc_sp_frame, text='0x000F', bg='#1e1e1e', fg='white', font=('Consolas', 10))
        self.sp_label.grid(row=0, column=3, padx=5)
        
        # Memory
        tk.Label(right_frame, text="Memory", bg='#2b2b2b', fg='white', font=('Consolas', 12, 'bold')).pack(pady=(10,5))
        
        mem_frame = tk.Frame(right_frame, bg='#1e1e1e')
        mem_frame.pack(fill=tk.BOTH, expand=True)
        
        self.mem_tree = ttk.Treeview(mem_frame, columns=('Address', 'Hex', 'Dec'), show='headings', height=20)
        self.mem_tree.heading('Address', text='Address')
        self.mem_tree.heading('Hex', text='Hex')
        self.mem_tree.heading('Dec', text='Dec')
        self.mem_tree.column('Address', width=100)
        self.mem_tree.column('Hex', width=100)
        self.mem_tree.column('Dec', width=100)
        
        scrollbar = ttk.Scrollbar(mem_frame, orient=tk.VERTICAL, command=self.mem_tree.yview)
        self.mem_tree.configure(yscroll=scrollbar.set)
        self.mem_tree.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
        
        # Console
        tk.Label(right_frame, text="Console", bg='#2b2b2b', fg='white', font=('Consolas', 12, 'bold')).pack(pady=(10,5))
        self.console = scrolledtext.ScrolledText(right_frame, width=50, height=8, bg='#1e1e1e', fg='#4EC9B0', insertbackground='white', font=('Consolas', 9))
        self.console.pack(fill=tk.BOTH)
        self.console.insert('1.0', '[INFO] Simulator ready.\n')
        
        self.update_display()
    
    def compile(self):
        try:
            code = self.asm_editor.get('1.0', tk.END)
            addr = self.processor.assemble(code)
            self.machine_code.delete('1.0', tk.END)
            
            for i in range(addr):
                mc = self.processor.memory[i]
                binary = format(mc, '011b')
                self.machine_code.insert(tk.END, f"{i:04X}: {mc:03X} ({binary})\n")
            
            self.update_display()
            self.console.insert(tk.END, f'[INFO] Compiled {addr} instructions.\n')
            self.console.see(tk.END)
        except Exception as e:
            messagebox.showerror("Error", f"Compilation error: {str(e)}")
    
    def step(self):
        if self.processor.step():
            self.update_display()
            self.console.insert(tk.END, f'[STEP] PC: {self.processor.pc:04X}\n')
            self.console.see(tk.END)
        else:
            self.console.insert(tk.END, '[INFO] Program halted.\n')
            self.console.see(tk.END)
    
    def run(self):
        count = 0
        while self.processor.step() and count < 1000:
            count += 1
        self.update_display()
        self.console.insert(tk.END, f'[INFO] Executed {count} instructions.\n')
        self.console.see(tk.END)
    
    def reset(self):
        self.processor.reset()
        self.update_display()
        self.machine_code.delete('1.0', tk.END)
        self.console.insert(tk.END, '[INFO] Processor reset.\n')
        self.console.see(tk.END)
    
    def update_display(self):
        # Update registers
        for reg in ['A', 'B', 'C', 'D', 'E', 'H', 'L']:
            val = self.processor.registers[reg]
            self.reg_labels[reg]['hex'].config(text=f'{val:01X}')
            self.reg_labels[reg]['dec'].config(text=f'{val}')
            self.reg_labels[reg]['bin'].config(text=f'{val:04b}')
        
        val = self.processor.flags
        self.reg_labels['FLAGS']['hex'].config(text=f'{val:02X}')
        self.reg_labels['FLAGS']['dec'].config(text=f'{val}')
        self.reg_labels['FLAGS']['bin'].config(text=f'{val:08b}')
        
        self.pc_label.config(text=f'0x{self.processor.pc:04X}')
        self.sp_label.config(text=f'0x{self.processor.sp:04X}')
        
        # Update memory
        self.mem_tree.delete(*self.mem_tree.get_children())
        for i in range(min(50, 2048)):
            val = self.processor.memory[i]
            if val != 0 or i < 20:
                self.mem_tree.insert('', tk.END, values=(f'{i:04X}', f'{val:03X}', f'{val}'))

if __name__ == '__main__':
    root = tk.Tk()
    app = SimulatorGUI(root)
    root.mainloop()