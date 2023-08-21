clc
clear 
close all


%Example for programming the Thorlabs LTS150 stage with Kinesis in MATLAB.


%Load Assemblies
NET.addAssembly('C:\Program Files\Thorlabs\Kinesis\Thorlabs.MotionControl.DeviceManagerCLI.dll');
NET.addAssembly('C:\Program Files\Thorlabs\Kinesis\Thorlabs.MotionControl.GenericMotorCLI.dll');
NET.addAssembly('C:\Program Files\Thorlabs\Kinesis\Thorlabs.MotionControl.IntegratedStepperMotorsCLI.dll');

import Thorlabs.MotionControl.DeviceManagerCLI.*
import Thorlabs.MotionControl.GenericMotorCLI.*
import Thorlabs.MotionControl.IntegratedStepperMotorsCLI.*

%Initialize Device List
DeviceManagerCLI.BuildDeviceList();
DeviceManagerCLI.GetDeviceListSize();

%Update the serial number for the stage to the one being used.
serial_num='45304374';
timeout_val=60000;

%Set up device and configuration
device = LongTravelStage.CreateLongTravelStage(serial_num);
device.Connect(serial_num);
device.WaitForSettingsInitialized(5000);

motorSettings = device.LoadMotorConfiguration(serial_num);
currentDeviceSettings = device.MotorDeviceSettings;

motorSettings.UpdateCurrentConfiguration();
deviceUnitConverter = device.UnitConverter();

device.StartPolling(250);
device.EnableDevice();
pause(1); %wait to make sure device is enabled


 vel_params = device.GetVelocityParams();
 vel_params.MaxVelocity = 1;
 velpars.Acceleration = 20;
 device.SetVelocityParams(vel_params);

%Home device
%device.Home(timeout_val);
%fprintf('Motor homed.\n');

initial_pos=200;  %10  %40  %300
steps=50;  %50   %120
speed=10;
pauset = 5;
duration_time=steps/speed+4*pauset;

 vel_params = device.GetVelocityParams();
 vel_params.MaxVelocity = speed ; 
 device.SetVelocityParams(vel_params);


 %%
 
 sample='SARA_1';
project=[sample];

af=1;
bf=1;
f0=0;

%% Create a DataAcquisition and Add Analog Input Channels
% Create a DataAcquisition, set the |Rate| property (the default is 1000
% scans per second), and add analog input channels using |addinput|.
dq = daq.createSession('ni');
dq.Rate = 100;
addAnalogInputChannel(dq, "Dev3", "ai1", "Voltage");
dq.DurationInSeconds = duration_time;




%%


lh = addlistener(dq,'DataAvailable',@(src,event) logData(src, event, project, f0,af, bf)); 
startBackground(dq);

device.MoveTo(initial_pos, timeout_val);
pause(pauset)
device.MoveTo(initial_pos-steps, timeout_val);
pause(pauset)
device.MoveTo(initial_pos, timeout_val);
pause(pauset)


%%
%Stop connection to device
device.StopPolling()
device.Disconnect()
%%
data=readtable('SARA_1.csv');
plot(data.Var1,data.Var2)
