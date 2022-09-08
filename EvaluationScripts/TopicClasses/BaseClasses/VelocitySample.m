classdef VelocitySample < Sample
    %VelocitySAMPLE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
%         function obj = VelocitySample(topicName, sampleTable, fs)
%             obj = obj@Sample(topicName, sampleTable, fs);
%         end
        
        function [out] = get_analyzed_fieldname(obj)
            out = obj.dataFormat;
        end
        
        function obj = set_data_format(obj)
           obj.dataFormat = VelocityFormat;
        end
        
        function preprocess_data(obj)
            % Super class method to convert the time stamp from us to s
            preprocess_data@Sample(obj);      
            obj.data.VelTotal = (obj.data.VelNorth.^2 + obj.data.VelEast.^2 + obj.data.VelDown.^2).^(1/2);           
        end
        
        
        function isValid = check_data_format(obj)
            flag = isfield(obj.data, ["Time", "Count", "VelNorth", "VelEast", "VelDown"]);
            isValid = all(flag == 1);
        end
        
        
        %% Transfer a velocity sample in NED frame to Body frame
        % Input: Attitude
        % Output: VelocityBodySample
        function velSample = to_body_frame(obj, attitudeSample)
            % Interpolate te attitude sample to our timestamp
            intplAttSample = attitudeSample.interpolate(obj.data.Time); 
            [vBody] = VelocitySample.tran_VNED_to_VBody([obj.data.VelNorth, obj.data.VelEast, obj.data.VelDown], ...
                                       [intplAttSample.data.Phi, intplAttSample.data.Theta, intplAttSample.data.Psi]);
                                   
            dataTable.Time = obj.data.Time * 1e6;
            dataTable.Count = obj.data.Count;
            dataTable.State = obj.data.State;
            dataTable.Vx = vBody(:,1);
            dataTable.Vy = vBody(:,2);
            dataTable.Vz = vBody(:,3);
            velSample = VelocityBodySample(append(obj.topic,"_Body"), dataTable, obj.fs);
        end
        
        
        
    end
    
     methods(Static)
       function vBody = tran_VNED_to_VBody(vNED, attDeg)
            attRad = attDeg * pi/180;
            func = trans_func();
            n = (numel(vNED(:,1)));
            vBody = zeros(n, 3);
            for i = 1:n
                vBody(i,:) = func.ned_to_body(vNED(i,:)', attRad(i,:));
            end
       end
   end
end


