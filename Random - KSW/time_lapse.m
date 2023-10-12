%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATLAB Time-Lapse Creator, by Ale152 (Alessandro Masullo)
% Run this script and follow the steps to create your video time lapse from
% your images. Images can be a wide range of format but must be all the
% same size, or you will get an error. The video format is JPEG AVI, you 
% can set frame rate, quality and scale factor without change the code.
%
% More info (in italian) at: http://www.wirgilio.it/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
% Default var
profile = 'Motion JPEG AVI'; % Use 'doc VideoWriter' for more profile info

% Use the menu to change these parameters
vid_length = 0; % Initial video length
vid_FPS = 30;   % Default FPS
vid_qual = 75;  % Default video quality
vid_scf = 1;    % Default scale factor
Nfile = 0;      % Initial number of file

actual_sel = 'No file selected';
actual_file = 'No file selected';

set(0, 'DefaultUIControlFontSize', 12); % Change menu font size

run = 1;
while run
    choice = menu('Welcome to the Time-Lapse MATLAB Editor! Plese select a choice', ...
                  sprintf('1 - Select images [%s]', actual_sel), ...
                  sprintf('2 - Select video file location [%s]', actual_file), ...
                  sprintf('3 - Select video parameters [Video duration: %d sec]', round(vid_length)), ...
                  '4 - BUILD VIDEO!', ...
                  'Close script');
              
    switch choice
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Select images
        case 1
            try
                [file_name, file_path] = uigetfile( ...
                    {'*.jpeg;*.jpg;*.bmp;*.tif;*.tiff;*.png;*.gif', ...
                     'Image Files (JPEG, BMP, TIFF, PNG and GIF)'}, ...
                     'Select Images', 'multiselect', 'on');
                 Nfile = length(file_name);
                 actual_sel = sprintf('%d file selected from: %s', ...
                                      Nfile, file_path);
                 vid_length = Nfile / vid_FPS;
            catch merr
                errordlg(sprintf( ...
                    'Please follow previous steps in proper order!\n%s', ...
                    merr.message), merr.identifier)
            end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Select video file location
        case 2
            try
                [avi_name, avi_path] = uiputfile('*.avi', 'Save video file');
                aviobj = VideoWriter(strcat(avi_path, avi_name) , ...
                                     profile);
                actual_file = strcat(avi_path, avi_name);
            catch merr
                errordlg(sprintf( ...
                    'Please follow previous steps in proper order!\n%s', ...
                    merr.message), merr.identifier)
            end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Select video parameter
        case 3
            try
                prompt = {'Video frame rate (fps):', ...
                          'JPEG Quality (1-100):', ...
                          'Scale factor (bigger > 1, smaller < 1):'};
                default = {num2str(vid_FPS), num2str(vid_qual), num2str(vid_scf)};
                answer = inputdlg(prompt, 'Select video parameters', ...
                                  1, default);
                aviobj.FrameRate = str2num(answer{1});
                aviobj.Quality = str2num(answer{2});
                vid_length = Nfile / str2num(answer{1});
                vid_FPS = str2num(answer{1});
                vid_qual = str2num(answer{2});
                vid_scf = str2num(answer{3});
            catch merr
                errordlg(sprintf( ...
                    'Please follow previous steps in proper order!\n%s', ...
                    merr.message), merr.identifier)
            end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % BUILD VIDEO
        case 4
            if Nfile == 0
                    errordlg('No images selected')
            else
                try 
                    open(aviobj)
                    wb = waitbar(0, 'Please wait...');
                    for i = 1:Nfile
                        img = imread(strcat(file_path, file_name{i}));
                        if vid_scf ~= 1
                            img = imresize(img, vid_scf);
                        end
                        writeVideo(aviobj, img);
                        % Preview image
                        if mod(i, round(Nfile/10)) == 1
                            imshow(img)
                            title(sprintf('Preview image %d/%d', i, Nfile))
                            uistack(wb, 'top')
                        end
                        waitbar(i/Nfile, wb);
                    end
                    delete(wb)
                    close(aviobj);
                catch merr
                    errordlg(sprintf( ...
                        'Please follow previous steps in proper order!\n%s', ...
                        merr.message), merr.identifier)
                end
            end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
        % Close script
        case 5
            run = 0;
    end
end