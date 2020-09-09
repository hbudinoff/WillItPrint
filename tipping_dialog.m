function varargout = tipping_dialog(varargin)
% tipping_dialog MATLAB code for tipping_dialog.fig
%      tipping_dialog, by itself, creates a new tipping_dialog or raises the existing
%      singleton*.
%
%      H = tipping_dialog returns the handle to a new tipping_dialog or the handle to
%      the existing singleton*.
%
%      tipping_dialog('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in tipping_dialog.M with the given input arguments.
%
%      tipping_dialog('Property','Value',...) creates a new tipping_dialog or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tipping_dialog_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tipping_dialog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tipping_dialog

% Last Modified by GUIDE v2.5 04-Oct-2018 13:54:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tipping_dialog_OpeningFcn, ...
                   'gui_OutputFcn',  @tipping_dialog_OutputFcn, ...
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


% --- Executes just before tipping_dialog is made visible.
function tipping_dialog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tipping_dialog (see VARARGIN)

% Choose default command line output for tipping_dialog
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

matlabImage = imread('fig_tipping2.png');


Img=imshow(matlabImage, 'Parent', handles.axes1);
axis image

set(handles.axes1, ...
    'Visible', 'off', ...
    'YDir'   , 'reverse'       );

txtInfo = sprintf('If there is only a small area on the build plate, parts can suffer from vibration issues, especially if they are tall. Printer movement can cause the part to wobble, possibly becoming detached from the build plate. If support material is present, it increases the area of material touching the build plate and helps stabilize the part. Check out the "Overhangs" section to see if your part will have support material in your chosen orientation. If the sum of the support material and part area touching the build plate is small, it is best to re-orient the part or change the geometry in order to minimize part height and to ensure the area on the build plate is large enough to provide a stable base.');
%set(handles.txtInfo, 'string', txtInfo,'max',2,'min',0,'value', []);
set(handles.edit1, 'string', txtInfo,'max',2,'min',0,'value', []);

%set(handles.txtInfo, 'value', []);

    %set(handles.edit2, 'string', txtInfo);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tipping_dialog wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = tipping_dialog_OutputFcn(hObject, eventdata, handles) 
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
close(tipping_dialog);


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
