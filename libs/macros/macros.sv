`ifndef MACROS
`define MACROS
    `ifndef TRUE
        `define TRUE       1'b1
    `endif

    `ifndef FALSE
        `define FALSE      1'b0
    `endif

    `ifndef VALUE_NAME_TO_STR
        `define VALUE_NAME_TO_STR(value) `"value`"
    `endif

    `include "../function/params.sv"
    `ifndef PM
        `define PM(matr) printMatrBits(`"matr`", matr);
    `endif
    `ifndef PA
        `define PA(arr) printArrBits(`"arr`", arr);
    `endif
    `ifndef PV
        `define PV(value) $write("%s = %d\n", `"value`", value);
    `endif
`endif