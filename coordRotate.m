function [verts_r_x,verts_r_y,verts_r_z] = coordRotate(verts_x,verts_y,verts_z,direc,ang)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
Rot_x=[1 0 0; 0 cosd(ang) -sind(ang); 0 sind(ang) cosd(ang)];
Rot_y=[cosd(ang) 0 sind(ang); 0 1 0; -sind(ang) 0 cosd(ang)];
Rot_z=[cosd(ang) -sind(ang) 0; sind(ang) cosd(ang) 0; 0 0 1];
verts_r_x=zeros(size(verts_x));
verts_r_y=verts_r_x;
verts_r_z=verts_r_x;
for i=1:size(verts_x,1)
    if strcmp(direc,'x')==1
        holdMat=Rot_x*[verts_x(i,:);verts_y(i,:);verts_z(i,:)];
        verts_r_x(i,:)=holdMat(1,:);
        verts_r_y(i,:)=holdMat(2,:);
        verts_r_z(i,:)=holdMat(3,:);
    elseif strcmp(direc,'y')==1
        holdMat=Rot_y*[verts_x(i,:);verts_y(i,:);verts_z(i,:)];
        verts_r_x(i,:)=holdMat(1,:);
        verts_r_y(i,:)=holdMat(2,:);
        verts_r_z(i,:)=holdMat(3,:);
    else
        holdMat=Rot_z*[verts_x(i,:);verts_y(i,:);verts_z(i,:)];
        verts_r_x(i,:)=holdMat(1,:);
        verts_r_y(i,:)=holdMat(2,:);
        verts_r_z(i,:)=holdMat(3,:);
    end
end
end

