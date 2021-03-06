
% medicion=cargar_datos_shimmer('Sensor_BAD7.txt')
% medicion=cargar_datos_shimmer('G:\Mi unidad\Mediciones shimmer\14-03-2019\DefaultTrial_Session1_Shimmer_D54E_Calibrated_SD.csv',nombre)

function [medicion]= cargar_datos_shimmer(file,name)
    [filepath,~,ext] = fileparts(file);
    medicion=[];
    if (nargin<2)
		name='imu';
    end
    medicion.Nombre=name;
    if ext=='.csv'
        
        med=readtable(file,'ReadVariableNames',false,'TextType','string');
        
        cont=contains(med{1,:},'Time');
        medicion.tiempo=  str2double(med{3:end,cont});
%         medicion.tiempo=medicion.tiempo-medicion.tiempo(1);
        
        cont_accel=contains(med{1,:},'Accel');
        
        cont=contains(med{1,:},{'LN','Low','MPU'});
        medicion.Accel_LN=  str2double(med{3:end,cont & cont_accel});

        cont=contains(med{1,:},{'WR','Wide'});
        medicion.Accel_WR=  str2double(med{3:end,cont & cont_accel});

        cont=contains(med{1,:},'Gyro');
        medicion.Gyro=  str2double(med{3:end,cont});

        cont=contains(med{1,:},'Mag');
        medicion.Mag=  str2double(med{3:end,cont});
        
        cont=contains(med{1,:},'Quat');
        medicion.Quat=  str2double(med{3:end,cont});
        
    elseif ext=='.txt'
        med=readtable(file,'ReadVariableNames',false,'TextType','string');
%         medicion=medicion{:,:};        
        cont=contains(med{1,:},'Time');
        medicion.tiempo=  str2double(med{2:end,cont});
%         medicion.tiempo=medicion.tiempo-medicion.tiempo(1);
        
        cont_accel=contains(med{1,:},'Accel');
        
        cont=contains(med{1,:},{'LN','Low','MPU'});
        medicion.Accel_LN=  str2double(med{2:end,cont & cont_accel});

        cont=contains(med{1,:},{'WR','Wide'});
        medicion.Accel_WR=  str2double(med{2:end,cont & cont_accel});
        
        cont=contains(med{1,:},'Gyro');
        medicion.Gyro=  str2double(med{2:end,cont});

        cont=contains(med{1,:},'Mag');
        medicion.Mag=  str2double(med{2:end,cont});
        
        cont=contains(med{1,:},'Quat');
        medicion.Mag=  str2double(med{3:end,cont});
        
    else
        disp('Formato no soportado.')
    end
    
    
        
        
end