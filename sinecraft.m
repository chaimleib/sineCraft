fs = 48000;
len_t = 1024;
m = 8;

vs = 34030; % speed of sound at sea level, in cm/s

fprintf('Computing %g samples. fs is %g.\n', len_t, fs);
fprintf('Length is %g seconds or\n',len_t/fs);
fprintf('1/%g of a second.\n',fs/len_t);
fprintf('Distance traversed is %g centimeters.\n',len_t/fs*vs);

t = 0:len_t-1;

  % freq        phase   ampl        offset
params = [ ...
    60,         0,      2^14,       2^15        ; ... %1
    100,        0,      2^14,       2^15        ; ... %2   
    200,        0,      2^14,       2^15        ; ... %3   
    440,        0,      2^14,       2^15        ; ... %4
    880,        0,      2^14,       2^15        ; ... %5   
    1000,       0,      2^14,       2^15        ; ... %6   
    5000,       0,      2^14,       2^15        ; ... %7   
    8000,       0,      2^14,       2^15        ...   %8
    ];
    
f       = params(:,1)';
phase   = params(:,2)';
A       = params(:,3)';
offset  = params(:,4)';

% s = samples
s = zeros(m,len_t);

for i=1:m
    fprintf('\nComputing waveform %d:\n',i);
    fprintf('    f      = %g\n',    f(i));
    fprintf('    A      = %g\n',    A(i));
    fprintf('    phase  = %g\n',    phase(i));
    fprintf('    offset = %g\n',  offset(i));
    s(i,:) = round(A(i)*sin((t+phase(i)).*2*pi*f(i)/fs)+offset(i));
end

s=s';

fprintf('\nSaving...\n');
for i=1:m
    file = sprintf('%d-%d.dat', f(i), phase(i));
    dlmwrite(file, s(:,i));
    fprintf('  Saved %s\n', file);
end

fprintf('\nPlotting...\n');
leg = cell(m,1);
for i=1:m
    if i ~= 1 
        hold all;
    end
    plot(t, s(:,i), '-');
    leg{i} = strcat(        ...
        num2str(f(i)),      ...
        'Hz \phi',          ...
        num2str(phase(i)));
end
legend(leg);
hold off;

fprintf('[Done]\n\n');

