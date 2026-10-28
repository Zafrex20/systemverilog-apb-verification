# SystemVerilog APB Verification

## Overview

This project implements a verification environment for an Advanced Peripheral Bus (APB) slave using SystemVerilog. The design contains four memory-mapped registers and supports read and write operations through the APB interface.

The verification environment follows a modular, class-based structure in which transaction generation, driving, monitoring, and checking are handled by independent components. Mailboxes are used to communicate transactions between the components, while a scoreboard compares the observed DUT behavior against a reference model.

The project also includes an active-low asynchronous reset to initialize the internal registers to a known state before the verification sequence begins.

## Design Under Test

The APB slave contains four 8-bit registers accessible through the following address map:

| Address | Register | Description |
|---|---|---|
| `0x00` | `REG0` | Memory-mapped register 0 |
| `0x04` | `REG1` | Memory-mapped register 1 |
| `0x08` | `REG2` | Memory-mapped register 2 |
| `0x0C` | `REG3` | Memory-mapped register 3 |

Valid addresses support read and write operations. Accesses to unsupported addresses are expected to assert `PSLVERR`.

The design uses the following APB signals:

- `PADDR`: Selects the register address.
- `PWDATA`: Carries write data.
- `PRDATA`: Returns read data.
- `PSEL`: Selects the peripheral.
- `PENABLE`: Indicates the access phase.
- `PWRITE`: Defines the operation type.
- `PREADY`: Indicates that the peripheral is ready to complete the access.
- `PSLVERR`: Indicates an error during an access.
- `clk`: Clock signal.
- `reset_n`: Active-low asynchronous reset.

When `reset_n` is asserted low, all four registers are cleared to `8'h00`.

## Verification Architecture

The testbench is divided into independent components to separate stimulus generation from signal driving and result checking.

### Generator

Creates randomized APB transactions, including valid writes, valid reads, and invalid-address accesses. The generated transactions are sent to the driver and scoreboard through separate mailboxes.

### Driver

Receives transactions from the generator and applies them to the APB interface. It controls the SETUP and ACCESS phases by driving the corresponding APB signals.

### Monitor

Observes completed APB accesses and captures the address, operation type, write data, read data, readiness, and error response. The collected information is forwarded to the scoreboard.

### Scoreboard

Maintains a reference model of the four registers and compares expected behavior with the transactions observed by the monitor. The checks include:

- Address matching.
- Read and write operation matching.
- Write data verification.
- Read data verification.
- `PSLVERR` verification.
- `PREADY` verification.

### Transaction Class

Encapsulates the fields associated with an APB transaction. The `copy()` method creates independent transaction objects when distributing stimulus to the driver and scoreboard.

### Interface

Groups the APB signals into a single interface, simplifying the connection between the DUT and the verification components.

## Test Scenarios

The generator executes the following sequence:

1. Invalid write access to address `0x10`.
2. Write operations to all four valid registers.
3. Another invalid write access to address `0x10`.
4. Read operations from all four valid registers.
5. Invalid read access to address `0x10`.

The complete sequence contains **11 transactions**.

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
```

## Simulation

The project can be compiled using Synopsys VCS from the repository root directory.

### Compilation

```bash
vcs -sverilog +incdir+tb \
    tb/APB_if.sv \
    tb/apb_tb_pkg.sv \
    rtl/APB.sv \
    tb/tb.sv \
    -o simv
```

### Execution

```bash
./simv
```

The testbench also generates a VCD waveform file named `dump.vcd`, which can be inspected using a compatible waveform viewer.

## Results

Simulation results should be documented after compiling and executing the testbench.

The `docs/screenshots/` directory can contain screenshots of the scoreboard output and waveform inspection to demonstrate the verification results.

## Key Concepts

This project demonstrates the use of:

- SystemVerilog classes and object-oriented testbench organization.
- Randomized transaction generation.
- Mailboxes for communication between verification components.
- Virtual interfaces for connecting class-based components to DUT signals.
- A reference-model scoreboard.
- APB SETUP and ACCESS phases.
- Error-response verification.
- Active-low asynchronous reset behavior.
- Modular RTL verification architecture.

## Future Improvements

Potential improvements include adding dedicated reset verification, increasing randomized stimulus coverage, adding functional coverage, and extending the protocol checks to cover additional APB timing and error conditions.

## Disclaimer

This project is intended for educational purposes and as part of a digital design and RTL verification portfolio. Compilation and simulation results must be confirmed in the target simulator before the testbench is reported as passing.
