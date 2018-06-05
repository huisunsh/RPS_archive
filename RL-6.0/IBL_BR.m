function [Decision] = IBL_BR(probR,probP,probS )
if probR > probP
        if probR > probS % opponent most likely to make R
            Decision = 1;%best response P
        else
            Decision = 0;
        end;
    else
        if probP < probS
            Decision = 0;
        else
            Decision = 2;
        end;
end;

end



