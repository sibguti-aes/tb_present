`ifndef PARAMS_SV
`define PARAMS_SV

`include "file.sv"

function automatic void initParams (string nameInFile, ref bit inBits[][], ref bit outBits[][]);
    readFileStrBits(nameInFile, inBits);
    outBits = new [inBits.size()];
    for (int i = 0; i < inBits.size(); i++) begin
        outBits[i] = new [inBits[i].size()];
    end
endfunction

function automatic void printArrBits (string name_of_arr, bit arr[], string post_show_str = "");
    $write("%0s: ", name_of_arr);
    for (int i = 0; i < $size(arr); i++ ) begin
        $write("%0b", arr[i]);
    end
    $write("%0s", post_show_str);
endfunction

function automatic void printMatrBits (string name_of_matr, bit matr[][]);
    $write("%0s: \n", name_of_matr);
    for (int i = 0; i < $size(matr); i++ ) begin
        $write(" [%0d]", i);
        printArrBits("", matr[i], "\n");
    end
endfunction

typedef bit bitArr[];
function automatic bitArr xorArrBits (bitArr arr1, bitArr arr2);
    bitArr newArr;
    if ($size(arr1) != $size(arr2))
        $fatal("Error, arr1.size != arr2.size");
    newArr = new [$size(arr1)];
    for (int i = 0; i < $size(arr1); i++ ) begin
        newArr[i] = arr1[i] ^ arr2[i];
    end
    return newArr;
endfunction

typedef bit bitMatr[][];
function automatic bitMatr xorMatrBits (bitMatr matr1, bitMatr matr2);
    bitMatr newMatr;
    if ($size(matr1) != $size(matr2))
        $fatal("Error, matr1.size != matr2.size");
    newMatr = new [$size(matr1)];
    for (int i = 0; i < $size(matr1); i++ ) begin
        newMatr[i] = xorArrBits(matr1[i], matr2[i]);
    end
    return newMatr;
endfunction

`endif
