% Postprocessor
close all

%% Setup
nn = size(rstore);
timecount = nn(1);
mov(timecount) = struct('cdata',[],'colormap',[]);
mean_x = zeros(timecount,1);
mean_y = zeros(timecount,1);
n_2 = round(n/2);
h1 = plot(1,1);

%% Determine current number of tests
list = dir('Results\*.mp4');
r = length(list);
list_names = list(r).name;
[~,c] = size(list_names);
num = list_names(1,22:(28-4));

if str2num(num)+1 < 100
    name_temp = ['0',num2str(str2num(num)+1)];
else
    name_temp = [num2str(str2num(num)+1)];
end

if str2num(name_temp) > 998
    fprintf('Warning, maximum tests reached (~1000). Please move old test data to another folder')
    return;   
end

%% Render movie
figure(1);
pause
hold on
for i=1:timecount
    %%    
    
    mean_x(i) = mean(rstore(i,:,1));
    mean_y(i) = mean(rstore(i,:,2));
    
    delete(h1);
    h1 = plot(rstore(i,:,1),rstore(i,:,2),'k-o');    
    plot(mean_x(i),mean_y(i),'*','color','b');
    % Change to plot a point only after a certain distance
    title(['time = ' num2str((i-1)*timestep*timescale) ' , '  num2str(100*i/timecount) '% ']) % Change as necessary

    
    % Set window to follow filament
    axis([rstore(i,n_2,1)-len rstore(i,n_2,1)+len rstore(i,n_2,2)-len rstore(i,n_2,2)+len]) 
    
    % Set window stationary
%     axis([-1 2 -0.5 0.5])
    
    % Record frame
    mov(i) = getframe(gcf);
%     pause
end
hold off

%% Save movie
name = ['.\Results\active_filament_test_',name_temp,'.mp4'];
v = VideoWriter(num2str(name),'MPEG-4');
open(v)
writeVideo(v,mov)
close(v)

%% Save Parameters
name = ['.\Results\active_filament_test_',name_temp,'.txt'];
fid=fopen(name,'w');
fprintf(fid,'Test %1.0f\n\n',str2num(num)+1);
    
fprintf(fid,'amp = \t\t\t\t\t %f\n', amp);                          % amp
fprintf(fid,'timestep(sec) = \t\t %f.10\n', timestep*timescale);       % timestep
fprintf(fid,'Spring stiffness = \t\t %.2f\n', s1);                  % s1    
fprintf(fid,'Bending stiffness = \t %.2f\n', s2);                   % s2
fprintf(fid,'Delta s = \t\t\t\t %f\n', dels);                       % dels
fprintf(fid,'Omega = \t\t\t\t %f\n', w);                            % w
fprintf(fid,'k = \t\t\t\t\t %f\n', k);                              % k
fprintf(fid,'Activity (sigma_0) = \t\t %f\n',sig0);                 % sig0, Activity coefficient
fprintf(fid,'Length = \t\t\t\t %f\n', len);                         % length
fprintf(fid,'Number of beads = \t\t %.0f\n', n);                    % n
fprintf(fid,'Friction factor = \t\t %f\n', delta);                  % Friction

% fprintf(fid,);
fclose(fid);

%% Save position graph
figure(2);
subplot(2,1,1)
hold on
plot(1:i,mean_x(1:i),'o','color','b');
title('Average x position')
hold off
axis([0,(timecount+1),min(mean_x(1:i))-1,max(mean_x(1:i)+1)])

subplot(2,1,2)
hold on
plot(1:i,mean_y(1:i),'o','color','b');
title('Average y position')
hold off
axis([0,(timecount+1),min(mean_y(1:i))-1,max(mean_y(1:i)+1)])

fig.PaperPositionMode = 'auto';
print(['.\Results\active_filament_test_',name_temp,'.jpg'], figure(2), '-djpeg','-r0');

%% Save position history
figure(3);
plot(mean(rstore(:,:,1)'),mean(rstore(:,:,2)'),'.')
title('Filament path')
fig.PaperPositionMode = 'auto';
print(['.\Results\active_filament_test_',name_temp,'.jpeg'], figure(3), '-djpeg','-r0');


fprintf('Data set saved as number %s\n',name_temp)









