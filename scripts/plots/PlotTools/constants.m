%% Letzte Aenderung: 12.09.2016

classdef constants

    properties (Constant)
        
        s2ms            =   1000;                                           %
        ms2s            =   1/1000;                                         %
        m2km            =   1/1000;                                         %
        km2m            =   1000;                                           %
        m2mm            =   1000;                                           %
        mm2m            =   1/1000;                                         %
        m2cm            =   100;                                            %
        cm2m            =   1/100;                                          %
        m2dm            =   10;                                             %
        dm2m            =   1/10;                                           %
        mm2cm           =   1/10;                                           %
        cm2mm           =   10;                                             %
        l2m             =   1/1000;                                         %
        m2l             =   1000;                                           %
        ft2m            =   0.3048;                                         %
        m2ft            =   1/0.3048;                                       %
        in2m            =   0.0254;                                         %
        m2in            =   1/0.0254;                                       %
        in2mm           =   25.4;                                           %
        mm2in           =   1/25.4;                                         %
        mpa2bar         =   10;                                             %
        bar2mpa         =   1/10;                                           %
        mpa2pa          =   1*10^6;                                         %
        pa2mpa          =   1/(1*10^6);                                     %
        bar2pa          =   1*10^5;                                         %
        pa2bar          =   1/10^5;                                         %
        psi2bar         =   0.0689475729;                                   %
        bar2psi         =   1/0.0689475729;                                 %
        psi2pa          =   6894.76;                                        %
        psi2mpa         =   0.006894759086775369;                           %
        mpa2psi         =   1/0.006894759086775369;                         %
        kg2g            =   1000;                                           %
        g2kg            =   1/1000;                                         %
        lbf2kg          =   0.4536;                                         %
        kg2lbf          =   1/0.4536;                                       %
        slugft3tokgm3   =   515.378818;                                     %
        kgm3toslugft3   =   1/515.378818;                                   %
        rad2deg         =   180/pi;                                         %
        deg2rad         =   pi/180;                                         %
        rpm2rads        =   pi*2/60;                                        % 
        rads2rpm        =   60/(pi*2);                                      %
        m_s2km_h        =   3.6;                                            %
        km_h2m_s        =   1/3.6;                                          %
        g_0             =   9.80665;                                        % [m/s^2] Earth Gravity
        R               =   8.314472;                                       % [J/(mol*K)] universal Gas Constant
        Rs_air          =   287.058;                                        % [J/(mol*K)] specific Gas Constant of Air
        Rs_N2           =   296.8;                                          % [J/(mol*K)] spezifische Gaskonstante Stickstoff
        k               =   5.670373e-8;                                    % [W/(m^2*K^4)] Boltzmannkonstante, manchmal auch als sigma bezeichnet
        u2kg            =   1.660538921e-27;                                % Atomare Masseneinheit in kg umgerechnet
        kg2u            =   1/1.660538921e-27;                              %
        m_el            =   9.10938356e-31;                                 % [kg] Masse eines Elektrons
        e_lad           =   1.6021766208e-19;                               % [C] Elementarladung eines Elektrons
        
        % Konstanten fuer die Dichten
        rho_Oktogen     =   1910;                           % [kg/m^3] Dichte von Oktogen (RDX) [C4H8N8O8]
        rho_Hexogen     =   1820;                           % [kg/m^3] Dichte von Hexogen (HMX) [C3H6N6O6]
        rho_TNT         =   1650;                           % [kg/m^3] Dichte von Trinitrotoluol TNT [C7H5N3O6]
        rho_C           =   2100;                           % [kg/m^3] Dichte von Graphit [C] (variiert zwischen 2.1 und 2.26, abhaengig vom Kristall)
        rho_Al          =   2700;                           % [kg/m^3] Dichte von Aluminium [Al]
        rho_Fe          =   7874;                           % [kg/m^3] Dichte von Eisen (rein)
        
        
         % Konstanten fuer die Plots
        FS_axes         =   18;                                                 
        FS_plot         =   18;
        FS_title        =   20;
        FS_linienbreite =   2.5;
        Pos_Groesse_full=   get(0,'Screensize');
        Pos_Groesse_SVGA=   [0, 0, 800, 600];
        Pos_Groesse_WXGA=   [0, 0, 1280, 800];
        Pos_Groesse_HD  =   [0, 0, 1920, 1080];
        Pos_Groesse_VGA =   [0, 0, 640, 480];
        Pos_Groesse_A4  =   [0, 0, 29.7, 21];                               % [cm] Groesse eines A4 Blattes, quer
        Pos_DISS_std    =   [0, 0, 16, 11];                 % [cm] Groesse eines A4 Blattes, quer
        Pos_Word        =   [0, 0, 8, 6];             % [cm] Groesse eines A4 Blattes, quer
        
        akt_Zeit        =   clock;
        
    end
    
    methods
        function Zeit_str = Zeitstempel(obj)
            
            
            Date_Vec = obj.akt_Zeit ;
            Year = num2str(Date_Vec(1)) ;
            Month = num2str(Date_Vec(2)) ;
            
            if Date_Vec(2) < 10
                Month = ['0', Month] ;
            end
            
            Day = num2str(Date_Vec(3)) ;
            
            if Date_Vec(3) < 10
                Day = ['0', Day] ;
            end
            
            Hour = num2str(Date_Vec(4)) ;
            
            if Date_Vec(4) < 10
                Hour = ['0', Hour] ;
            end
            
            Minute = num2str(Date_Vec(5)) ;
            
            if Date_Vec(5) < 10
                Minute = ['0', Minute] ;
            end
            
            Second = num2str(round(Date_Vec(6)));
            
            if Date_Vec(6) < 10
                Second = ['0', Second] ;
            end
            
            Zeit_str = [Year,'_',Month,'_',Day,'_-_',Hour,'-',Minute,'-',Second] ;
        end
    end
end
