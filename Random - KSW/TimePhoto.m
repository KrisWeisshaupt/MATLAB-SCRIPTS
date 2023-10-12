obj = videoinput('matrox', 1);
while 1                             % endless loos
   %Acquire and display a single frame of data.
   frame = getsnapshot(obj);        % take an image
   image(frame);                    % show the image
   pause(5);                        % wait for 5 seconds
end