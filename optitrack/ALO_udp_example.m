%% Commands for UDP communication
% echoudp('on',4012) % starts sending echoes on port 4012, ('off') finish

% Syntax udp_object = udp('_Remote Host Here (PI,DHPC)_', ...
% _Remote Port Number_, 'LocalPort', _Local Port Number_)

% Host 1 UDP
u1 = udp('127.0.0.1', 'RemotePort', 8866, 'LocalPort', 8844)
fopen(u1)
u1

fprintf(u1, 'Ready for data transfer.')

fclose(u1)
delete(u1)
clear u1


% Host 2 UDP
u2 = udp('127.0.0.1', 'RemotePort', 8844, 'LocalPort', 8866)
fopen(u2)
u2

fscanf(u2)

fclose(u2)
delete(u2)
clear u2