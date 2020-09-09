function varargout = smallfeats_dialog(varargin)
% SMALLFEATS_dialog MATLAB code for smallfeats_dialog.fig
%      SMALLFEATS_dialog, by itself, creates a new SMALLFEATS_dialog or raises the existing
%      singleton*.
%
%      H = SMALLFEATS_dialog returns the handle to a new SMALLFEATS_dialog or the handle to
%      the existing singleton*.
%
%      SMALLFEATS_dialog('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SMALLFEATS_dialog.M with the given input arguments.
%
%      SMALLFEATS_dialog('Property','Value',...) creates a new SMALLFEATS_dialog or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before smallfeats_dialog_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to smallfeats_dialog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help smallfeats_dialog

% Last Modified by GUIDE v2.5 04-Oct-2018 09:21:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @smallfeats_dialog_OpeningFcn, ...
                   'gui_OutputFcn',  @smallfeats_dialog_OutputFcn, ...
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


% --- Executes just before smallfeats_dialog is made visible.
function smallfeats_dialog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to smallfeats_dialog (see VARARGIN)

% Choose default command line output for smallfeats_dialog
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

matlabImage = imread('fig_smallfeat2.png');


Img=imshow(matlabImage, 'Parent', handles.axes1);
axis image

set(handles.axes1, ...
    'Visible', 'off', ...
    'YDir'   , 'reverse'       );

txtInfo = sprintf('Small features, including holes, may fail to print if they are smaller than 2 mm. Features dimensions should be equal to or larger than 2 mm in all directions to ensure they will print successfully and will not break. Also note that all sharp corners in your geometry may print slightly rounded. You can avoid this by avoiding sharp corners. This tool uses the same color to mark both sharp corners that will be rounded and small features that will not print. "Erroded" marks features that are too small to print successfully and exterior edges that will be rounded. "Filled in" marks hole features that will be filled in and interior edges that will be rounded.\n');
%set(handles.txtInfo, 'string', txtInfo,'max',2,'min',0,'value', []);
set(handles.edit1, 'string', txtInfo,'max',2,'min',0,'value', []);

%set(handles.txtInfo, 'value', []);

    %set(handles.edit2, 'string', txtInfo);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes smallfeats_dialog wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = smallfeats_dialog_OutputFcn(hObject, eventdata, handles) 
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
close(smallfeats_dialog);


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
