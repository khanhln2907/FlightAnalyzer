classdef BiquadDF2 < handle
    %BIQUADDF2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        a1
        a2
        b0
        b1
        b2
        v
        v1 % y[n]
        v2 % y[n-1]
        v3 % y[n-2]
        output
    end
    
    methods
        function obj = BiquadDF2(coeff)
            % BIQUADDF2 Construct an instance of this class
            if(numel(coeff) ~= 6)
                error("BoquadDF2: Wrong Filter Coefficients");
            end      
            obj.b0 = coeff(1);
            obj.b1 = coeff(2);
            obj.b2 = coeff(3);
            obj.a1 = coeff(5);
            obj.a2 = coeff(6);
            obj.v = zeros(1,3);
        end
        
        function out = compute(obj, input)
            % Direct form II calculation
            obj.v(1) = input - obj.a1 * obj.v(2) - obj.a2 * obj.v(3);
            obj.output = obj.b0 * obj.v(1) + obj.b1 * obj.v(2) + obj.b2 * obj.v(3);

            obj.v(3) = obj.v(2);
            obj.v(2) = obj.v(1);
            out = obj.output;
        end
        
        
    end
end

