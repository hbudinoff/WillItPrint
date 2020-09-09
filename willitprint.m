function varargout = willitprint(varargin)
% WILLITPRINT MATLAB code for willitprint.fig
%      WILLITPRINT, by itself, creates a new WILLITPRINT or raises the existing
%      singleton*.
%
%      H = WILLITPRINT returns the handle to a new WILLITPRINT or the handle to
%      the existing singleton*.
%
%      WILLITPRINT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WILLITPRINT.M with the given input arguments.
%
%      WILLITPRINT('Property','Value',...) creates a new WILLITPRINT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before willitprint_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to willitprint_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help willitprint

% Last Modified by GUIDE v2.5 03-Oct-2018 09:12:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @willitprint_OpeningFcn, ...
                   'gui_OutputFcn',  @willitprint_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before willitprint is made visible.
function willitprint_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to willitprint (see VARARGIN)

%Save some global variables
handles.direction_x = [0 1 0];
handles.direction_y = [1 0 0];
handles.direction_z = [0 0 1];

%Plot blank area where stl will be plotted
axis('image');
cla
axis([0 305 0 305 0 305])
%h = light;
%h.Position=[0 300 -300];
% camlight('headlight');
% material('dull');

box on
xlabel('x [mm]');ylabel('y [mm]');zlabel('z [mm]');
handles.axes1=gca;

% Disable buttons initially
set(handles.radiobutton1,'Enable','off') 
set(handles.radiobutton2,'Enable','off')  
set(handles.radiobutton3,'Enable','off')  
set(handles.radiobutton4,'Enable','off')  
set(handles.radiobutton5,'Enable','off') 
set(handles.radiobutton6,'Enable','off') 
set(handles.pushbutton2,'Enable','off') 
set(handles.pushbutton3,'Enable','off')
set(handles.pushbutton4,'Enable','off')
set(handles.pushbutton5,'Enable','off')
set(handles.pushbutton7,'Enable','off')
set(handles.pushbutton8,'Enable','off')
set(handles.pushbutton9,'Enable','off')
set(handles.pushbutton10,'Enable','off')
set(handles.pushbutton11,'Enable','off')
set(handles.edit2,'Enable','off')
set(handles.edit3,'Enable','off')
set(handles.edit4,'Enable','off')


% Choose default command line output for willitprint
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes willitprint wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = willitprint_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



%Stuff for uploading STL
%filesep
currentFolder = strcat(pwd,filesep);
[handles.stlFileName,path] = uigetfile('*.stl',currentFolder);
if handles.stlFileName==0
  % user pressed cancel
  return
elseif exist(handles.stlFileName,'file')==0  %strcmp(currentFolder,path)~=1
    %message=strcat('Please move your .stl file to the current folder, ',currentFolder);
    f = msgbox(strcat('Please move your .stl file to the current folder,',...
        currentFolder), 'Error','error');
else
    %Reset if re-uploading
    if isfield(handles,'badVoxels') || isfield(handles,'partFaces')%some stuff has been calculated before
        cla
        fields={'badVoxels','partFaces','longAreas','wiggleAreas'};
        fieldsExist=isfield(handles,fields);
        for i=1:size(fields,2)
            if fieldsExist(i)>0
                handles=rmfield(handles,fields(i));
            end
        end
        legend('off')
        set(handles.radiobutton1, 'Value', 1);
        set(handles.radiobutton1,'Enable','off') 
        set(handles.radiobutton2,'Enable','off')  
        set(handles.radiobutton3,'Enable','off')  
        set(handles.radiobutton4,'Enable','off')  
        set(handles.radiobutton5,'Enable','off') 
        set(handles.radiobutton6,'Enable','off') 
        set(handles.pushbutton2,'Enable','off') 
        set(handles.pushbutton3,'Enable','off')
        set(handles.pushbutton4,'Enable','off')
        set(handles.pushbutton5,'Enable','off')
        set(handles.pushbutton7,'Enable','off')
        set(handles.pushbutton8,'Enable','off')
        set(handles.pushbutton9,'Enable','off')
        set(handles.pushbutton10,'Enable','off')
        set(handles.pushbutton11,'Enable','off')
        set(handles.edit2,'Enable','off')
        set(handles.edit3,'Enable','off')
        set(handles.edit4,'Enable','off')
        %Turn on calc button if someone reuploads
        set(handles.pushbutton6,'Enable','on') 
        set(handles.pushbutton6,'String','Analyze printing errors') 
    end
    %Now plot new stuff
    [stlcoords,handles.stlnormals] = READ_stl(handles.stlFileName);
    xco = squeeze( stlcoords(:,1,:) )';
    yco = squeeze( stlcoords(:,2,:) )';
    zco = squeeze( stlcoords(:,3,:) )';
    
    % Center STL on build plate
    x_move=305/2-mean([max(max(xco)),min(min(xco))]);
    y_move=305/2-mean([max(max(yco)),min(min(yco))]);
    z_move=min(min(zco));
    handles.xco=xco+x_move;
    handles.yco=yco+y_move;
    handles.zco=zco-z_move;
    handles.x_move=x_move;
    handles.y_move=y_move;
    handles.z_move=z_move;
    
    % Save stuff in case user wants to plot at original orientation
    handles.xco_orig=handles.xco;
    handles.yco_orig=handles.yco;
    handles.zco_orig=handles.zco;
    handles.stlnormals_orig=handles.stlnormals;
    
    % Plot stl at center of build plate
    handles.partFaces = patch('XData',handles.xco,'YData',handles.yco,'ZData',...
        handles.zco,'FaceColor',[0.8 0.8 1.0],'EdgeColor', 'none',...
        'AmbientStrength', 0.15,'FaceNormals',handles.stlnormals,...
        'FaceLighting',    'gouraud');
    material('dull');
    camlight('headlight')
    axis('image');
    axis([0 305 0 305 0 305])
    box on
    %camlight headlight
    xlabel('x [mm]');ylabel('y [mm]');zlabel('z [mm]');
end
guidata(hObject,handles)


% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Need to clear everything so we have a clean slate no matter what was
%plotted before

%Clear overhang stuff
overhang_col(:,:)=[0.8 0.8 1.0];
handles.partFaces.FaceVertexCData=overhang_col;
handles.partFaces.FaceColor = 'Flat' ;
%Clear small feature stuff
if strcmp('on',handles.badVoxels(1).Visible)
    set(handles.badVoxels,'visible','off');
end
%Clear tipping stuff
if isfield(handles,'wiggleAreas') 
    if strcmp('on',handles.wiggleAreas(1).Visible)
        set(handles.wiggleAreas,'visible','off');
    end
end
%Clear warping stuff
if isfield(handles,'longAreas')
    if strcmp('on',handles.longAreas(1).Visible)
        set(handles.longAreas,'visible','off');
    end
end
legend(handles.axes1,'off')
guidata(hObject,handles)


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
% This is just a place holder


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2

% Check if small feature calculation is requested (Calculated by pushing
% 'analyze'
smallOn=get(hObject,'Value'); 
if smallOn==1 %Display voxels if radio button is on
    set(handles.badVoxels,'visible','on');
    legend([handles.partFaces,handles.badVoxels(1),handles.badVoxels(2)],{'Normal','Erroded','Filled in'})
end

guidata(hObject,handles)


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3
%handles.onOverhangs=get(hObject,'Value');
normals=handles.partFaces.FaceNormals;
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
handles.partFaces.FaceColor = 'Flat' ;
handles.partFaces.FaceVertexCData = overhang_col ;
handles.blankPatch(1)=patch('XData',[NaN;NaN;NaN],'YData',[NaN;NaN;NaN],'ZData',...
    [NaN;NaN;NaN],'FaceColor',[1 1 0],'EdgeColor', 'none',...
    'AmbientStrength', 0.15); %Plot blank patch for legend
handles.blankPatch(2)=patch('XData',[NaN;NaN;NaN],'YData',[NaN;NaN;NaN],'ZData',...
    [NaN;NaN;NaN],'FaceColor',[0.8 0.8 1.0],'EdgeColor', 'none',...
    'AmbientStrength', 0.15); %Plot blank patch for legend
legend([handles.blankPatch(2),handles.blankPatch(1)],{'No support needed','Support needed'})

guidata(hObject,handles)


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4

[~,~,smallArea_x,smallArea_y,blobArea]=warping_tipping(handles.partFaces);
height=handles.heightCOM;

%Need to add supported area to claculation for tipping

if sum(blobArea)/height<1
    hold on
    for i=1:size(smallArea_x,2)
        handles.wiggleAreas(i)=plot(smallArea_x(i).a,smallArea_y(i).a,'Color',[1 0 1],'LineWidth',3);
        handles.blankPatch(1)=patch('XData',[NaN;NaN;NaN],'YData',[NaN;NaN;NaN],'ZData',...
        [NaN;NaN;NaN],'FaceColor',[1 0 1],'EdgeColor', 'none',...
        'AmbientStrength', 0.15); %Plot blank patch for legend
        legend(handles.blankPatch(1),'At risk of wobbling')
    end
else 
    handles.wiggleAreas(1)=patch('XData',[NaN;NaN;NaN],'YData',[NaN;NaN;NaN],'ZData',...
    [NaN;NaN;NaN],'FaceColor',[0.8 0.8 1.0],'EdgeColor', 'none',...
    'AmbientStrength', 0.15); %Plot blank patch for legend
    legend(handles.wiggleAreas(1),'Not high risk for wobbling')
end

guidata(hObject,handles)


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5
[longArea_x,longArea_y,~,~,~]=warping_tipping(handles.partFaces);

if sum(vertcat(longArea_x(:).a),'omitnan')>0
    hold on
    for i=1:size(longArea_x,2)
        handles.longAreas(i)=plot(longArea_x(i).a,longArea_y(i).a,'Color',[0 1 1],'LineWidth',3);
        handles.blankPatch(1)=patch('XData',[NaN;NaN;NaN],'YData',[NaN;NaN;NaN],'ZData',...
        [NaN;NaN;NaN],'FaceColor',[0 1 1],'EdgeColor', 'none',...
        'AmbientStrength', 0.15); %Plot blank patch for legend
        legend(handles.blankPatch(1),'At risk of warping')
    end
else 
    handles.longAreas(1)=patch('XData',[NaN;NaN;NaN],'YData',[NaN;NaN;NaN],'ZData',...
    [NaN;NaN;NaN],'FaceColor',[0.8 0.8 1.0],'EdgeColor', 'none',...
    'AmbientStrength', 0.15); %Plot blank patch for legend
    legend(handles.longAreas(1),'Not high risk for warping')
end

guidata(hObject,handles)

% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6
normals=handles.partFaces.FaceNormals;
%vis is build direction-- always (0 0 1) if we rotate the normal vectors 
vi=[0 0 1];
rough_col=zeros(size(normals,1),3);
for j=1:size(normals,1)
    u=normals(j,:);
    a_b=atan2d(norm(cross3d(u,vi)),u*vi');
    if and(a_b>135,a_b<178) || and(a_b<45,a_b>2)
        rough_col(j,:)=[.5 0 1];
    else
        rough_col(j,:)=[0.8 0.8 1.0];
    end
end
handles.partFaces.FaceColor = 'Flat' ;
handles.partFaces.FaceVertexCData = rough_col ;
handles.blankPatch(1)=patch('XData',[NaN;NaN;NaN],'YData',[NaN;NaN;NaN],'ZData',...
    [NaN;NaN;NaN],'FaceColor',[.5 0 1],'EdgeColor', 'none',...
    'AmbientStrength', 0.15); %Plot blank patch for legend
handles.blankPatch(2)=patch('XData',[NaN;NaN;NaN],'YData',[NaN;NaN;NaN],'ZData',...
    [NaN;NaN;NaN],'FaceColor',[0.8 0.8 1.0],'EdgeColor', 'none',...
    'AmbientStrength', 0.15); %Plot blank patch for legend
legend([handles.blankPatch(2),handles.blankPatch(1)],{'Relatively smoooth','Rough'})

guidata(hObject,handles)


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
handles.xRot=str2double(get(hObject,'String'));
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
handles.yRot=str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
handles.zRot=str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit2, 'String', ''); %Clear contents of rotation  textbox
set(handles.partFaces, 'Visible','off');

%Rotate coords and normal vectors
[newVerts_x,newVerts_y,newVerts_z]=coordRotate(handles.partFaces.XData,handles.partFaces.YData,...
    handles.partFaces.ZData,'x',handles.xRot);
normals=handles.partFaces.FaceNormals';
[newNorm_x,newNorm_y,newNorm_z]=coordRotate(normals(1,:),normals(2,:),...
    normals(3,:),'x',handles.xRot);

%Adjust data to plot in middle and save new plot
x_move=305/2-mean([max(max(newVerts_x)),min(min(newVerts_x))]);
y_move=305/2-mean([max(max(newVerts_y)),min(min(newVerts_y))]);
z_move=min(min(newVerts_z));
handles.xco=newVerts_x+x_move;
handles.yco=newVerts_y+y_move;
handles.zco=newVerts_z-z_move;
handles.partFaces=patch('XData',handles.xco,'YData',handles.yco,'ZData',...
    handles.zco,'FaceColor',[0.8 0.8 1.0],'EdgeColor', 'none',...
    'AmbientStrength', 0.15,'FaceNormals',[newNorm_x;newNorm_y;newNorm_z]',...
    'FaceLighting',    'gouraud');
    material('dull');
    %camlight('headlight')

%Update info before doing other callbacks
guidata(hObject,handles);

%Rotate bad voxels in case their later needed to be displayed at this
%orientation
    set(handles.badVoxels, 'Visible','off');
    legend('off')
    %Rotate sets of badVoxels
    [newBadV_x,newBadV_y,newBadV_z]=coordRotate(handles.badVoxels(1).XData,handles.badVoxels(1).YData,...
    handles.badVoxels(1).ZData,'x',handles.xRot);
    newBadV_x=newBadV_x+x_move;
    newBadV_y=newBadV_y+y_move;
    newBadV_z=newBadV_z-z_move;
    handles.badVoxels(1)=patch('XData',newBadV_x,'YData',newBadV_y,'ZData',...
        newBadV_z,'FaceColor',[0 1 0],'EdgeColor', [0 0.5 0]);
    [newBadV_x,newBadV_y,newBadV_z]=coordRotate(handles.badVoxels(2).XData,handles.badVoxels(2).YData,...
    handles.badVoxels(2).ZData,'x',handles.xRot);
    newBadV_x=newBadV_x+x_move;
    newBadV_y=newBadV_y+y_move;
    newBadV_z=newBadV_z-z_move;
    handles.badVoxels(2)=patch('XData',newBadV_x,'YData',newBadV_y,'ZData',...
        newBadV_z,'FaceColor',[0 0 1],'EdgeColor', [0 0.5 0]);
    set(handles.badVoxels, 'Visible','off');
    
%Check to see if small feature is activated    
if handles.radiobutton2.Value==1
    set(handles.badVoxels, 'Visible','on');
    legend([handles.partFaces,handles.badVoxels(1),handles.badVoxels(2)],{'Normal','Erroded','Filled in'}) 
end

%Check to see if overhang is on
if handles.radiobutton3.Value==1
    radiobutton3_Callback(handles.radiobutton3, eventdata, handles)
end

%Check to see if tipping is on
if handles.radiobutton4.Value==1
    for i=1:size(handles.wiggleAreas)
        set(handles.wiggleAreas(i), 'Visible','off')
    end
    radiobutton4_Callback(handles.radiobutton4, eventdata, handles)
end

%Check to see if bottom warping is on
if handles.radiobutton5.Value==1
    for i=1:size(handles.longAreas)
        set(handles.longAreas(i), 'Visible','off')
    end
    radiobutton5_Callback(handles.radiobutton5, eventdata, handles)
end

%Check to see if surface roughness is on
if handles.radiobutton6.Value==1
    radiobutton6_Callback(handles.radiobutton6, eventdata, handles)
end

%Clear rotation amount
handles.xRot=0;
guidata(hObject,handles);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit3, 'String', ''); %Clear contents of rotation  textbox
set(handles.partFaces, 'Visible','off');

%Rotate coords and normal vectors
[newVerts_x,newVerts_y,newVerts_z]=coordRotate(handles.partFaces.XData,handles.partFaces.YData,...
    handles.partFaces.ZData,'y',handles.yRot);
normals=handles.partFaces.FaceNormals';
[newNorm_x,newNorm_y,newNorm_z]=coordRotate(normals(1,:),normals(2,:),...
    normals(3,:),'y',handles.yRot);

%Adjust data to plot in middle and save new plot
x_move=305/2-mean([max(max(newVerts_x)),min(min(newVerts_x))]);
y_move=305/2-mean([max(max(newVerts_y)),min(min(newVerts_y))]);
z_move=min(min(newVerts_z));
handles.xco=newVerts_x+x_move;
handles.yco=newVerts_y+y_move;
handles.zco=newVerts_z-z_move;
handles.partFaces=patch('XData',handles.xco,'YData',handles.yco,'ZData',...
    handles.zco,'FaceColor',[0.8 0.8 1.0],'EdgeColor', 'none',...
    'AmbientStrength', 0.15,'FaceNormals',[newNorm_x;newNorm_y;newNorm_z]',...
    'FaceLighting',    'gouraud');
    material('dull');
    %camlight('headlight')

%Update info before doing other callbacks
guidata(hObject,handles);

%Rotate sets of badVoxels
set(handles.badVoxels, 'Visible','off');
legend('off')
[newBadV_x,newBadV_y,newBadV_z]=coordRotate(handles.badVoxels(1).XData,handles.badVoxels(1).YData,...
handles.badVoxels(1).ZData,'y',handles.yRot);
newBadV_x=newBadV_x+x_move;
newBadV_y=newBadV_y+y_move;
newBadV_z=newBadV_z-z_move;
handles.badVoxels(1)=patch('XData',newBadV_x,'YData',newBadV_y,'ZData',...
    newBadV_z,'FaceColor',[0 1 0],'EdgeColor', [0 0.5 0]);
[newBadV_x,newBadV_y,newBadV_z]=coordRotate(handles.badVoxels(2).XData,handles.badVoxels(2).YData,...
handles.badVoxels(2).ZData,'y',handles.yRot);
newBadV_x=newBadV_x+x_move;
newBadV_y=newBadV_y+y_move;
newBadV_z=newBadV_z-z_move;
handles.badVoxels(2)=patch('XData',newBadV_x,'YData',newBadV_y,'ZData',...
    newBadV_z,'FaceColor',[0 0 1],'EdgeColor', [0 0 .5]);
set(handles.badVoxels, 'Visible','off');

    
%Check to see if small feature is activated    
if handles.radiobutton2.Value==1
    set(handles.badVoxels, 'Visible','on');
    legend([handles.partFaces,handles.badVoxels(1),handles.badVoxels(2)],{'Normal','Erroded','Filled in'}) 
end

%Check to see if overhang is on
if handles.radiobutton3.Value==1
    radiobutton3_Callback(handles.radiobutton3, eventdata, handles)
end

%Check to see if tipping is on
if handles.radiobutton4.Value==1
    for i=1:size(handles.wiggleAreas)
        set(handles.wiggleAreas(i), 'Visible','off')
    end
    radiobutton4_Callback(handles.radiobutton4, eventdata, handles)
end

%Check to see if bottom warping is on
if handles.radiobutton5.Value==1
    for i=1:size(handles.longAreas)
        set(handles.longAreas(i), 'Visible','off')
    end
    radiobutton5_Callback(handles.radiobutton5, eventdata, handles)
end

%Check to see if surface roughness is on
if handles.radiobutton6.Value==1
    radiobutton6_Callback(handles.radiobutton6, eventdata, handles)
end

%Clear rotation amount
handles.yRot=0;
guidata(hObject,handles);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit4, 'String', ''); %Clear contents of rotation  textbox
set(handles.partFaces, 'Visible','off');

%Rotate coords and normal vectors
[newVerts_x,newVerts_y,newVerts_z]=coordRotate(handles.partFaces.XData,handles.partFaces.YData,...
    handles.partFaces.ZData,'z',handles.zRot);
normals=handles.partFaces.FaceNormals';
[newNorm_x,newNorm_y,newNorm_z]=coordRotate(normals(1,:),normals(2,:),...
    normals(3,:),'z',handles.zRot);

%Adjust data to plot in middle and save new plot
x_move=305/2-mean([max(max(newVerts_x)),min(min(newVerts_x))]);
y_move=305/2-mean([max(max(newVerts_y)),min(min(newVerts_y))]);
z_move=min(min(newVerts_z));
handles.xco=newVerts_x+x_move;
handles.yco=newVerts_y+y_move;
handles.zco=newVerts_z-z_move;
handles.partFaces=patch('XData',handles.xco,'YData',handles.yco,'ZData',...
    handles.zco,'FaceColor',[0.8 0.8 1.0],'EdgeColor', 'none',...
    'AmbientStrength', 0.15,'FaceNormals',[newNorm_x;newNorm_y;newNorm_z]',...
    'FaceLighting',    'gouraud');
    material('dull');
    %camlight('headlight');

%Update info before doing other callbacks
guidata(hObject,handles);

%Rotate sets of badVoxels
set(handles.badVoxels, 'Visible','off');
legend('off')
[newBadV_x,newBadV_y,newBadV_z]=coordRotate(handles.badVoxels(1).XData,handles.badVoxels(1).YData,...
handles.badVoxels(1).ZData,'z',handles.zRot);
newBadV_x=newBadV_x+x_move;
newBadV_y=newBadV_y+y_move;
newBadV_z=newBadV_z-z_move;
handles.badVoxels(1)=patch('XData',newBadV_x,'YData',newBadV_y,'ZData',...
    newBadV_z,'FaceColor',[0 1 0],'EdgeColor', [0 0.5 0]);
[newBadV_x,newBadV_y,newBadV_z]=coordRotate(handles.badVoxels(2).XData,handles.badVoxels(2).YData,...
handles.badVoxels(2).ZData,'z',handles.zRot);
newBadV_x=newBadV_x+x_move;
newBadV_y=newBadV_y+y_move;
newBadV_z=newBadV_z-z_move;
handles.badVoxels(2)=patch('XData',newBadV_x,'YData',newBadV_y,'ZData',...
    newBadV_z,'FaceColor',[0 0 1],'EdgeColor', [0 0 0.5]);
set(handles.badVoxels, 'Visible','off');
    
%Check to see if small feature is activated    
if handles.radiobutton2.Value==1
    set(handles.badVoxels, 'Visible','on');
    legend([handles.partFaces,handles.badVoxels(1),handles.badVoxels(2)],{'Normal','Erroded','Filled in'}) 
end

%Check to see if overhang is on
if handles.radiobutton3.Value==1
    radiobutton3_Callback(handles.radiobutton3, eventdata, handles)
end

%Check to see if tipping is on
if handles.radiobutton4.Value==1
    for i=1:size(handles.wiggleAreas)
        set(handles.wiggleAreas(i), 'Visible','off')
    end
    radiobutton4_Callback(handles.radiobutton4, eventdata, handles)
end

%Check to see if bottom warping is on
if handles.radiobutton5.Value==1
    for i=1:size(handles.longAreas)
        set(handles.longAreas(i), 'Visible','off')
    end
    radiobutton5_Callback(handles.radiobutton5, eventdata, handles)
end

%Check to see if surface roughness is on
if handles.radiobutton6.Value==1
    radiobutton6_Callback(handles.radiobutton6, eventdata, handles)
end

%Clear rotation amount
handles.zRot=0;
guidata(hObject,handles);

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
legend('off')
set(handles.partFaces, 'Visible','off');
%Reset plotting to original
handles.partFaces = patch('XData',handles.xco_orig,'YData',handles.yco_orig,'ZData',...
    handles.zco_orig,'FaceColor',[0.8 0.8 1.0],'EdgeColor', 'none',...
    'AmbientStrength', 0.15,'FaceNormals',handles.stlnormals_orig,...
    'FaceLighting',    'gouraud');
    material('dull');
    %camlight('headlight')
set(handles.badVoxels, 'Visible','off');
handles.badVoxels=handles.badVoxels_orig;
set(handles.badVoxels, 'Visible','off');

    
%Check to see if small feature is activated    
if handles.radiobutton2.Value==1
    set(handles.badVoxels, 'Visible','on');
    legend([handles.partFaces,handles.badVoxels(1),handles.badVoxels(2)],{'Normal','Erroded','Filled in'}) 
end

%Check to see if overhang is on
if handles.radiobutton3.Value==1
    radiobutton3_Callback(handles.radiobutton3, eventdata, handles)
end

%Check to see if tipping is on
if handles.radiobutton4.Value==1
    for i=1:size(handles.wiggleAreas)
        set(handles.wiggleAreas(i), 'Visible','off')
    end
    radiobutton4_Callback(handles.radiobutton4, eventdata, handles)
end

%Check to see if warping is on
if handles.radiobutton5.Value==1
    for i=1:size(handles.longAreas)
        set(handles.longAreas(i), 'Visible','off')
    end
    radiobutton5_Callback(handles.radiobutton5, eventdata, handles)
end

%Check to see if surface roughness is on
if handles.radiobutton6.Value==1
    radiobutton6_Callback(handles.radiobutton6, eventdata, handles)
end

guidata(hObject,handles);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Calculate functions that don't depend on orientation
[badVoxels,heightCOM]=small_feature_checker(handles.xco,handles.yco,handles.zco,...
        handles.stlFileName,handles.x_move,handles.y_move,handles.z_move,handles.axes1);
handles.badVoxels=badVoxels;
handles.heightCOM=heightCOM;
handles.badVoxels_orig=badVoxels;
set(handles.badVoxels, 'Visible','off');

%Turn off calc button until someone reuploads
set(handles.pushbutton6,'Enable','off') 
set(handles.pushbutton6,'String','Errors calculated') 
user_response = intro_errors;
%Enable radiobuttons
set(handles.radiobutton1,'Enable','on') 
set(handles.radiobutton2,'Enable','on')  
set(handles.radiobutton3,'Enable','on')  
set(handles.radiobutton4,'Enable','on')  
set(handles.radiobutton5,'Enable','on')  
set(handles.radiobutton6,'Enable','on')
set(handles.pushbutton2,'Enable','on')
set(handles.pushbutton3,'Enable','on')
set(handles.pushbutton4,'Enable','on')
set(handles.pushbutton5,'Enable','on')
set(handles.pushbutton7,'Enable','on')
set(handles.pushbutton8,'Enable','on')
set(handles.pushbutton9,'Enable','on')
set(handles.pushbutton10,'Enable','on')
set(handles.pushbutton11,'Enable','on')
set(handles.edit2,'Enable','on')
set(handles.edit3,'Enable','on')
set(handles.edit4,'Enable','on')
guidata(hObject,handles)

     


% --------------------------------------------------------------------
function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This is a zoom button on top toolbar
axis('image');
axis([0 305 0 305 0 305])


% --------------------------------------------------------------------
function uipushtool2_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This is a zoom button on top toolbar
axis tight


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

user_response = smallfeats_dialog;


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
user_response = overhang_dialog;

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
user_response = tipping_dialog;

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
user_response = bottomwarping_dialog;

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
user_response = surfacefinish_dialog;
