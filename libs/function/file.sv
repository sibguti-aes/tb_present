`ifndef FILE_SV
`define FILE_SV

function automatic void readFileStrBits (string nameFile, ref bit outBits[][]);
    int file = $fopen(nameFile, "r");
    string readBit;
    while($fscanf(file, "%s\n", readBit) == 1) begin
        bit tmpBits[] = new [$size(readBit)];
        for (int i = 0; i < $size(readBit); i++) begin
            if (readBit[i] != "1" && readBit[i] != "0") continue;
            tmpBits[i] = (readBit[i] == "1" ? 1 : 0);
        end
        outBits = {outBits, tmpBits};
    end
    $fclose(file);
    return;    
endfunction

function automatic void writeFileBitsStr (string nameFile, ref bit outBits[][]);
    int file = $fopen(nameFile, "w");
    for (int i = 0; i < $size(outBits) ; i++ ) begin
        for (int j = 0; j < $size(outBits[i]) ; j++ ) begin
            $fwrite(file ,"%b",outBits[i][j]);
        end
        $fwrite(file ,"\n");
    end  
    $fclose(file);
    return;    
endfunction

`endif
