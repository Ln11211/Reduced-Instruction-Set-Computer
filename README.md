# Reduced-Instruction-Set-Computer
The design and implementation of an instruction set of a stripped-down RISC CPU. The Verilog design source files are in `sources` directory and the simulation files are in the `sim_1` directory.


# Description
Designed and implemented a 32-bit ALU supporting ADD, SUB, MULT with 2’s complement arithmetic, overflow/underflow detection stored in a Condition Code (CC) register.

Implemented logical operations: AND, OR, XOR, NOT. Built comparators: EqualTo, NotEqualTo, LessThan, LessThanEqualTo, GreaterThan, GreaterThanEqualTo, with outcomes stored in the CC register.

Designed a Reduced Instruction Set (RIS) architecture with:

16 general-purpose 32-bit registers

# 32-bit OpCode format
Designed OpCode layout and defined bit-level meaning.
<img width="1025" height="263" alt="image" src="https://github.com/user-attachments/assets/5a7bbb08-4888-4c65-a891-5231006d21af" />

Separate Program Counter (PC), Stack Pointer (SP), and Condition Code Register (CCR) with defined bit meanings. Supported Memory-Register Load/Store and Immediate Mode addressing


# Implemented instruction set :

<img width="1128" height="299" alt="image" src="https://github.com/user-attachments/assets/8e8a44b9-c409-4583-ab05-e7b2e2a18f1b" />


# ALU operations
<img width="874" height="308" alt="image" src="https://github.com/user-attachments/assets/3fde7197-a5e6-4790-8cb9-2bba9938e716" />

<img width="845" height="171" alt="image" src="https://github.com/user-attachments/assets/9e004aa5-20e5-42b6-8bd2-20c9ec456359" />

Register Load/Store operations

# Branch operations: unconditional jump, conditional jump, procedure call (with state saving), and return (with state restoration)
<img width="778" height="303" alt="image" src="https://github.com/user-attachments/assets/9c67508c-d2be-4cfc-bd82-eaa1eff103ef" />
<img width="781" height="302" alt="image" src="https://github.com/user-attachments/assets/1e3dfeee-5d63-4473-8a8d-080d45c4e7f0" />

Created instruction table with mnemonics for each operation.

Implemented full instruction cycle: Fetch, Decode, Execute, Save Results.

Developed assembly programs to exercise all instructions, including memory load/store.

Built assembler to convert mnemonics to opcodes, executed opcodes, and verified correctness of results.

# Schematic
<img width="1050" height="977" alt="image" src="https://github.com/user-attachments/assets/0a0eb41c-9dd6-4931-bc97-9f1e883563b3" />

# Results 
  <img width="1319" height="690" alt="image" src="https://github.com/user-attachments/assets/255fb2f6-86b9-43e4-ad7b-5f5ef539e074" />

## 32 General purpose Registers after execution
 <img width="322" height="558" alt="image" src="https://github.com/user-attachments/assets/5cff5988-aa3b-4f63-b86b-d104d77562b0" />

## Testbench Waveforms
Waveforms
<img width="1911" height="1011" alt="image" src="https://github.com/user-attachments/assets/07c78162-a20f-496b-a622-e77367ab3477" />

General Purpose Register waveforms
<img width="1885" height="647" alt="image" src="https://github.com/user-attachments/assets/2a4a1877-ca7c-476c-9856-6b2ddb6708b3" />

I memory waveforms
<img width="1884" height="854" alt="image" src="https://github.com/user-attachments/assets/4436401e-b998-4690-b6b9-cfb17fb1a8a0" />



