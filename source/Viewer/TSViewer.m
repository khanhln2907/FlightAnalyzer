classdef TSViewer
    
    properties
        TSArr        
    end
    
    methods
        function obj = TSViewer(TSArr)
            obj.TSArr = TSArr;
        end
        
        function obj = plot(obj, varargin)
            nTs = numel(obj.TSArr);
            
            param = Parser.parse(varargin{:});
            
            figure 
            for i = 1 : nTs
               tFilter =  (obj.TSArr(i).Time <= param.tMax) & (obj.TSArr(i).Time >= param.tMin);  
               ax(i) = plot(obj.TSArr(i).Time(tFilter), obj.TSArr(i).Value(tFilter), "-o", "Color", ColorTable.colormat(i,:));
               hold on;                
            end            
            FormatFigure(gcf, 8, 4/3, 'MarkerSize', 3);
        end
        
        
        function obj = plot_multi(obj)
            x = 0:.1:4*pi;
            plot(x,sin(x));
            addaxis(x,sin(x-pi/3));
            addaxis(x,sin(x-pi/2),[-2 5],'linewidth',2);
            addaxis(x,sin(x-pi/1.5),[-2 2],'v-','linewidth',2);
            addaxis(x,5.3*sin(x-pi/1.3),':','linewidth',2);

            addaxislabel(1,'one');
            addaxislabel(2,'two');
            addaxislabel(3,'three');
            addaxislabel(4,'four');
            addaxislabel(5,'five');

            addaxisplot(x,sin(x-pi/2.3)+2,3,'--','linewidth',2);
            addaxisplot(x,sin(x-pi/1),5,'--','linewidth',2);

            legend('one','two','three','four','five','three-2','five-2');
        end
        
        
    end
end

