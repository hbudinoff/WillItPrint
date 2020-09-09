function varargout = overhang_dialog(varargin)
% overhang_dialog MATLAB code for overhang_dialog.fig
%      overhang_dialog, by itself, creates a new overhang_dialog or raises the existing
%      singleton*.
%
%      H = overhang_dialog returns the handle to a new overhang_dialog or the handle to
%      the existing singleton*.
%
%      overhang_dialog('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in overhang_dialog.M with the given input arguments.
%
%      overhang_dialog('Property','Value',...) creates a new overhang_dialog or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before overhang_dialog_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to overhang_dialog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help overhang_dialog

% Last Modified by GUIDE v2.5 04-Oct-2018 13:15:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @overhang_dialog_OpeningFcn, ...
                   'gui_OutputFcn',  @overhang_dialog_OutputFcn, ...
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


% --- Executes just before overhang_dialog is made visible.
function overhang_dialog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to overhang_dialog (see VARARGIN)

% Choose default command line output for overhang_dialog
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

matlabImage = imread('fig_overhang2.png');


Img=imshow(matlabImage, 'Parent', handles.axes1);
axis image

set(handles.axes1, ...
    'Visible', 'off', ...
    'YDir'   , 'reverse'       );

txtInfo = sprintf('Surfaces that are overhanging (i.e. are oriented downward) need to be supported with extra material, called support material, that will need to be removed after printing. The base of your part, contacting the build plate, will also be printed with support material attached if you choose the "Raft" setting when printing your part. Removing support material can be difficult or impossible, especially from small cavities and from small/thin features that might break during removal. Also, removing support material can damage the surface of the part. To avoid support material on a key feature, re-orient the part or change the angle of the feature. Upward facing surfaces or downward facing surfaces that are more than 45deg from horizontal do not need support.\n');
%set(handles.txtInfo, 'string', txtInfo,'max',2,'min',0,'value', []);
set(handles.edit1, 'string', txtInfo,'max',2,'min',0,'value', []);

%set(handles.txtInfo, 'value', []);

    %set(handles.edit2, 'string', txtInfo);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes overhang_dialog wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = overhang_dialog_OutputFcn(hObject, eventdata, handles) 
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
close(overhang_dialog);


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
