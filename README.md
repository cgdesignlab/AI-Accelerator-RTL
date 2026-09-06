# AI Accelerator RTL

A step-by-step RTL implementation of an AI Accelerator using Verilog HDL.

This repository documents the complete design journey from fundamental digital building blocks to a scalable systolic-array-based AI accelerator similar to those used in modern Machine Learning hardware.

---

# Project Objective

The objective of this project is to understand and implement the hardware architecture behind AI accelerators by designing every major building block from scratch instead of relying on pre-built IP cores.

The project focuses on RTL design, verification, modular hardware development, and architectural understanding.

---
## Features

- Parameterized Processing Element
- 32-bit Accumulator
- Signed Arithmetic
- Hierarchical RTL Design
- Generate-based N×N Systolic Array
- GTKWave Verification
- Icarus Verilog Compatible

## Project Structure

rtl/
tb/
sim/
waveforms/
docs/

---

# Tools Used

- Verilog HDL
- System Verilog
- Icarus Verilog
- GTKWave
- Visual Studio Code
- Git
- GitHub

---
## Build

iverilog -g2012 -o sim/systolic_array_tb \
rtl/pe.sv \
rtl/systolic_array.sv \
tb/tb_systolic_array.sv

vvp sim/systolic_array_tb

gtkwave waveforms/systolic_array.vcd

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

