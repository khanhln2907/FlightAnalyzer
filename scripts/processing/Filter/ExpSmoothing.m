classdef ExpSmoothing < FilterBase
    %EXPSMOOTHING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        alpha = 0.0        
        sPrev = 0.0
        sCur = 0.0
    end
    
    methods
        function obj = ExpSmoothing(fs, tau)
            obj.alpha = 1.0 / fs / tau;
        end
            
        function out = compute(obj, input)
            obj.sPrev = obj.sCur;
            obj.sCur = obj.alpha * input + (1 - obj.alpha) * obj.sPrev;
            out = obj.sCur;
        end
        
        function outVec = process(obj, inputVec)
            outVec = zeros(numel(inputVec),1);
            for i = 1:numel(inputVec)
                outVec(i) = obj.compute(inputVec(i));
            end
        end
        
        
        function test(obj)
           vec = [linspace(1,1,20), linspace(5,5,20), linspace(-10,-10,20), linspace(20,20,20)];
           out = obj.process(vec);
           
           figure
           plot(vec, "-o"); hold on; grid on;
           plot(out, "-o");
        end
    end
end

