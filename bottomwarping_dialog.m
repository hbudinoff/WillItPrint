function varargout = bottomwarping_dialog(varargin)
% bottomwarping_dialog MATLAB code for bottomwarping_dialog.fig
%      bottomwarping_dialog, by itself, creates a new bottomwarping_dialog or raises the existing
%      singleton*.
%
%      H = bottomwarping_dialog returns the handle to a new bottomwarping_dialog or the handle to
%      the existing singleton*.
%
%      bottomwarping_dialog('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in bottomwarping_dialog.M with the given input arguments.
%
%      bottomwarping_dialog('Property','Value',...) creates a new bottomwarping_dialog or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before bottomwarping_dialog_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to bottomwarping_dialog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help bottomwarping_dialog

% Last Modified by GUIDE v2.5 04-Oct-2018 11:04:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bottomwarping_dialog_OpeningFcn, ...
                   'gui_OutputFcn',  @bottomwarping_dialog_OutputFcn, ...
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


% --- Executes just before bottomwarping_dialog is made visible.
function bottomwarping_dialog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bottomwarping_dialog (see VARARGIN)

% Choose default command line output for bottomwarping_dialog
handles.output = hObject;


% Determine the position of the dialog - centered on the callback figure
% if available, else, centered on the screen
FigPos=get(0,'DefaultFigurePosition');
OldUnits = get(hObject, 'Units');
set(hObject, 'Units', 'pixels');
OldPos = get(hObject,'Position');
FigWidth = OldPos(3);
FigHeight = OldPos(4);
if isempty(gcbf)
    ScreenUnits=get(0,'Units');
    set(0,'Units','pixels');
    ScreenSize=get(0,'ScreenSize');
    set(0,'Units',ScreenUnits);

    FigPos(1)=1/2*(ScreenSize(3)-FigWidth);
    FigPos(2)=2/3*(ScreenSize(4)-FigHeight);
else
    GCBFOldUnits = get(gcbf,'Units');
    set(gcbf,'Units','pixels');
    GCBFPos = get(gcbf,'Position');
    set(gcbf,'Units',GCBFOldUnits);
    FigPos(1:2) = [(GCBFPos(1) + GCBFPos(3) / 2) - FigWidth / 2, ...
                   (GCBFPos(2) + GCBFPos(4) / 2) - FigHeight / 2];
end
FigPos(3:4)=[FigWidth FigHeight];
set(hObject, 'Position', FigPos);
set(hObject, 'Units', OldUnits);

matlabImage = imread('fig_warping2.png');


Img=imshow(matlabImage, 'Parent', handles.axes1);
axis image

set(handles.axes1, ...
    'Visible', 'off', ...
    'YDir'   , 'reverse'       );

txtInfo = sprintf('-Long areas on build plate tend to curl or warp, peeling off of the build plate and potentially ruining your print. Reduce the length of the area touching the build plate by re-orienting the part or modifying the part geometry. If any dimension of the area is longer than 80 mm, consider shortening the geometry.\n-Rounding sharp corners of area on build plate can also help reduce warping.');
%set(handles.txtInfo, 'string', txtInfo,'max',2,'min',0,'value', []);
set(handles.edit1, 'string', txtInfo,'max',2,'min',0,'value', []);

%set(handles.txtInfo, 'value', []);

    %set(handles.edit2, 'string', txtInfo);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes bottomwarping_dialog wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = bottomwarping_dialog_OutputFcn(hObject, eventdata, handles) 
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
close(bottomwarping_dialog);


% --- Executes on selection change in txtInfo.
function txtInfo_Callback(hObject, eventdata, handles)
% hObject    handle to txtInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns txtInfo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from txtInfo


% --- Executes during object creation, after setting all properties.
function txtInfo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
