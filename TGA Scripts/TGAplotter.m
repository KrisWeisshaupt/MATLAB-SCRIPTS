clear all;
close all;
clc;
%% Initialize variables.
files = dir('*.txt');


results = {'Sample', '120', '300', '475', '850', 'Min', 'MaxWO3'};



figure;
xlabel('Temperature °C')
ylabel('Weight %')
xlim([50 950])

hold on;

for file = files'
    clearvars -except results files file lines elements xMin xMax yMin yMax
    file.name
    delimiter = '\t';
    startRow = 36;
    
    %% Read columns of data as strings:
    % For more information, see the TEXTSCAN documentation.
    formatSpec = '%*q%q%q%q%q%q%q%[^\n\r]';
    
    %% Open the text file.
    fileID = fopen(file.name,'r');
    [filepath,name,ext] = fileparts(file.name)
    
    %% Read columns of data according to format string.
    % This call is based on the structure of the file used to generate this
    % code. If an error occurs for a different file, try regenerating the code
    % from the Import Tool.
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
    
    %% Close the text file.
    fclose(fileID);
    
    %% Convert the contents of columns containing numeric strings to numbers.
    % Replace non-numeric strings with NaN.
    raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
    for col=1:length(dataArray)-1
        raw(1:length(dataArray{col}),col) = dataArray{col};
    end
    numericData = NaN(size(dataArray{1},1),size(dataArray,2));
    
    for col=[1,2,3,4,5,6]
        % Converts strings in the input cell array to numbers. Replaced non-numeric
        % strings with NaN.
        rawData = dataArray{col};
        for row=1:size(rawData, 1);
            % Create a regular expression to detect and remove non-numeric prefixes and
            % suffixes.
            regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
            try
                result = regexp(rawData{row}, regexstr, 'names');
                numbers = result.numbers;
                
                % Detected commas in non-thousand locations.
                invalidThousandsSeparator = false;
                if any(numbers==',');
                    thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                    if isempty(regexp(numbers, thousandsRegExp, 'once'));
                        numbers = NaN;
                        invalidThousandsSeparator = true;
                    end
                end
                % Convert numeric strings to numbers.
                if ~invalidThousandsSeparator;
                    numbers = textscan(strrep(numbers, ',', ''), '%f');
                    numericData(row, col) = numbers{1};
                    raw{row, col} = numbers{1};
                end
            catch me
            end
        end
    end
    
    
    %% Replace non-numeric cells with NaN
    R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
    raw(R) = {NaN}; % Replace non-numeric cells
    
    %% Allocate imported array to column variable names
    Time = cell2mat(raw(:, 1));
    Time(find(isnan(Time)))=[];
    Weight = cell2mat(raw(:, 2));
    Weight(find(isnan(Weight)))=[];
    ProgramTemp = cell2mat(raw(:, 4));
    ProgramTemp(find(isnan(ProgramTemp)))=[];
    SampleTemp = cell2mat(raw(:, 5));
    SampleTemp(find(isnan(SampleTemp)))=[];
    
    
    Percent = 100*Weight./Weight(1);
    
    P120 = Percent(find(SampleTemp>120,1));
    P300 = Percent(find(SampleTemp>300,1));
    P475 = Percent(find(SampleTemp>475,1));
    P850 = Percent(find(SampleTemp>850,1));
    Pmin = min(Percent);
    PmaxWO3= max(Percent(find(SampleTemp>900,1):end));
    
    
    
    if(~isempty(strfind(name, '3108')))
        plot(SampleTemp, Percent, 'Color', [0 0 randi([4, 10])/10]);
    end
    
    if(~isempty(strfind(name, 'C9')))
        plot(SampleTemp, Percent, 'Color', [0 randi([4, 10])/10 0]);
    end
    
    if(~isempty(strfind(name, 'A9')))
        plot(SampleTemp, Percent, 'Color', [randi([4, 10])/10 0 0]);
    end
    

    shg
    drawnow
    
    counts = {name, P120, P300, P475, P850, Pmin, PmaxWO3};
    results = [results; counts];
    
    
end

