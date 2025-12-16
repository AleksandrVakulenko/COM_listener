
% Special type of callback for my Temp_controller_N2

COM_port_host = "COM11"; % one side of com0com link
COM_port_device = "COM6"; % real device port
BAUD_rate = 9600; % same baud rate for both ports


clc

[ser_host, ser_device] = ...
    link_serial_ports(COM_port_host, COM_port_device, BAUD_rate);


% init loop variables and run main
Bytes_from_host = 0;
Bytes_from_device = 0;
Time_arr = [];
Bytes_from_host_arr = [];
Bytes_from_device_arr = [];
try
    fig = create_figure();
    while(~figure_should_close(fig))
        Time = toc(Timer_obj);

        Bytes_from_host = ser_host.UserData.bytes_counter;
        Bytes_from_device = ser_device.UserData.bytes_counter;

        Time_arr = [Time_arr Time];
        Bytes_from_host_arr = [Bytes_from_host_arr Bytes_from_host];
        Bytes_from_device_arr = [Bytes_from_device_arr Bytes_from_device];

        plot_number_of_bytes(fig, Time_arr, Bytes_from_host_arr, ...
            Bytes_from_device_arr);
        
        drawnow
        pause(0.001)
    end
catch err
    delete(ser_host);
    delete(ser_device);
    delete(fig)
    disp('Both serial obj closed (in catch)')
    rethrow(err);
end

Host_data_final = ser_host.UserData;
Device_data_final = ser_device.UserData;

delete(fig)
disp('finish (main)')

delete(ser_host);
delete(ser_device);
disp('Both serial obj closed')


%% Serial and Callback part

function [ser_host, ser_device] = ...
    link_serial_ports(COM_port_host, COM_port_device, BAUD_rate)

    ser_host = serialport(COM_port_host, BAUD_rate);
    
    try
        ser_device = serialport(COM_port_device, BAUD_rate);
    catch err
        delete(ser_host);
        rethrow(err)
    end
    disp("Serial ports ready")
    
    try
        configureCallback(ser_host, "byte", 5, @BytesAvCallback);
        configureCallback(ser_device, "byte", 1, @BytesAvCallback);
    catch err
        delete(ser_host);
        delete(ser_device);
        rethrow(err)
    end
    disp("Callback ready")


    % init timer
    Timer_obj = tic;

    % init UserData for both serial obj
    Host_data = struct('name', "host", ...
                       'link', ser_device, ...
                       'timer', Timer_obj, ...
                       'bytes_counter', 0, ...
                       'log', []);
    
    Device_data = struct('name', "device", ...
                         'link', ser_host, ...
                         'timer', Timer_obj, ...
                         'bytes_counter', 0, ...
                         'log', []);
    
    % set UserData
    ser_host.UserData = Host_data;
    ser_device.UserData = Device_data;
end


function BytesAvCallback(ser_obj, ~)
    Data = ser_obj.UserData;
    Name = char(Data.name);
    ser_link = Data.link;
    Timer_obj = Data.timer;
    
    Time = toc(Timer_obj);
    
    N = ser_obj.NumBytesAvailable;
    if N > 0
        data = ser_obj.read(N, "uint8");
        data = uint8(data);
    
        write(ser_link, data, "uint8");
        disp([Name ' <' num2str(N) '>: ' num2str(data)])
    
        log_record = struct('name', Name, ...
                            'time', Time, ...
                            'data', data);
    
        ser_obj.UserData.log = [ser_obj.UserData.log log_record];
        ser_obj.UserData.bytes_counter = ser_obj.UserData.bytes_counter + N;
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
        plot(Time, Num_bytes_from_host, '-b')
        ylabel('bytes from host')
        xlabel('time, s')
        set(gca, 'fontsize', 10)

        subplot('Position', [0.56 0.45 0.38 0.5]);
        plot(Time, Num_bytes_from_device)
        ylabel('bytes from device')
        xlabel('time, s')
        set(gca, 'fontsize', 10)
end







%% UNUSED

function BytesAvCallback_special_UNUSED(ser_obj, ~)
    Data = ser_obj.UserData;
    Name = char(Data.name);
    ser_link = Data.link;
    Timer_obj = Data.timer;
    
    Time = toc(Timer_obj);
    
    N = ser_obj.NumBytesAvailable;
    if N > 0
        data = ser_obj.read(N, "uint8");
        data = uint8(data);
        if Name == "host"
            K = N/5;
            for i = 1:K
                range = ((i-1)*5:(i*5-1))+1;
                write(ser_link, data(range), "uint8");
                disp([Name ' <' num2str(5) '>: ' num2str(data(range))])
                pause(0.001)
            end
        else
            write(ser_link, data, "uint8");
            disp([Name ' <' num2str(N) '>: ' num2str(data)])
        end
        
        log_record = struct('name', Name, ...
                            'time', Time, ...
                            'data', data);
    
        ser_obj.UserData.log = [ser_obj.UserData.log log_record];
        ser_obj.UserData.bytes_counter = ser_obj.UserData.bytes_counter + N;
    end
end







