function varargout = RRT_gui(varargin)
% RRT_GUI M-file for RRT_gui.fig
%      RRT_GUI, by itself, creates a new RRT_GUI or raises the existing
%      singleton*.
%
%      H = RRT_GUI returns the handle to a new RRT_GUI or the handle to
%      the existing singleton*.
%
%      RRT_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RRT_GUI.M with the given input arguments.
%
%      RRT_GUI('Property','Value',...) creates a new RRT_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RRT_gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RRT_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RRT_gui

% Last Modified by GUIDE v2.5 25-Mar-2010 18:51:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RRT_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @RRT_gui_OutputFcn, ...
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


% --- Executes just before RRT_gui is made visible.
function RRT_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RRT_gui (see VARARGIN)

	% Clear all stored values
    
    if ( isappdata(0, 'figHandle') )
        rmappdata(0, 'figHandle');
    end
    if ( isappdata(0, 'ax') )
        rmappdata(0, 'ax');
    end
    if ( isappdata(0, 'sfOption') )
        rmappdata(0, 'sfOption');
    end
    if ( isappdata(0, 'startPlot') )
        rmappdata(0, 'startPlot');
    end
    if ( isappdata(0, 'finishPlot') )
        rmappdata(0, 'finishPlot');
    end
    if ( isappdata(0, 'mapMatrix') )
        rmappdata(0, 'mapMatrix');
    end
    if ( isappdata(0, 'mapSize') )
        rmappdata(0, 'mapSize');
    end
    if ( isappdata(0, 'startPoint') )
        rmappdata(0, 'startPoint');
    end
    if ( isappdata(0, 'finishPoint') )
        rmappdata(0, 'finishPoint');
    end
    
    % Set the window position
    tempPos = get(gcf, 'Position');
    set(gcf, 'Position', [20 10 tempPos(3) tempPos(4)]);


% Choose default command line output for RRT_gui
handles.output = hObject;

% Deselect specify and type
set(handles.sfpanel,'SelectedObject',[]);  % No selection

% On change use appropriate callbacks
set(handles.sfpanel,'SelectionChangeFcn', @sf_CallBack);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RRT_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = RRT_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function sf_CallBack(hObject, eventdata)
    handles = guidata(hObject);
    
    % get the figure handle
    figHandle = getappdata(0, 'figHandle');
    
    setappdata(0, 'handles', handles);
    ax = getappdata(0, 'ax');
    
    % See which field is selected
    switch get(eventdata.NewValue, 'Tag')
        case 'startradio'
            % Set the option to 1 - Start
            sfOption = 1;
            % Store specOption
            setappdata(0, 'sfOption', sfOption);
            
            figure(figHandle);
            hold on;
            % Call the function if mouse is pressed
            set(ax, 'ButtonDownFcn', @ButtonDown);
%             set(figHandle, 'WindowButtonDownFcn',@figButton_CallBack);
            
        case 'finishradio'
            % Set the option to 2 - Finish
            sfOption = 2;
            % Store specOption
            setappdata(0, 'sfOption', sfOption);
            
            figure(figHandle);
            hold on;
            % Call the function if mouse is pressed
            set(ax, 'ButtonDownFcn', @ButtonDown);
%             set(figHandle, 'WindowButtonDownFcn',@figButton_CallBack);
    end
    
    
function ButtonDown(varargin)%hObject, eventdata)

    % Get needed variables
    figHandle = getappdata(0, 'figHandle');
    sfOption = getappdata(0, 'sfOption');
    ax = getappdata(0, 'ax');
    
    % Check which radio is selected
    switch sfOption
        % Start
        case 1
            p = get(ax,'CurrentPoint');
            startPoint = round([p(1,1) p(1,2)]);
            
            % Store startPoint
            setappdata(0, 'startPoint', startPoint);
            
            % If startPoint already exists
            if (isappdata(0, 'startPlot'))
                % Get startPlot
                startPlot = getappdata(0, 'startPlot');
                
                % Change its coordinates to new ones
                figure(figHandle);
                set(startPlot, 'XData', startPoint(1), 'YData', startPoint(2));
            % If startPoint does not exist 
            else
                % Plot the point
                figure(figHandle);
                startPlot = line('XData', startPoint(1), 'YData', startPoint(2), 'LineStyle', 'none', 'Marker', 'p','MarkerFaceColor', 'green', 'MarkerSize', 20);
                hold on;
            
                % Store startPlot
                setappdata(0, 'startPlot', startPlot);
            end
            
        % Finish
        case 2
            p = get(ax,'CurrentPoint');
            finishPoint = round([p(1,1) p(1,2)]);
            
            % Store finish point
            setappdata(0, 'finishPoint', finishPoint);
            
             % If finishPoint already exists
            if (isappdata(0, 'finishPlot'))
                % Get startPlot
                finishPlot = getappdata(0, 'finishPlot');
                
                % Change its coordinates to new ones
                figure(figHandle);
                set(finishPlot, 'XData', finishPoint(1), 'YData', finishPoint(2));
            % If finishPoint does not exist 
            else
            
                % Plot the point
                figure(figHandle);
                finishPlot = line('XData', finishPoint(1), 'YData', finishPoint(2), 'LineStyle', 'none', 'Marker', 'p','MarkerFaceColor', 'red', 'MarkerSize', 20);
                hold on;
            
                % Store finishPlot
                setappdata(0, 'finishPlot', finishPlot);
            end
    end
    
    handles = getappdata(0, 'handles');
    % If start and finish positions are set, make start button visible
    if ( isappdata(0, 'startPlot') && isappdata(0, 'finishPlot') )
        set(handles.startbutton, 'Visible', 'on');
    else
        set(handles.startbutton, 'Visible', 'off');
    end
    
    % Remove handles
    %rmappdata(0, 'handles');

% --- Executes on selection change in mappopup.
function mappopup_Callback(hObject, eventdata, handles)
% hObject    handle to mappopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns mappopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mappopup


% --- Executes during object creation, after setting all properties.
function mappopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mappopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in mapbutton.
function mapbutton_Callback(hObject, eventdata, handles)
% hObject    handle to mapbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Clear some stored values
    if ( isappdata(0, 'figHandle') )
        rmappdata(0, 'figHandle');
    end
    if ( isappdata(0, 'ax') )
        rmappdata(0, 'ax');
    end
    if ( isappdata(0, 'sfOption') )
        rmappdata(0, 'sfOption');
    end
    if ( isappdata(0, 'startPlot') )
        rmappdata(0, 'startPlot');
    end
    if ( isappdata(0, 'finishPlot') )
        rmappdata(0, 'finishPlot');
    end
    if ( isappdata(0, 'mapMatrix') )
        rmappdata(0, 'mapMatrix');
    end
    if ( isappdata(0, 'mapSize') )
        rmappdata(0, 'mapSize');
    end
    if ( isappdata(0, 'startPoint') )
        rmappdata(0, 'startPoint');
    end
    if ( isappdata(0, 'finishPoint') )
        rmappdata(0, 'finishPoint');
    end
    
    
    % Get the selection from mappopup
    switch (get(handles.mappopup, 'Value'))
        case 1
            mapNo = 1;
        case 2
            mapNo = 2;
        case 3
            mapNo = 3;
        case 4
            mapNo = 4;
        case 5
            mapNo = 5;
        otherwise
            mapNo = 1;
    end
    
    % Open map in figure
    [mapMatrix mapSize figHandle ax] = RRT_createMap(mapNo);
    % Store variables
    setappdata(0, 'mapMatrix', mapMatrix);
    setappdata(0, 'mapSize', mapSize);
    setappdata(0, 'figHandle', figHandle);
    setappdata(0, 'ax', ax);

    % Make property selections visible
    set(handles.sftext, 'Visible', 'on');
    set(handles.sfpanel, 'Visible', 'on');
    set(handles.disttext, 'Visible', 'on');
    set(handles.distslider, 'Visible', 'on');
    set(handles.distscreen, 'Visible', 'on');
    set(handles.steptext, 'Visible', 'on');
    set(handles.stepslider, 'Visible', 'on');
    set(handles.stepscreen, 'Visible', 'on');
    set(handles.itertext, 'Visible', 'on');
    set(handles.iterslider, 'Visible', 'on');
    set(handles.iterscreen, 'Visible', 'on');
    set(handles.probtext, 'Visible', 'on');
    set(handles.probpopup, 'Visible', 'on');
    set(handles.simspeedtext, 'Visible', 'on');
    set(handles.simspeedpopup, 'Visible', 'on');

% --- Executes on slider movement.
function distslider_Callback(hObject, eventdata, handles)
% hObject    handle to distslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

    % Get the value of the slider
    sliderVal = round(get(hObject, 'Value'));
    set(handles.distscreen, 'String', sliderVal);


% --- Executes during object creation, after setting all properties.
function distslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to distslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function stepslider_Callback(hObject, eventdata, handles)
% hObject    handle to stepslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

    % Get the value of the slider
    sliderVal = round(get(hObject, 'Value'));
    set(handles.stepscreen, 'String', sliderVal);

% --- Executes during object creation, after setting all properties.
function stepslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stepslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function iterslider_Callback(hObject, eventdata, handles)
% hObject    handle to iterslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

    % Get the value of the slider
    sliderVal = round(get(hObject, 'Value'));
    set(handles.iterscreen, 'String', sliderVal);


% --- Executes during object creation, after setting all properties.
function iterslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iterslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in probpopup.
function probpopup_Callback(hObject, eventdata, handles)
% hObject    handle to probpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns probpopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from probpopup


% --- Executes during object creation, after setting all properties.
function probpopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to probpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in simspeedpopup.
function simspeedpopup_Callback(hObject, eventdata, handles)
% hObject    handle to simspeedpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns simspeedpopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from simspeedpopup


% --- Executes during object creation, after setting all properties.
function simspeedpopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to simspeedpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in startradio.
function startradio_Callback(hObject, eventdata, handles)
% hObject    handle to startradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
function startbutton_Callback(hObject, eventdata, handles)
    
    % Get needed data
    mapMatrix = getappdata(0, 'mapMatrix');
    mapSize = getappdata(0, 'mapSize');
    startPoint = getappdata(0, 'startPoint');
    finishPoint = getappdata(0, 'finishPoint');
    figHandle = getappdata(0, 'figHandle');
    distThresh = round(get(handles.distslider, 'Value'));
    stepSize = round(get(handles.stepslider, 'Value'));
    iter = round(get(handles.iterslider, 'Value'));
    
    
    switch get(handles.probpopup, 'Value')
        case 1
            goalProb = 0.05;
        case 2
            goalProb = 0.1;
        case 3
            goalProb = 0.15;
        case 4
            goalProb = 0.2;
        case 5
            goalProb = 0.3;
        case 6
            goalProb = 0.4;
        case 7
            goalProb = 0.5;
        case 8
            goalProb = 0.6;
        case 9
            goalProb = 0.7;
        case 10
            goalProb = 0.8;
        case 11
            goalProb = 0.9;
        otherwise
            goalProb = 0.1; 
    end
    
    
    % Get the speed option
    switch ( get(handles.simspeedpopup, 'Value') )
        case 1
            delay = 1;
            set(handles.nextsteptext, 'Visible', 'off');
        case 2
            delay = 2;
            set(handles.nextsteptext, 'Visible', 'off');
        case 3
            delay = 3;
            set(handles.nextsteptext, 'Visible', 'off');
        case 4
            delay = 4;
            set(handles.nextsteptext, 'Visible', 'on');
        otherwise
            delay = 1;
            set(handles.nextsteptext, 'Visible', 'off');
    end
    
    figure(figHandle);
    % Call the RRTPlan function
    RRTPlan(mapMatrix, mapSize, startPoint, finishPoint, distThresh, stepSize, iter, goalProb, delay, figHandle);

% --- Executes on button press in explainbutton.
function explainbutton_Callback(hObject, eventdata, handles)
% hObject    handle to explainbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Open PDF documentation
    open('RRT_help.pdf');


