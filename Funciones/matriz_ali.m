% funcion para calcular la matriz de alineacion de med_imu referido a
% med_cam

function [Rb0,Rb]= matriz_ali(med_imu,med_cam)

    % variables
    num_imus= length(med_imu);
%     med_cam_euler=unwrap(quat2eul([med_cam.Rigid_Body.RigidBody.Rotation(:,4), med_cam.Rigid_Body.RigidBody.Rotation(:,1:3)]));
    
    for n=1:num_imus % igualamos frecuencias de los imus con las camaras
%         med_imu_euler{n}=unwrap(quat2eul(med_imu{1}.Quat));
%         
%         m{n}=mean(med_cam_euler(1:init,:))-mean(med_imu_euler{n}(1:init,:));

        A1=quat2dcm(med_cam.Rigid_Body.RigidBody.Rotation);
%         A2=quat2dcm(med_cam.Rigid_Body.RigidBody.Rotation(2000,:));
        
        B1=quat2dcm(med_imu{n}.Quat);
%         B2=quat2dcm(med_imu{n}.Quat(2000,:));
        
%         C=[0 0 1; 0 1 0; -1 0 0];
        
        for t=500:1000%1:length(med_imu{n}.Quat)-1
            med0(:,:,t)=(A1(:,:,t)*A1(:,:,t+1)*inv(B1(:,:,t))*inv(B1(:,:,t+1)))^(1/2);
            med(:,:,t)=inv(A1(:,:,t))*med0(:,:,t)*B1(:,:,t);
        end
        Rb0=mean(med0,3);
        Rb=mean(med,3);
%         m_ali{n}=eul2quat(m{n},'XYZ')
    end
    
    
end