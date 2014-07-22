function [str_length] = ALO_mylength(vector)
    str_length = length(vector);
    if (str_length > 9)
        str_length = num2str(str_length);
    else
        str_length = ['0' num2str(str_length)];
    end
end