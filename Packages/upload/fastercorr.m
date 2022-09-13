% Code calculates cross correlation between two time series.
% the time series may be different length.
%
% Author: Ünal Dikmen,
% Ankara University, Geophysical Engineering Dept., Ankara-Turkey
% 08.04.2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input variables:
%  x: time series 1
%  y: time series 2
% Output variables:
% cc: cross correlation 
% lag: lag time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [cc,lag]=fastercorr(x,y)
n = length(x);
m = length(y);
if(size(x,2)>1),x = x'; end 
if(size(y,2)>1),y = y'; end
 cc = zeros(n+m-1,1);
  for i=1:m
      c = y(m-i+1).*x(:);
      cc((i:n+i-1)) = cc( i:n+i-1 ) + c(:);
  end
lag = -m+1:n-1;  
end
