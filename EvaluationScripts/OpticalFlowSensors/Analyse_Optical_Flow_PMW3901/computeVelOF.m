function [vx, vy] = computeVelOF(time, dx, dy, phi, theta, psi)
index = 1:numel(dx);
SAMPLE_TIME_MS = 10;
PATCH = 10;
startIndex = 0;
maxIndex = numel(time);
sumDx = 0;
sumDy = 0;


while (maxIndex - startIndex) > PATCH
    startIndex = startIndex + PATCH;
    for i = 1: PATCH - 1
        currentIndex = startIndex + 1;
        sumDx = sumDx + dx(currentIndex);
        sumDy = sumDy + dy(currentIndex);
        
    end
end







vx = 0
vy = 0

end