% funcion para calcular la matriz de alineacion de med_imu referido a
% med_cam

function [matriz_ali0,matriz_ali]= matriz_cambio_base(med_cal,m_imu,instante,nombre,desviacion)

   
p1=med_cal.Rigid_Body_Marker.(strcat(nombre,'_Marker1')).Position;
p2=med_cal.Rigid_Body_Marker.(strcat(nombre,'_Marker2')).Position;
p3=med_cal.Rigid_Body_Marker.(strcat(nombre,'_Marker3')).Position;  

P1=mean(p1);
P2=mean(p2);
P3=mean(p3);

d1=sqrt(sum((P1-P2).^2));
d2=sqrt(sum((P1-P3).^2));
d3=sqrt(sum((P3-P2).^2));

if d1==max([d1,d2,d3])
    c=P3;
        
    if(d2>d3)
        by=c-P1;
        bx=c-P2;
    else
        by=c-P2;
        bx=c-P1;
    end

elseif  d2==max([d1,d2,d3])
    c=P2;    

    if(d1>d3)
        by=c-P1;
        bx=c-P3;
    else
        by=c-P3;
        bx=c-P1;
    end
    
elseif  d3==max([d1,d2,d3])
    c=P1;    

    if(d1>d2)
        by=c-P2;
        bx=c-P3;
    else
        by=c-P3;
        bx=c-P2;
    end

end

bz = cross(bx,by);

bx=bx/norm(bx);
by=by/norm(by);
bz=bz/norm(bz);

matriz_ali0=[bx',by',bz']*desviacion;

matriz_ali=(matriz_ali0)*(quat2dcm(m_imu.Quat(instante,:)))';
end