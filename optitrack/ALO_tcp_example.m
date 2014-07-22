%% Commands for TCP/IP client/server communication
% echotcpip('on',4012) % starts sending echoes on port 4012, ('off') finish

IPserver = '0.0.0.0'    % 0.0.0.0 Puts the local IP by default
PortServer = 30000;     % Server connection port

% Server code:
t=tcpip(IPserver, PortServer, 'NetworkRole', 'server')
fopen(t);
% Now open communication (connect) from client (another instance)
t       % information on tcp/ip - notice RemoteHost and Status

%data=fread(t, t.BytesAvailable);
%plot(data);

% Now send the message from client, then read it:
message = fscanf(t)
% You can also send a message back to the client:
fprintf(t, 'message received');

fclose(t)
delete(t)
clear t



% Client:

%data=sin(1:64);
%plot(data);

t=tcpip('localhost', 30000, 'NetworkRole', 'client')
fopen(t)

%fwrite(t, data)
message = 'Hello!';
fprintf(t, message)

fscanf(t)

fclose(t);
delete(t);
clear t