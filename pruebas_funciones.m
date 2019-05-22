
addpath('Funciones\')
med_cal=cargar_datos_camara('G:\Mi unidad\Universidad\Doctorado\Mediciones\Datos optitrack\10-05-2019\Calibracion Robot_Shimmer.csv');
med_cam=cargar_datos_camara('G:\Mi unidad\Universidad\Doctorado\Mediciones\Datos optitrack\10-05-2019\Take 2019-05-10 12.55.42 PM.csv');
med_imu=cargar_datos_shimmer('G:\Mi unidad\Universidad\Doctorado\Mediciones\Datos shimmer\10-05-2019\2019-05-10_12.51 (1).11_default_exp_SD_Session1\default_exp_Session1_idBFED_Calibrated_SD','BFED');
med_cam.Rigid_Body.RigidBody.Rotation=-[med_cam.Rigid_Body.RigidBody.Rotation(:,4), med_cam.Rigid_Body.RigidBody.Rotation(:,1:3)];
% med_imu.Quat=med_imu.Quat(:,5:8);
%med_cam.Rigid_Body.RigidBody.Rotation=-med_cam.Rigid_Body.RigidBody.Rotation;
%%
plot_camara_imu_2D(med_cam,{med_imu});
%%
med_imu_s=sincronizar_imus(med_cam,{med_imu},1);
plot_camara_imu_2D(med_cam,med_imu_s);
%%
med_imu_s=sincronizar_imus(med_cam,{med_imu},3950-1115);
%02-05-2019: 5804-911
%10-05-2019,12: 3233-1146
plot_camara_imu_2D(med_cam,med_imu_s);
%% calculo y aplicacion cambio de base entre espacios de camara y sensores imu
[mcb0,mcb1]=matriz_cambio_base(med_cal,med_imu_s{1},1,'Shimmer');

med_imu_s{1}=transformacion_cuaterniones(med_imu_s{1},mcb0,mcb1)

%%
% 
% sincronizar(med_cam,med_imu_s{1},1);
%%
plot_camara_imu_2D(med_cam,med_imu_s);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calibracion Sensor y calculo Quat

clc
clear all
addpath('Funciones\')

med_cal=cargar_datos_camara('G:\Mi unidad\Universidad\Doctorado\Mediciones\Datos optitrack-shimmers\17-05-2019\test1\Calibracion_imus.csv');
med_cam=cargar_datos_camara('G:\Mi unidad\Universidad\Doctorado\Mediciones\Datos optitrack-shimmers\17-05-2019\test1\Take 2019-05-17 01.44.21 PM.csv');
med_imu=cargar_datos_shimmer('G:\Mi unidad\Universidad\Doctorado\Mediciones\Datos optitrack-shimmers\17-05-2019\test1\default_exp_Session1_idBFED_Calibrated_SD.csv','BFED');

% med_imu.Quat=med_imu.Quat(:,5:8);
med_cam.Rigid_Body.RigidBody.Rotation=-[med_cam.Rigid_Body.RigidBody.Rotation(:,4), med_cam.Rigid_Body.RigidBody.Rotation(:,1:3)];

%%
imus_calibrados=[];
% calibrado
% [imus_calibrados]= calibracion_shimmer({med_imu});
imus_calibrados{1}=med_imu;
imus_calibrados{1}.Quat=quaternion_9DOF(imus_calibrados{1},mean(1./diff(med_imu.tiempo)*1000));

imus_calibrados=sincronizar_imus(med_cam,imus_calibrados,3710-1237);
% plot_camara_imu_2D(med_cam,imus_calibrados);

%%
% sin calibrar
% imus_calibrados{2}=med_imu;
% imus_calibrados{2}.Quat=quaternion_9DOF(med_imu,mean(1./diff(med_imu.tiempo)*1000));

[mcb0,mcb1]=matriz_cambio_base(med_cal,imus_calibrados{1},1,'RigidBody');
imus_calibrados{1}=transformacion_cuaterniones(imus_calibrados{1},mcb0,mcb1)
plot_camara_imu_2D(med_cam,imus_calibrados);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ejemplo configuracion Sensores 
SensorMacros = SetEnabledSensorsMacrosClass;    
configuracion_shimmer('5',100,{SensorMacros.LNACCEL,SensorMacros.GYRO,SensorMacros.MAG,'Quat'})






%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Error de las camras en comparacion con el movimiento real del robot %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Cargar datos
% Fecha:10/05/2019

addpath('Funciones\')
med_cal=cargar_datos_camara('G:\Mi unidad\Universidad\Doctorado\Mediciones\Datos optitrack\10-05-2019\Calibracion Robot_Shimmer.csv');
med_cam=cargar_datos_camara('G:\Mi unidad\Universidad\Doctorado\Mediciones\Datos optitrack\10-05-2019\Take 2019-05-10 12.55.42 PM.csv');
med_imu=cargar_datos_shimmer('G:\Mi unidad\Universidad\Doctorado\Mediciones\Datos shimmer\10-05-2019\2019-05-10_12.51 (1).11_default_exp_SD_Session1\default_exp_Session1_idBFED_Calibrated_SD.csv','BFED');
med_cam.Rigid_Body.RigidBody.Rotation=-[med_cam.Rigid_Body.RigidBody.Rotation(:,4), med_cam.Rigid_Body.RigidBody.Rotation(:,1:3)];

%% Movimientos del robot

T0=1160; % Tiempo parado hasta el primer movimiento 
T=2055-1615; % tiempo parado entre movimientos
q1=[0.6533   -0.2706    0.6533   -0.2706].*ones(T0,4);
q2=[0   -0.3827    0.9239         0].*ones(T,4);
q3=[0    0.3827    0.9239         0].*ones(T,4);
q4=[0   -0.9239   -0.3827         0].*ones(T,4); %[0   -0.9239   -0.3827         0]
q5=[0   -0.9239    0.3827         0].*ones(T,4);
q6=[0.9239         0         0   -0.3827].*ones(T,4);

% Transitorio=ones(50,4);
med_robot=[];
med_robot.Quat=[q1;q2;q3;q4;q5;q6];
[mcb0,mcb1]=matriz_cambio_base(med_cal,med_robot,100,'Robot',[1 0 0; 0 1  0 ; 0 0 1]);

med_robot=transformacion_cuaterniones(med_robot,mcb0,mcb1);

med_robot.Euler=quat2eul(med_robot.Rotation);
med_cam.Rigid_Body.RigidBody.Euler=quat2eul(med_cam.Rigid_Body.RigidBody.Rotation);
med_robot.Nombre='robot';

plot_camara_imu_2D(med_cam,{med_robot});


%% Calculo error en angulos de euler

% Se calculara el error comparando las ventanas de movimientos en parado.
% Si el periodo es de T, se dejara un margen de 50 muestras entre cada
% ventana en cada movimiento para evitar el transitorio.

T1=T0-T; % Inicio de la primera ventana

for i=1:6
   
    dif_ventanas=abs(med_robot.Euler(T1+T*(i-1)+25:T1+T*i-25,:)-med_cam.Rigid_Body.RigidBody.Euler(T1+T*(i-1)+25:T1+T*i-25,:));
    
    Err(i,:)=mean(dif_ventanas,1);
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Comparaicon del calculo de cuaterniones en online y offline %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Fecha:21/05/2019

med_imu=cargar_datos_shimmer('G:\Mi unidad\Universidad\Doctorado\Mediciones\Datos shimmer\21-05-2019\2019-05-21_10.16.03_default_exp_SD_Session1\default_exp_Session1_Shimmer_BAD7_Calibrated_SD.csv','BAD7');
med_imu2=cargar_datos_shimmer('G:\Mi unidad\Universidad\Doctorado\Mediciones\Datos shimmer\21-05-2019\2019-05-21_10.51.17_default_exp_SD_Session1\default_exp_Session1_Shimmer_BAD7_Calibrated_SD.csv','BAD7');
med_imu3=cargar_datos_shimmer('G:\Mi unidad\Universidad\Doctorado\Mediciones\Datos shimmer\21-05-2019\2019-05-21_10.51.17_default_exp_SD_Session1_quat\default_exp_Session1_Shimmer_BAD7_Calibrated_SD.csv','BAD7');
med_imu4=cargar_datos_shimmer('G:\Mi unidad\Universidad\Doctorado\Mediciones\Datos shimmer\21-05-2019\2019-05-21_14.00.34_default_exp_SD_Session1\default_exp_Session1_Shimmer_BAD7_Calibrated_SD.csv','BAD7');
med_imu5=cargar_datos_shimmer('G:\Mi unidad\Universidad\Doctorado\Mediciones\Datos shimmer\21-05-2019\2019-05-21_14.10.28_default_exp_SD_Session1\default_exp_Session1_Shimmer_BAD7_Calibrated_SD.csv','BAD7');
med_imu6=cargar_datos_shimmer('G:\Mi unidad\Universidad\Doctorado\Mediciones\Datos shimmer\21-05-2019\2019-05-21_14.17.38_default_exp_SD_Session1\default_exp_Session1_Shimmer_BAD7_Calibrated_SD.csv','BAD7');
med_imu7=cargar_datos_shimmer('G:\Mi unidad\Universidad\Doctorado\Mediciones\Datos shimmer\21-05-2019\2019-05-21_14.17.38_default_exp_SD_Session1_quat\default_exp_Session1_Shimmer_BAD7_Calibrated_SD.csv','BAD7');
med_imu8=cargar_datos_shimmer('G:\Mi unidad\Universidad\Doctorado\Mediciones\Datos shimmer\21-05-2019\2019-05-21_14.17.38_default_exp_SD_Session1_quat_LN\default_exp_Session1_Shimmer_BAD7_Calibrated_SD.csv','BAD7');

%%

plot(med_imu.Quat,'r') % Online, sensores sin calibrar
hold on
plot(med_imu2.Quat,'b') % Online, sensores calibrados
plot(med_imu3.Quat(:,9:12),'g') % Online, sensores calibrados; Offline, 6DOF, 9DOF
plot(med_imu4.Quat,'y') % Online, opcion MPU gyro
plot(med_imu5.Quat,'c') % Online, solo activos low noise accel y gyros
plot(med_imu6.Quat,'c') % Online, Todos los sensores activos activo
plot(med_imu7.Quat(:,5:8),'c') %Online y Offline, 6DOF
plot(med_imu8.Quat,'c') % Offline, 6DOF calculado con Accel_LN