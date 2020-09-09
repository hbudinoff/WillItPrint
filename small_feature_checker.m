function [badVoxels,heightCOM]=small_feature_checker(xCoords,yCoords,zCoords,...
    stlName,x_move,y_move,z_move,curAxes)

%xCoords,yCoords,zCoords are vectors of the stl vertices
%stlName is string of the stl file name
%x_move,y_move,z_move are the distances the stl vertices must move to be
%plotted in the center
%curAxes is the current axis


%Plot wait bar so they know it's running
currentWait=waitbar(0.1,'Please wait...');


minres=0.2; % (mm) should be less than the feature size and layer thickness
minfeatsize=.85;%(mm)
xco=xCoords;
yco=yCoords;
zco=zCoords;
grid_size_x=ceil(abs(max(max(xco))-min(min(xco)))/minres);
grid_size_y=ceil(abs(max(max(yco))-min(min(yco)))/minres);
grid_size_z=ceil(abs(max(max(zco))-min(min(zco)))/minres);
[OUTPUTgrid,gridX,gridY,gridZ] = VOXELISE(grid_size_x,grid_size_y,grid_size_z,stlName,'xyz');
gridX=gridX+x_move;
gridY=gridY+y_move;
gridZ=gridZ-z_move;
% Start calculating euclidian distance around shape
% Threshold is number of voxels corresponding to min feat size
threshold=minfeatsize/mean([gridX(2)-gridX(1),gridY(2)-gridY(1),gridZ(2)-gridZ(1)]); 
OUTPUTgrid= padarray(OUTPUTgrid,[ceil(threshold) ceil(threshold) ceil(threshold)],0,'both');
comp_OUTPUTgrid=~OUTPUTgrid;
g=bwdist(comp_OUTPUTgrid);
g(g<=threshold)=0; %Only keep values of g that are above the threshold
g=logical(g);
h=bwdist(g);
h(h==0)=.01; %Set interior to some arbitrary value so it is included in rump
h(h>=threshold)=0; %Only keep values of h that are below the threshold
h=logical(h); %h is rump (without additions)
theta=OUTPUTgrid-h;
I=zeros(size(theta,1)+2,size(theta,2)+2,size(theta,3)+2);
R=zeros(size(theta,1)+2,size(theta,2)+2,size(theta,3)+2);
B=zeros(size(theta,1)+2,size(theta,2)+2,size(theta,3)+2);

%need to pad the arrays to make indexing easier
OUTPUTgrid_p= padarray(OUTPUTgrid,[1 1 1],0,'both');
comp_OUTPUTgrid_p=padarray(comp_OUTPUTgrid,[1 1 1],1,'both');
theta_p= padarray(theta,[1 1 1],0,'both');
waitbar(0.5,currentWait);
waitAx=gca;
for i=2:size(theta_p,1)
    for j=2:size(theta_p,2)
        for k=2:size(theta_p,3)
            if theta_p(i,j,k)~=0
                if (OUTPUTgrid_p(i,j,k-1)~=0 && theta_p(i,j,k-1)==0) || ...
                        (OUTPUTgrid_p(i,j,k+1)~=0 && theta_p(i,j,k+1)==0) || ...
                        (OUTPUTgrid_p(i-1,j,k)~=0 && theta_p(i-1,j,k)==0)...
                        ||(OUTPUTgrid_p(i+1,j,k)~=0 && theta_p(i+1,j,k)==0)...
                        ||(OUTPUTgrid_p(i,j-1,k)~=0 && theta_p(i,j-1,k)==0)...
                        ||(OUTPUTgrid_p(i,j+1,k)~=0 && theta_p(i,j+1,k)==0)
                    I(i,j,k)=1;
                elseif comp_OUTPUTgrid_p(i,j,k-1)~=0 ||...
                        comp_OUTPUTgrid_p(i,j,k+1)~=0 ||...
                        comp_OUTPUTgrid_p(i-1,j,k)~=0 ||...
                        comp_OUTPUTgrid_p(i+1,j,k)~=0 ||...
                        comp_OUTPUTgrid_p(i,j+1,k)~=0 ||...
                        comp_OUTPUTgrid_p(i,j-1,k)~=0
                    B(i,j,k)=1;
                end
            end
        end
    end
end

%I think this will mark areas that are categorized as I that could be too
%small of holes as R

T=theta_p-I-B;  % Thin is just the remainder of theta that doesn't belong to I or B
for i=2:size(theta_p,1)
    for j=2:size(theta_p,2)
        for k=2:size(theta_p,3)
            if I(i,j,k)~=0
                if (B(i,j,k-1)==0 && T(i,j,k-1)==0) && ...
                        (B(i,j,k+1)==0 && T(i,j,k+1)==0) && ...
                        (B(i-1,j,k)==0 && T(i-1,j,k)==0) && ...
                        (B(i+1,j,k)==0 && T(i+1,j,k)==0) && ...
                        (B(i,j-1,k)==0 && T(i,j-1,k)==0) && ...
                        (B(i,j+1,k)==0 && T(i,j+1,k)==0)  
                    R(i,j,k)=1;
                    I(i,j,k)=0;
                end
            end
        end
    end
end
erroded=I+T+B;
erroded(erroded>0)=1;
axes(curAxes);

if max(max(max(erroded)))~=0
    badVoxels(1)=PATCH_3Darray(erroded(ceil(threshold)+2:size(erroded,1)-ceil(threshold)-1,ceil(threshold)+2:size(erroded,2)-ceil(threshold)-1,2+ceil(threshold):size(erroded,3)-ceil(threshold)-1),gridX,gridY,gridZ,[0,1,0]);
    set(badVoxels(1), 'Visible','off')
else
    badVoxels(1)=patch('XData',[NaN;NaN;NaN],'YData',[NaN;NaN;NaN],'ZData',...
        [NaN;NaN;NaN],'EdgeColor', 'none','FaceColor',[0 1 0],'AmbientStrength', 0.15); %Plot blank patch for legend
    set(badVoxels(1), 'Visible','off')
end
axes(waitAx);
% if max(max(max(I)))~=0
%     badVoxels(1)=PATCH_3Darray(I(ceil(threshold)+2:size(I,1)-ceil(threshold)-1,ceil(threshold)+2:size(I,2)-ceil(threshold)-1,2+ceil(threshold):size(I,3)-ceil(threshold)-1),gridX,gridY,gridZ,[1,0,0]);
% end
% if max(max(max(T)))~=0
%     badVoxels(2)=PATCH_3Darray(T(ceil(threshold)+2:size(T,1)-ceil(threshold)-1,ceil(threshold)+2:size(T,2)-ceil(threshold)-1,2+ceil(threshold):size(T,3)-ceil(threshold)-1),gridX,gridY,gridZ,[1,0,0]);
% end
% if max(max(max(B)))~=0
%     badVoxels(3)=PATCH_3Darray(B(ceil(threshold)+2:size(T,1)-ceil(threshold)-1,ceil(threshold)+2:size(T,2)-ceil(threshold)-1,2+ceil(threshold):size(T,3)-ceil(threshold)-1),gridX,gridY,gridZ,[1,0,0]);
% end

%Only want one of these 3 calcs to appear in legend since they have the
%same color
% if max(max(max(I)))~=0
%     set(get(get(badVoxels(2),'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); %turn off display so only one ite
%     set(get(get(badVoxels(3),'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); %turn off display so only one ite
% elseif max(max(max(T)))~=0
%     set(get(get(badVoxels(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); %turn off display so only one ite
%     set(get(get(badVoxels(3),'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); %turn off display so only one ite
% elseif max(max(max(B)))~=0
%     set(get(get(badVoxels(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); %turn off display so only one ite
%     set(get(get(badVoxels(2),'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); %turn off display so only one ite
% end


waitbar(0.7,currentWait);
%Do the opposite process to find thin holes
g2=bwdist(OUTPUTgrid);
g2(g2<=threshold)=0; %Only keep values of g that are above the threshold
g2=logical(g2);
h2=bwdist(g2);
h2(h2==0)=.01; %Set interior to some arbitrary value so it is included in rump
h2(h2>=threshold)=0; %Only keep values of h that are below the threshold
h2=logical(h2); %h is rump (without additions from interface group)
theta2=comp_OUTPUTgrid-h2; %This is the list of stuff that could be thin
I2=zeros(size(theta2,1)+2,size(theta2,2)+2,size(theta2,3)+2);
R2=zeros(size(theta2,1)+2,size(theta2,2)+2,size(theta2,3)+2);
B2=zeros(size(theta2,1)+2,size(theta2,2)+2,size(theta2,3)+2);

%need to pad the arrays to make indexing easier
theta2_p= padarray(theta2,[1 1 1],0,'both');

% for i=2:size(theta2_p,1)
%     for j=2:size(theta2_p,2)
%         for k=2:size(theta2_p,3)
%             if theta2_p(i,j,k)~=0
%                 if OUTPUTgrid_p(i,j,k-1)~=0  || ...
%                         OUTPUTgrid_p(i,j,k+1)~=0 || ...
%                         OUTPUTgrid_p(i-1,j,k)~=0 ...
%                         ||OUTPUTgrid_p(i+1,j,k)~=0 ...
%                         ||OUTPUTgrid_p(i,j-1,k)~=0 ...
%                         ||OUTPUTgrid_p(i,j+1,k)~=0 
%                     I2(i,j,k)=1;
%                 end
%             end
%         end
%     end
% end


for i=2:size(theta2_p,1)
    for j=2:size(theta2_p,2)
        for k=2:size(theta2_p,3)
            if theta2_p(i,j,k)~=0
                if (comp_OUTPUTgrid_p(i,j,k-1)~=0 && theta2_p(i,j,k-1)==0) || ...
                        (comp_OUTPUTgrid_p(i,j,k+1)~=0 && theta2_p(i,j,k+1)==0) || ...
                        (comp_OUTPUTgrid_p(i-1,j,k)~=0 && theta2_p(i-1,j,k)==0)...
                        ||(comp_OUTPUTgrid_p(i+1,j,k)~=0 && theta2_p(i+1,j,k)==0)...
                        ||(comp_OUTPUTgrid_p(i,j-1,k)~=0 && theta2_p(i,j-1,k)==0)...
                        ||(comp_OUTPUTgrid_p(i,j+1,k)~=0 && theta2_p(i,j+1,k)==0)
                    I2(i,j,k)=1;
%                     if OUTPUTgrid_p(i,j,k-1)==0 &&...
%                         OUTPUTgrid_p(i,j,k+1)==0 &&...
%                         OUTPUTgrid_p(i-1,j,k)==0 &&...
%                         OUTPUTgrid_p(i+1,j,k)==0 &&...
%                         OUTPUTgrid_p(i,j+1,k)==0 &&...
%                         OUTPUTgrid_p(i,j-1,k)==0
%                     I2(i,j,k)=0;
%                     end
                elseif OUTPUTgrid_p(i,j,k-1)~=0 ||...
                        OUTPUTgrid_p(i,j,k+1)~=0 ||...
                        OUTPUTgrid_p(i-1,j,k)~=0 ||...
                        OUTPUTgrid_p(i+1,j,k)~=0 ||...
                        OUTPUTgrid_p(i,j+1,k)~=0 ||...
                        OUTPUTgrid_p(i,j-1,k)~=0
                    B2(i,j,k)=1;
                end
            end
        end
    end
end

%I think this will mark areas that are categorized as I that could be too
%small of holes as R

T2=theta2_p-I2-B2;  % Thin is just the remainder of theta that doesn't belong to I or B
for i=2:size(theta2_p,1)
    for j=2:size(theta2_p,2)
        for k=2:size(theta2_p,3)
            if I2(i,j,k)~=0
                if (B2(i,j,k-1)==0 && T2(i,j,k-1)==0 && I2(i,j,k-1)==0) && ...
                        (B2(i,j,k+1)==0 && T2(i,j,k+1)==0 && I2(i,j,k+1)==0) && ...
                        (B2(i-1,j,k)==0 && T2(i-1,j,k)==0 && I2(i-1,j,k)==0) && ...
                        (B2(i+1,j,k)==0 && T2(i+1,j,k)==0 && I2(i-1,j,k)==0) && ...
                        (B2(i,j-1,k)==0 && T2(i,j-1,k)==0 && I2(i,j-1,k)==0) &&  ...
                        (B2(i,j+1,k)==0 && T2(i,j+1,k)==0 && I2(i,j+1,k)==0)  
                    R2(i,j,k)=1;
                    I2(i,j,k)=0;
                end
            end
        end
    end
end
filledIn=I2+T2+B2;
filledIn(filledIn>0)=1;
axes(curAxes);
if max(max(max(filledIn)))~=0
    badVoxels(2)=PATCH_3Darray(filledIn(ceil(threshold)+2:size(filledIn,1)-ceil(threshold)-1,ceil(threshold)+2:size(filledIn,2)-ceil(threshold)-1,2+ceil(threshold):size(filledIn,3)-ceil(threshold)-1),gridX,gridY,gridZ,[0,0,1]);
    set(badVoxels(2), 'Visible','off');
else
    badVoxels(2)=patch('XData',[NaN;NaN;NaN],'YData',[NaN;NaN;NaN],'ZData',...
        [NaN;NaN;NaN],'EdgeColor', 'none','FaceColor',[0,0,1],'AmbientStrength', 0.15); %Plot blank patch for legend
    set(badVoxels(2), 'Visible','off')
end
axes(waitAx);

%Calculate COM for tippingcalc
C = round(centerOfMass(single(OUTPUTgrid)),0); %Find closest voxel bin
heightCOM=gridZ(C(3));

% 
% if max(max(max(I2)))~=0
%     badVoxels(4)=PATCH_3Darray(I2(ceil(threshold)+2:size(I2,1)-...
%         ceil(threshold)-1,ceil(threshold)+2:size(I2,2)-ceil(threshold)-1,...
%         2+ceil(threshold):size(I2,3)-ceil(threshold)-1),gridX,gridY,gridZ,...
%         [0,1,0]);
% end
% if max(max(max(T2)))~=0
%     badVoxels(5)=PATCH_3Darray(T2(ceil(threshold)+2:size(T2,1)-...
%         ceil(threshold)-1,ceil(threshold)+2:size(T2,2)-ceil(threshold)-1,...
%         2+ceil(threshold):size(T2,3)-ceil(threshold)-1),gridX,gridY,gridZ,...
%         [0,1,0]);
% end
% if max(max(max(B2)))~=0
%     badVoxels(6)=PATCH_3Darray(B2(ceil(threshold)+2:size(B2,1)-...
%         ceil(threshold)-1,ceil(threshold)+2:size(B2,2)-ceil(threshold)-1,...
%         2+ceil(threshold):size(B2,3)-ceil(threshold)-1),gridX,gridY,gridZ,...
%         [0,1,0]);
% end
% 
% %Only want one of these 3 calcs to appear in legend since they have the
% %same color
% if max(max(max(I2)))~=0
%     set(get(get(badVoxels(5),'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); %turn off display so only one ite
%     set(get(get(badVoxels(6),'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); %turn off display so only one ite
% elseif max(max(max(T2)))~=0
%     set(get(get(badVoxels(4),'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); %turn off display so only one ite
%     set(get(get(badVoxels(6),'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); %turn off display so only one ite
% elseif max(max(max(B2)))~=0
%     set(get(get(badVoxels(4),'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); %turn off display so only one ite
%     set(get(get(badVoxels(5),'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); %turn off display so only one ite
% end
    
%axis([0 305 0 305 0 305])
delete(currentWait)
end