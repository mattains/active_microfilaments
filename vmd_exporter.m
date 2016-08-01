%% vmd_exporter
% Exports the data from the rstore variable into an '.xyz' file so that it
% may be viewed used VMD.
%
% Version 0.100

close all
tic

%% Setup
nn = size(rstore);
timecount = nn(1);
n_2 = round(n/2);

pos_x = zeros(timecount,1);
pos_y = zeros(timecount,1);
pos_z = zeros(timecount,1);

%% Determine current number of tests
list = dir('Results\*.txt');
r = length(list);
if r ~= 0
    [~,c] = size(list(r).name);
end

% The next number
new_num = r + 1;

% Break if max number of files reached
if new_num == 9999
    fprintf('Warning, maximum tests reached (~1000). Please move old test data to another folder\n')
    return;
end

if      new_num < 10
    z = '000';
elseif  new_num < 100
    z = '00';
elseif  new_num < 1000
    z = '0';
else
    clear z;
end

% Make the new number into a string
new_name = [z,num2str(new_num)];
% And create the whole string
name_data = ['.\Results\active_filament_test_',new_name,'.xyz'];

%% Write xyz file for VMD

% Check to make sure we aren't deleting any data, and change the number if
% we are

for ii = 1:r
    if name_data(11:c+10) == list(ii).name
        new_num = new_num + 1;
        % Break if max number of files reached
        if new_num == 9999
            fprintf('Warning, maximum tests reached (~1000). Please move old test data to another folder\n')
            return;
        end
        
        if      new_num < 10
            z = '000';
        elseif  new_num < 100
            z = '00';
        elseif  new_num < 1000
            z = '0';
        else
            clear z;
        end
        % Make the new number into a string
        new_name = [z,num2str(new_num)];
        % And create the whole string
        name_data = ['.\Results\active_filament_test_',new_name,'.xyz'];
    end
end

fid=fopen(name_data,'w');
fprintf(fid,'%0.0f\n\n', nn(2));      % Number of molecules

% Convert from 2D if needed
if nn(3) == 2
    fprintf('2D input, converting to 3D...')
    rstore_temp = zeros(timecount,n,3);
    for ii = 1:nn(1)
        for jj = 1:nn(2)
            rstore_temp(ii,jj,1) = rstore(ii,jj,1);
            rstore_temp(ii,jj,2) = rstore(ii,jj,2);
        end
    end
    rstore = rstore_temp;
end

% Output to file
for ii = 1:nn(1)
    for jj = 1:nn(2)
        fprintf(fid,'atom%0.0f \t%0.5f \t%0.5f \t%0.5f',jj-1,rstore(ii,jj,1),rstore(ii,jj,2),rstore(ii,jj,3));
        fprintf(fid,'\n');
        
    end
    % Dummy atom, which is needed for some reason
    fprintf(fid,'atom%0.0f \t%0.5f \t%0.5f \t%0.5f',nn(2),1,1,1);
    fprintf(fid,'\n');
    fprintf(fid,'\n');
end

fclose(fid);
fprintf('Data set exported to .xyz file, number %s\n',new_name)


%% Create path history file for VMD

for i = 1:timecount
    pos_x(i) = mean(rstore(i,:,1));
    pos_y(i) = mean(rstore(i,:,2));
    pos_z(i) = mean(rstore(i,:,3));
end

name_path = ['.\Results\active_filament_test_',new_name,'_path.xyz'];
fid=fopen(name_path,'w');


% Convert from 2D if needed
if nn(3) == 2
    fprintf('2D input, converting to 3D...')
    rstore_temp = zeros(timecount,n,3);
    for ii = 1:nn(1)
        for jj = 1:nn(2)
            rstore_temp(ii,jj,1) = rstore(ii,jj,1);
            rstore_temp(ii,jj,2) = rstore(ii,jj,2);
        end
    end
    rstore = rstore_temp;
end

% Output to file

fprintf(fid,'%0.0f\n\n', nn(1));      % Number of molecules, increases each step
    
for ii = 1:nn(1)
    
    % Place 'atoms' at mean position up to the most recent timestep
    for jj = 1:ii
        fprintf(fid,'atom%0.0f \t%0.5f \t%0.5f \t%0.5f',jj-1,pos_x(jj),pos_y(jj),pos_z(jj));
        fprintf(fid,'\n');       
    end
    
    % Hide other atoms on the first point
    for jj = ii+1:nn(1)
        fprintf(fid,'atom%0.0f \t%0.5f \t%0.5f \t%0.5f',jj-1,pos_x(1),pos_y(1),pos_z(1));
        fprintf(fid,'\n');       
    end
    
    % Dummy atom, which is needed for some reason, placed at (1,1,1),
    % Doesn't actually appear in VMD
    fprintf(fid,'atom%0.0f \t%0.5f \t%0.5f \t%0.5f',nn(1),1,1,1);    
    fprintf(fid,'\n');
    fprintf(fid,'\n');
end

fclose(fid);
fprintf('Path history exported to .xyz file, number %s\n',new_name)

%% Output parameters to a text file
name_txt = ['.\Results\active_filament_test_',new_name,'.txt'];
fid=fopen(name_txt,'w');

% Put a title in and record running time
fprintf(fid,'Test %1.0f\n',new_num);
fprintf(fid,'Time to comeplete: %1.0f seconds\n', time_total);

% Output different variables depending on initial conditions
if      init_type == 1  % Sine
    fprintf(fid,'Sine wave initialization\n\n');
    fprintf(fid,'amp = \t\t\t\t\t %f\n', amp);                          % amp
    fprintf(fid,'k = \t\t\t\t\t %f \tThe wave number\n', k);            % k
    fprintf(fid,'Omega = \t\t\t\t %f\n', w);                            % w
    
elseif  init_type == 2  % Straight line
    fprintf(fid,'Straight line initialization\n\n');
    
elseif  init_type == 3  % Helix
    fprintf(fid,'Helix initialization\n\n');
    fprintf(fid,'Radius = \t\t\t\t %f\n', rad);                         % Radius of helix
    fprintf(fid,'Height step = \t\t\t\t %f\n', h_step);                 % Initial height step        
    
elseif  init_type == 4  % Bent line
    fprintf(fid,'Bent line initialization\n\n');
    
end

fprintf(fid,'timestep(sec) = \t\t %f.10\n', timestep*timescale);        % timestep
fprintf(fid,'Spring stiffness = \t\t %.2f\n', s1);                      % s1
fprintf(fid,'Bending stiffness = \t %.2f\n', s2);                       % s2
fprintf(fid,'Delta s = \t\t\t\t %f\n', dels);                           % dels
fprintf(fid,'Activity (sigma_0) = \t\t %f\n',sig0);                     % sig0, Activity coefficient
fprintf(fid,'Length = \t\t\t\t %f\n', len);                             % length
fprintf(fid,'Number of beads = \t\t %.0f\n', n);                        % n
fprintf(fid,'Friction factor = \t\t %f\n', delta);                      % Friction

fclose(fid);
fprintf('Data parameters saved to a .txt file, number %s\n',new_name)

%% Create a viewpoint file for VMD
name_view = ['.\Results\active_filament_test_',new_name,'_VP.tcl'];
fid = fopen(name_view,'w');

% Title stuff
fprintf(fid,'proc viewchangerender_restore_my_state {} {\n');
fprintf(fid,'  variable ::VCR::viewpoints\n\n');

for ii = 1:timecount
    % 0 - Don't know what this is?
    fprintf(fid,'  set ::VCR::viewpoints(%1.0f,0) { {{1 0 0 0} {0 1 0 0} {0 0 1 0} {0 0 0 1}} }\n',                        ii);
    % 1 - Possibly centre point
    fprintf(fid,'  set ::VCR::viewpoints(%1.0f,1) { {{1 0 0 %f} {0 1 0 %f} {0 0 1 %f} {0 0 0 1}} }\n',                     ii,pos_x(ii),pos_y(ii),pos_z(ii));
    % 2 - Don't know what this is?
    fprintf(fid,'  set ::VCR::viewpoints(%1.0f,2) { {{0.148094 0 0 0} {0 0.148094 0 0} {0 0 0.148094 0} {0 0 0 1}} }\n',   ii);
    % 3 - Don't know what this is?
    fprintf(fid,'  set ::VCR::viewpoints(%1.0f,3) { {{1 0 0 0} {0 1 0 0} {0 0 1 0} {0 0 0 1}} }\n',                        ii);
    % 4 - Appears to be frame number;
    fprintf(fid,'  set ::VCR::viewpoints(%1.0f,4) { %1.0f }\n',ii,ii-1);
end

% More syntax stuff, just need to do frame number and specify file
for ii = 1:timecount       
    fprintf(fid,'  set ::VCR::representations(%f,active_filament_test_%s.xyz) [list Points_11.000000-all-Name-Opaque ]\n',           ii,new_name);
    fprintf(fid,'  set ::VCR::representations(%f,active_filament_test_%s_path.xyz) [list Points_11.000000-all-ResType-Opaque ]\n',   ii,new_name);
end

% Another syntax thing, open, fill in list of frames, close
fprintf(fid,'  set ::VCR::movieList "1 ');
for ii = 2:timecount-1
    fprintf(fid,'%1.0f ',ii);
end
fprintf(fid,'%1.0f"\n',timecount);

fprintf(fid,'  set ::VCR::movieTimeList "12.5 0.0"\n');
fprintf(fid,'  set ::VCR::movieTime 20\n');
fprintf(fid,'  set ::VCR::movieDuration 30.00 \n');
fprintf(fid,'  ::VCR::calctimescale 0\n');
fprintf(fid,'  global PrevScreenSize\n');
fprintf(fid,'  set PrevScreenSize [display get size]\n');
fprintf(fid,'  proc RestoreScreenSize {} { global PrevScreenSize; display resize [lindex $PrevScreenSize 0] [lindex $PrevScreenSize 1] }\n');
% Set size of window in pixels
fprintf(fid,'  display resize 1000 1000\n');
fprintf(fid,'  if { [parallel noderank] == 0 } {\n');
path = ['G:\Uni 2016\MEC4401\Code\3D',name_view(2:end)];
fprintf(fid,'    puts "Loaded viewchangerender viewpoints file %s "\n',path);
fprintf(fid,'    puts "Note: The screen size has been changed to that stored in the viewpoints file."\n');
fprintf(fid,'    puts "To restore it to its previous size type this into the Tcl console:\n  RestoreScreenSize"\n');
fprintf(fid,'  }\nreturn\n}\n\n\n');
fprintf(fid,'viewchangerender_restore_my_state');

fclose(fid);
fprintf('View point for VMD saved to a .tcl file, number %s\n',new_name)

%% Make sure everything is closed
fclose all;

toc




