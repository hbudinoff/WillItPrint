function [longArea_x,longArea_y,smallArea_x,smallArea_y,blobArea]=warping_tipping(hpat)
%Calculate area and distance of bottom layer

%Need to slice near bottom of STL in rotated position to figure out length
%and area touching the build plate

%Turn off poly warnings
warning('off','MATLAB:polyshape:repairedBySimplify')

longArea_x=struct;
longArea_y=struct;
smallArea_x=struct;
smallArea_y=struct;

%Make up the triangle matrix needed as input for slicer, at the currently
%plotted rotation
triangles=[hpat.XData(1,:)' hpat.YData(1,:)' hpat.ZData(1,:)'...
    hpat.XData(2,:)' hpat.YData(2,:)' hpat.ZData(2,:)'...
    hpat.XData(3,:)' hpat.YData(3,:)' hpat.ZData(3,:)'...
    hpat.FaceNormals(:,1) hpat.FaceNormals(:,2) hpat.FaceNormals(:,3)];

[movelist_all] = slice_stl_create_path_base(triangles,.1);
base_pixel_coords=movelist_all{2}; %This is a list of the coords of the exterior contour. May be split into sections by NaN
idx = all(isnan(base_pixel_coords),2);
idy = 1+cumsum(idx);
idz = 1:size(base_pixel_coords,1);
C = accumarray(idy(~idx),idz(~idx),[],@(r){base_pixel_coords(r,:)});

% Find area of supported facets
v=hpat.Vertices;
n=hpat.FaceNormals;
[~,totalArea,~,facet_area] = stlVolume(v',hpat.Faces');
%calculate avg height of facet 
%https://www.mathworks.com/matlabcentral/answers/80480-how-do-i-take-the-average-of-every-n-values-in-a-vector
%avg_facet_height=cell2mat(arrayfun(@(i) mean(v(i:i+2,:),1),1:3:length(v)-3+1,'UniformOutput', false)');
%avg_facet_height=
% Combine areas with same normal vector
%[n_new,~,ind] = unique(n, 'rows','stable');
suppArea=0;
for j=1:size(n,1)
    avg_facet_height=mean(v(hpat.Faces(j,:),3));
    vi=[0 0 1];
    u=n(j,:);
    a_b=atan2d(norm(cross3d(u,vi)),u*vi');
    if a_b>135 && avg_facet_height>0
        suppArea=suppArea+facet_area(j)*abs(cos(a_b*pi/180));
        %vol(i)=vol(i)+sum(facet_area(ind==j)*abs(cos(a_b*pi/180))*height_rotated(ind==j,3));
    end
end
%Multiply supporting area by support density
suppArea=suppArea*.15;
%Finding length - Adapted from ImageAnalyst 
% https://www.mathworks.com/matlabcentral/answers/233509-how-can-we-find-the-length-of-an-irregular-shape-in-matlab

%Add thickness check in future

numberOfBoundaries = size(C, 1);
for blobIndex = 1 : numberOfBoundaries
    thisBoundary = C{blobIndex};
        y = thisBoundary(:, 2); % y = columns.
        x = thisBoundary(:, 1); % x = rows.
        %bw = poly2mask(double(x),double(y),250,250); 
        % Find which two bounary points are farthest from each other.
        maxDistance = -inf;
        for k = 1 : length(x)
            distances = sqrt( (x(k) - x) .^ 2 + (y(k) - y) .^ 2 );
            [thisMaxDistance, indexOfMaxDistance] = max(distances);
            if thisMaxDistance > maxDistance
                maxDistance = thisMaxDistance;
                index1 = k;
                index2 = indexOfMaxDistance;
            end
        end
        
        %Highlight areas that are too small or too long
        hold on
        if maxDistance>80
            longArea_x(blobIndex).a=x;
            longArea_y(blobIndex).a=y;
            %plot(x,y,'r','LineWidth',3)
        else
            longArea_x(blobIndex).a=nan;
            longArea_y(blobIndex).a=nan;
        end
%         if exist(polyshape)==2 || exist(polyshape)==5
%             polyin = polyshape([x,y]);
%             blobArea(blobIndex)=area(polyin);
%         else
            blobArea(blobIndex)=polyarea(x,y);
%         end
            
        %This checks each blob independently to see if we should save for
        %plotting but should we save all and only plot if some isn't met???
        
        if blobArea(blobIndex)>0 %Save any areas for plotting (checking for whether or not to plot is in main code)
            smallArea_x(blobIndex).a=x;
            smallArea_y(blobIndex).a=y;
        else
            smallArea_x(blobIndex).a=nan;
            smallArea_y(blobIndex).a=nan;
        end
end
blobArea(blobIndex+1)=suppArea;    


