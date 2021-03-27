function fr = openVid()
    v = VideoReader('project.mp4');
    d = vision.DeployableVideoPlayer;
    bg = rgb2gray(readFrame(v));
    last_frame_car = -1;
    ball = imread('ball.png');
    ball = rgb2gray(ball);
    thresh = graythresh(ball) * 256;
    ratio = 1.82/v.Width;
    frame_time = 1/v.FrameRate;
    sum = 0;
    count = 0;
    while hasFrame(v)
        org = readFrame(v);
        next = rgb2gray(org);
        ans = abs(bg-next);
        diff_size = size(ans);
        
        frame_start = 1;
        for row = 1: diff_size(1)
            for col = 1: diff_size(2)
                if ans(row,col) > thresh
                    ans(row,col) = 255;
                    
                    if (last_frame_car ~= -1 && frame_start == 1)
                        pixel_distance = abs(last_frame_car - col);
                        actual_distance = pixel_distance * ratio;
                        speed = actual_distance/frame_time;
                        sum = sum + speed;
                        count = count + 1;
                        frame_start = 0;
                    end
                    last_frame_car = col;
                else
                    ans(row,col) = 0;
                end
            end
        end
        d.step(org);
        pause(1/v.FrameRate);
    end
    fr = (sum/count);
    fprintf('Average Speed = %f m/s\n', fr);
    
end