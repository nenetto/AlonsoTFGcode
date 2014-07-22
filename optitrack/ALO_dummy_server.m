%% Dummy server to simulate robot server
% Must be run on a different Matlab instance

clear all

%% Settings

IPhost = 'localhost';   % 0.0.0.0 will accept any single client address ('localhost' for local)
ServerPort = 30000;     % Connection port (local server port)
% Remote host and port are set when the client is connected
% Seconds checking BytesAvailable for a message before disconnection
scan_timeout = 40;


%% Script
home
t = tcpip(IPhost, ServerPort, 'NetworkRole', 'server'); % Create server
fopen(t)    % Start connection; wait for client.

pause(1)
if ~( strcmp(get(t, 'Status'),'open') )
    disp('WARN: connection is not open');
end

disp('Waiting for requests')
%system('pause')

j = 0;
while(j < scan_timeout)
    if( get(t, 'BytesAvailable') > 0)   % Look for message in transmission
        
        scan = fscanf(t);  % Reads message
        
        bytes = get(t, 'BytesAvailable');   % Checks is entire message
        while( bytes > 0)
            disp( sprintf('WARN: Message incomplete.\n\tMessage: %s\tBytes available: %d',scan,bytes));
%             rescan = input('re-scan? [0/1]\n');
%             if (rescan)
%                 scan = [scan; fscanf(t)];
%                 bytes = get(t, 'BytesAvailable');
%             else
                break;
%        end
        end
        
        if ~isempty(scan)  % Empty, no requests
            j = 0;
            if strcmp(scan(1:size(scan,2)-1), 'next')
                % Send next point
                disp('Requested next. Sending next')
                fprintf(t, sprintf('%f%f%f', -0.4+0.01*rand(1), 0.1+0.01*rand(1), 0.5+0.01*rand(1)));
                
            elseif strcmp(scan(1:size(scan,2)-1), 'end')
                disp('Requested end of communication')
                break
            end
            
        else
            disp('Scan is empty. No request acknowledged');
            fin = input('terminate? [1/0]');
            if fin
                break
            end
        end
    else
        pause(1)
        j = j + 1;
    end
end

if(j >= scan_timeout)
    disp('Wait timeout. Ending communication');
end

fclose(t);
delete(t)
clear t
disp('Transmission closed');