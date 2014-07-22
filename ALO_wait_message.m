function [scan] = ALO_wait_message(t,scan_timeout)
    j = 0;
    while(j < scan_timeout)
        if( t.BytesAvailable > 0)   %get(t, 'BytesAvailable')
            scan = str2num(char(fread(t, t.BytesAvailable)));
            bytes = t.BytesAvailable;   % Checks is entire message
            if( bytes > 0)
                disp( sprintf('WARN: Message incomplete.\n\tMessage: %s or %f\tBytes available: %d',scan,scan,bytes));
            end

            if ~isempty(scan)
                j = 0;
                return
            else
                disp('Scan is empty. No request acknowledged');
                return
            end

        else
            pause(1)
            j = j+1;
        end
    end
    
    if(j >= scan_timeout)
        disp('Wait timeout passed');
        scan = [];
        return
    end
end