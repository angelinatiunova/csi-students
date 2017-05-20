 clear();

% Initial data
k = 5;
T = 0.1;
epsilon = 0.1;
g_m = 1;

dta = [];
psi = [];

phi = [];

amplitude = [];

open('D:\DOMASHKA\TAU\Labs\\for_angel\lab9\konser.mdl')

omega = 0:0.3:0.9;
w_1 = power(10,omega);
w=10;

for j = 1:length(w_1)
w = w_1(j);

simulation_time = 100 + 2*pi/w*50;
dt = 2*pi/(w*500);
n = 4;

% Simulate
set_param('konser','StopTime','simulation_time','FixedStep','dt') 
sim('konser');

% Calculate
maximum = max(out.signals.values(size(out.signals.values, 1) - floor(n*2*pi/(w*dt)):size(out.signals.values, 1), 1));
minimum = min(out.signals.values(size(out.signals.values, 1) - floor(n*2*pi/(w*dt)):size(out.signals.values, 1), 1));

amplitude(j) = (maximum - minimum)/2;
out.signals.values(:, 1) = out.signals.values(:, 1) - maximum + amplitude(j);

i = size(out.signals.values, 1) - floor(n*2*pi/(w*dt)) - 1;
oldState = [out.signals.values(i, 1), out.signals.values(i, 2)];
currState = [];
firstZeroCrossing = [];
secondZeroCrossing = [];

for i = [size(out.signals.values, 1) - floor(n*2*pi/(w*dt)):1:size(out.signals.values, 1)]
    currState = [out.signals.values(i, 1), out.signals.values(i, 2)];
    if currState(1) < 0 && oldState(1) > 0 
        firstZeroCrossing(length(firstZeroCrossing) + 1, :) = i;
    end
    if currState(2) < 0 && oldState(2) > 0 
        secondZeroCrossing(length(secondZeroCrossing) + 1, :) = i;
    end
    oldState = currState;
end

t1 = out.time(firstZeroCrossing);
t2 = out.time(secondZeroCrossing);
t1 = t1(2:length(t2) - 1);
t2 = t2(2:length(t2) - 1);

phi(j) = sum(t2 - t1)/length(t2);
psi(j) = w*phi(j)*180/pi;


end

amplitude = amplitude';
psi = psi';
w_1 = w_1';

data = [w_1, log10(w_1), amplitude, 20*log10(amplitude), psi];

%
%end
%write(path + dataFileName, dta);