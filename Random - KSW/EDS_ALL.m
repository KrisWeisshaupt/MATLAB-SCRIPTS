clear all;
close all;
clc;

files = dir('*.TIF');
results = {'Sample','O','Al','Si'};


for file = files'
    
    clearvars -except files file results 
    
    t = Tiff(file.name,'r');
    image=t.read();
    [RGB,A] = t.readRGBAImage();
    
    %t.getTag('ImageDescription')
    info=imfinfo(file.name);
    width=info.Width;
    height=info.Height;
       
    set(figure(1), 'Position', [0 0 width*1.1111 height*1.5]);
    desc=strcat(info.ImageDescription);
    location=strfind(desc,'Pixel_Size=');
    [pixelSize, remain]=strtok(desc(location(1,1)+11:location(1,1)+50));
    pixelSize=str2double(pixelSize);
    pixUnits=strrep(strtok(remain),'?','m');
    if ~all(pixUnits  < 128)
        pixUnits = '\mum';
    end
 
    
    location=strfind(desc,'RasterBox=');
    
    
    if ~isempty(location)
        box=strtok(desc(location(1,1)+10:location(1,1)+50));
        old=box;
        box=str2num(box);
        %old = box;
        %box(3)=box(3)-box(1);
        %box(4)=box(4)-box(2);
        %box*width;
        
        eds=info(1).UnknownTags(1).Value;
        eSlope = str2double(strtok(info(1).UnknownTags(2).Value))/1000; %keV spacing per point in eds
        eOffset = str2double(strtok(info(1).UnknownTags(3).Value))/1000; %keV value of first point in eds
        
        energy=eOffset:eSlope:eSlope*(numel(eds)-1);
        
        subplot(4,1,4)
        title('')
        H=area(energy,eds,0);
        H(1).FaceColor = [0.7 0.7 0.999];
        %h=get(H,'children');
        %set(h,'FaceColor',[0 0 1]);
        %truesize(im,[width height]);
        xlabel('Energy (keV)');
        
        ylabel('Count');

        set(gca,'XTick',0.0:0.5:15.0);

        xlim([0.0 11])
        ylim([0 1.1*max(eds)])
        %set(gca,'position',[0.075 0.04 0.90 0.25],'units','normalized')
        subplot(4,1,[1 2 3])
        
        results = [results; {file.name, max(eds(round(0.4/eSlope):round(0.6/eSlope))), max(eds(round(1.4/eSlope):round(1.6/eSlope))),max(eds(round(1.7/eSlope):round(1.8/eSlope)))}];
    else
        subplot(4,1,[1 2 3 4])
    end
    

    iptsetpref('ImshowAxesVisible','on');
    imshow(t.read, 'XData', [0 width*pixelSize], 'YData', [0 height*pixelSize])
    ylabel(['Distance (' pixUnits ')']);
    xlabel(['Distance (' pixUnits ')']);
    
    axis image;
    %axis(image((t.read())))
    %rectangle('position',box*pixelSize, ...
    %    'edgecolor','y')
    if ~isempty(location)
        box=box*pixelSize;
        v = [box(1) box(2); box(3) box(2); box(1) box(4); box(3) box(4)];
        f = [1 2 4 3];
        p=patch('Faces',f,'Vertices',v,...
            'EdgeColor','blue','FaceColor','none','LineWidth',1);
        set(p,'EdgeAlpha',0.4);
    end
    %set(gca,'position',[0.075 0.22 0.9 0.9],'units','normalized')
    set(gca, 'LooseInset', get(gca,'TightInset'))
    
    

    %set(gca, 'LooseInset', get(gca,'TightInset'))
    
    t.close();
    
    hgexport(gcf,strcat(file.name,'.png'),hgexport('factorystyle'),'Format','png')
    
end