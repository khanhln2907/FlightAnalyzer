classdef XYData
    %Simple class representing data consisting of an array of X and Y data of equal length
    
    properties (Access = public)
        X
        Y
    end
    
    methods
                
        function obj = XYData(x,y)
            obj.X = x;
            obj.Y = y;            
        end
        
        function value = get.X(obj)
            value = obj.X;            
        end
        
        function value = get.Y(obj)
            value = obj.Y;
        end
    end
    
end

