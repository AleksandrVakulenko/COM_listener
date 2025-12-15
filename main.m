
% V1.0
%
% TODO (2025.12.15):
% 1) Add loging
% 2) Add print to console
% 3) Do some tests

COM_port_host = "COM11"; % one side of com0com link
COM_port_device = "COM5"; % real device port
BAUD_rate = 9600; % same baud rate for both ports

% settings
pause_time = 0.05; % [s]

% init loop variables
Bytes_from_host = 0;
Bytes_from_device = 0;
Time_arr = [];
Bytes_from_host_arr = [];
Bytes_from_device_arr = [];


clc
[ser_host, ser_device] = connect(COM_port_host, COM_port_device, BAUD_rate);

try
    fig = create_figure();
    Timer_obj = tic;
    while(~figure_should_close(fig))
        Time = toc(Timer_obj);
        
        % get data
        data_from_host = read_data(ser_host);
        data_from_device = read_data(ser_device);

        % send data (if any)
        if ~isempty(data_from_device)
            write(ser_host, data_from_device, "uint8");
        end
        if ~isempty(data_from_host)
            write(ser_device, data_from_host, "uint8");
        end


        Bytes_from_host = Bytes_from_host + numel(data_from_host);
        Bytes_from_device = Bytes_from_device + numel(data_from_device);

        Time_arr = [Time_arr Time];
        Bytes_from_host_arr = [Bytes_from_host_arr Bytes_from_host];
        Bytes_from_device_arr = [Bytes_from_device_arr Bytes_from_device];

        plot_number_of_bytes(fig, Time_arr, Bytes_from_host_arr, ...
            Bytes_from_device_arr);
        drawnow
        pause(pause_time)
    end
catch err
    delete(ser_host);
    delete(ser_device);
    delete(fig)
    disp('Both serial obj closed (in catch)')
    rethrow(err);
end


delete(fig)
disp('finish (main)')

delete(ser_host);
delete(ser_device);
disp('Both serial obj closed')






%% Serial part
function [ser_host, ser_device] = connect(COM_port_host, COM_port_device, BAUD_rate)
ser_host = serialport(COM_port_host, BAUD_rate);
try
    ser_device = serialport(COM_port_device, BAUD_rate);
catch err
    detele(ser_host);
    rethrow(err)
end
disp("Serial ports ready")
end



function data = read_data(ser_obj)
    N = ser_obj.NumBytesAvailable;
    if N > 0
        data = uint8(ser_obj.read(N, "uint8"));
    else
        data = uint8([]);
    end
end

%% Figure part


function fig = create_figure()
res = get(0, 'ScreenSize');
X_pos = res(3)*0.20;
Y_pos = res(4)*0.32;
X_size = res(3)*0.35;
Y_size = res(4)*0.33;

fig = figure('Position', [X_pos Y_pos X_size Y_size]);
button_exit = uicontrol("Style", "pushbutton", "String", "Exit", ...
    "Callback", @exit_foo, "UserData", struct('stop', false), ...
    "Position", [20,20,82.5,33.5]);
fig.UserData = struct('Exit_btn', button_exit);

end

function flag = figure_should_close(fig)
    flag = fig.UserData.Exit_btn.UserData.stop;
end


function exit_foo(a, ~)
a.UserData.stop = true;
end







function plot_number_of_bytes(fig, Time, Num_bytes_from_host, ...
    Num_bytes_from_device)
            
        figure(fig);

        subplot('Position', [0.08 0.45 0.38 0.5]);
        plot(Time, Num_bytes_from_host)
        ylabel('bytes from host')
        xlabel('time, s')
        set(gca, 'fontsize', 10)

        subplot('Position', [0.56 0.45 0.38 0.5]);
        plot(Time, Num_bytes_from_device)
        ylabel('bytes from device')
        xlabel('time, s')
        set(gca, 'fontsize', 10)
end






