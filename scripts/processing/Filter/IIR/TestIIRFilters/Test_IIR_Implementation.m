fs = 200;
t = 0:1/fs:1;
x = sin(2*pi*10*t) + 2 * sin(2*pi*60*t);

G = [0.200826898859902;0.156962997886888;0.091951536795203;0.031070984872226;0.075087137700722;1];
SOS = [ 1	2	1	1	-1.1529	0.9562; 
        1	2	1	1	-1.2455	0.8734;
        1	2	1	1	-1.4313	0.7991;
        1	2	1	1	-1.6192	0.7435;
        1	1	0	1	-0.8498	0];

myFilter = CascadeFilter(5, SOS, G);
filterredX = myFilter.process(x);

figure
plot(t, x);
hold on; grid on; grid minor;
plot(t, filterredX);

%%
[f1, X1] = perform_FFT(x, fs);
[f2, X2] = perform_FFT(filterredX, fs);

figure
stem(f1, X1);
hold on;
stem(f2, X2);


