# SystemVerilog APB Verification

## Overview

This project contains an APB slave with four 8-bit memory-mapped registers, an active-low asynchronous reset, and a class-based SystemVerilog testbench.

The verification environment separates transaction generation, driving, monitoring, and checking through mailboxes and a reference model.

## Register Map

| Address | Register |
|---|---|
| `0x00` | `REG0` |
| `0x04` | `REG1` |
| `0x08` | `REG2` |
| `0x0C` | `REG3` |

Other addresses are treated as invalid and should raise `PSLVERR` during an access.

## Testbench Components

- `APB_Transaction`: Holds APB request and response fields.
- `generator`: Creates valid register writes and reads, plus invalid-address tests.
- `driver`: Drives APB SETUP and ACCESS phases.
- `monitor`: Samples completed accesses.
- `scoreboard`: Maintains a reference model and checks address, operation, write/read data, `PSLVERR`, and `PREADY`.
- `APB_if`: Groups the APB signals, including the active-low reset `reset_n`.
- `reset_n`: Active-low asynchronous reset. It clears `REG0` through `REG3` to `8'h00`. The testbench holds reset active at startup and releases it at 45 ns.
- `tb`: Instantiates the DUT and coordinates the verification components.

## Project Structure

```text
systemverilog-apb-verification/
├── rtl/
│   └── APB.sv
├── tb/
│   ├── APB_if.sv
│   ├── apb_transaction.sv
│   ├── generator.sv
│   ├── driver.sv
│   ├── monitor.sv
│   ├── scoreboard.sv
│   ├── apb_tb_pkg.sv
│   └── tb.sv
├── docs/
│   └── screenshots/
├── README.md
└── .gitignore
