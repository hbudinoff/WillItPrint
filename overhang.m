%The original stl needs to be plotted so we can get the face normals
% ax = gca;               % get the current axis
% map=[0.8 0.8 1.0; 1 1 0]; %plot unsupported faces as grey, others as
% white
%We're gonna group all the patches on this face together so we can rotate
%as one
%t = hgtransform('Parent',ax);
% set(hpat,'Parent',t)
% % Center STL on build plate
% x_move=305/2-mean([max(max(hpat.XData)),min(min(hpat.XData))]);
% y_move=305/2-mean([max(max(hpat.YData)),min(min(hpat.YData))]);
% z_move=min(min(hpat.ZData));
% Txy = makehgtform('translate',[x_move y_move -z_move]);
% set(t,'Matrix',Txy)
normals=hpat(1).FaceNormals;

%vis is build direction-- always (0 0 1) if we rotate the normal vectors 
vi=[0 0 1];
overhang_col=zeros(size(normals,1),3);
for j=1:size(normals,1)
    u=normals(j,:);
    a_b=atan2d(norm(cross3d(u,vi)),u*vi');
    if a_b>135 
        overhang_col(j,:)=[1 1 0];
    else
        overhang_col(j,:)=[0.8 0.8 1.0];
    end
end
% %figure(2)
% set(hpat,'visible','off');
hpat(1).FaceColor = 'Flat' ;
hpat(1).FaceVertexCData = overhang_col ;


% % Center STL on build plate
% x_move=305/2-mean([max(max(hpat.XData)),min(min(hpat.XData))]);
% y_move=305/2-mean([max(max(hpat.YData)),min(min(hpat.YData))]);
% z_move=min(min(hpat.ZData));
% [hpat]=patch(hpat.XData+x_move,hpat.YData+y_move,hpat.ZData-z_move,overhang_col, ...
%     'EdgeColor',       'none',        ...
%     'AmbientStrength', 0.15);
% set(hpat,'visible','on');
% material('dull');
% axis('image');
% axis equal
% set(gca,'XTick',[])
% set(gca,'YTick',[])
% set(gca,'ZTick',[])
% colormap(map)
% camlight headlight
% xlabel('x [mm]');ylabel('y [mm]');zlabel('z [mm]');
% set(hpat,'EdgeAlpha',0);

%view(0,75)
%lightangle(-45,30)
% Rotate image
% direction_y = [0 1 0];
% direction_x = [1 0 0];
% direction_z = [0 0 1];
% rotate(hpat,direction_x,25);
% set(hpat,'ZData',hpat.ZData-min(min(hpat.ZData)))
% set(hpat_I,'ZData',hpat_I.ZData-min(min(hpat_I.ZData)))
%Face normals get updated by rotate command so just need to re-run to
%calculate angles


% % To calculate area on bottom z level to see if in danger for warping
% [OUTPUTgrid2]=VOXELISE(grid_size_x,grid_size_y,grid_size_z,hpat.XData,hpat.YData,hpat.ZData,'xyz');
% %OUTPUTgrid2= padarray(OUTPUTgrid2,[ceil(threshold) ceil(threshold) ceil(threshold)],0,'both');
% i=1;
% 
% %Do I need to do this if it's rotated and adjusted to the bottom every
% %time?
% while max(max(max(OUTPUTgrid2(:,:,i))))==0
%     i=i+1;
% end
% save2=OUTPUTgrid2(:,:,i); 
% group_areas=regionprops(save2,'Area');
% count=1;
% 
% %But warping doesn't depend on area, depends on length...but having enough
% %surface area to anchor it does seem like a good idea
% for j=1:size(group_areas,1)
%     if group_areas(j).Area>2500
%         warping(count)=j;
%     end
%     count=count+1;
% end
% 
% %Can't I just throw a warning and highlight the bottom pixels if any part
% %is too long or not enough area? (also can use imshow to show area)
% group_pixels = regionprops(save2,'PixelList');
% figure(2);
% warping_grid=zeros(grid_size_x,grid_size_y,grid_size_z);
% warping_pixels=group_pixels(warping).PixelList;
% warping_pixels_coords=[warping_pixels i*ones(size(warping_pixels,1),1)];
% warping_grid(warping_pixels_coords(:,1),warping_pixels_coords(:,2),warping_pixels_coords(:,3))=1;
% PATCH_3Darray(warping_grid,gridX,gridY,gridZ,[0.6,0.3,0.1])
% 
% 
% 
%Subfunction for suposedly faster cross product calculation
function C = cross3d(A, B)
C = [A(2)*B(3) - A(3)*B(2), ...
     A(3)*B(1) - A(1)*B(3), ...
     A(1)*B(2) - A(2)*B(1)];
end