# AI Accelerator RTL

A step-by-step RTL implementation of an AI Accelerator using Verilog HDL.

This repository documents the complete design journey from fundamental digital building blocks to a scalable systolic-array-based AI accelerator similar to those used in modern Machine Learning hardware.

---

# Project Objective

The objective of this project is to understand and implement the hardware architecture behind AI accelerators by designing every major building block from scratch instead of relying on pre-built IP cores.

The project focuses on RTL design, verification, modular hardware development, and architectural understanding.

---

# Current Progress

## Completed

- ✔ 8-bit Multiplier
- ✔ 16-bit Accumulator
- ✔ Multiply-Accumulate (MAC) Unit

## Upcoming

- Processing Element (PE)
- 2×2 Systolic Array
- 4×4 Systolic Array
- Matrix Multiplication Engine
- Simple AI Accelerator
- Performance Analysis
- FPGA Implementation (Future)

---

# Project Structure

```
AI Accelerator/
│
├── rtl/
│   ├── multiplier.v
│   ├── accumulator.v
│   └── mac.v
│
├── tb/
│   ├── tb_multiplier.v
│   ├── tb_accumulator.v
│   └── tb_mac.v
│
├── docs/
├── scripts/
├── sim/
└── waveforms/
```

---

# Tools Used

- Verilog HDL
- Icarus Verilog
- GTKWave
- Visual Studio Code
- Git
- GitHub

---

# Modules Implemented

## 8-bit Multiplier

- Combinational logic
- Produces a 16-bit product

## 16-bit Accumulator

- Sequential logic
- Accumulates incoming values every clock cycle

## MAC (Multiply-Accumulate)

Combines:

Multiplier

+

Accumulator

to perform

```
Sum = Sum + (A × B)
```

which forms the computational core of modern AI accelerators.

---

# Verification

Each module has an independent testbench.

Simulation performed using:

- Icarus Verilog
- GTKWave

---

# Current Status

Project is under active development.

Next milestone:

Processing Element (PE)