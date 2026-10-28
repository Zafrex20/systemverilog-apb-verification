# APB Scoreboard Results

## Summary

- **Transactions shown:** 10
- **Passed:** 10
- **Failed:** 0
- **Overall result:** PASS

## Transaction Log

```text
==================================================
                 SCOREBOARD
==================================================

[Transaction 1] WRITE
Address        : 10
PWDATA         : 98
PSLVERR check   : PASS (error esperado reportado)
RESULT          : PASS

[Transaction 2] WRITE
Address        : 0
PWDATA         : fb
PSLVERR check   : PASS (sin error esperado)
RESULT          : PASS

[Transaction 3] WRITE
Address        : 4
PWDATA         : b5
PSLVERR check   : PASS (sin error esperado)
RESULT          : PASS

[Transaction 4] WRITE
Address        : 8
PWDATA         : 12
PSLVERR check   : PASS (sin error esperado)
RESULT          : PASS

[Transaction 5] WRITE
Address        : c
PWDATA         : 8f
PSLVERR check   : PASS (sin error esperado)
RESULT          : PASS

[Transaction 6] WRITE
Address        : 10
PWDATA         : 73
PSLVERR check   : PASS (error esperado reportado)
RESULT          : PASS

[Transaction 7]  READ
Address        : 0
Expected PRDATA: fb
PSLVERR check   : PASS (sin error esperado)
RESULT          : PASS

[Transaction 8]  READ
Address        : 4
Expected PRDATA: b5
PSLVERR check   : PASS (sin error esperado)
RESULT          : PASS

[Transaction 9]  READ
Address        : 8
Expected PRDATA: 12
PSLVERR check   : PASS (sin error esperado)
RESULT          : PASS

[Transaction 10]  READ
Address        : c
Expected PRDATA: 8f
PSLVERR check   : PASS (sin error esperado)
RESULT          : PASS
```

## Notes

- All 10 transactions shown in this output passed the scoreboard checks.
- Invalid write accesses to address `0x10` correctly reported the expected `PSLVERR`.
- Read operations returned the expected values for all four valid registers.
- This output contains 10 transactions; it does not show the final invalid read transaction described in the planned 11-transaction sequence.
