function varargout = Astar_GUI(varargin)
% ASTAR_GUI M-file for Astar_GUI.fig
%      ASTAR_GUI, by itself, creates a new ASTAR_GUI or raises the existing
%      singleton*.
%
%      H = ASTAR_GUI returns the handle to a new ASTAR_GUI or the handle to
%      the existing singleton*.
%
%      ASTAR_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ASTAR_GUI.M with the given input arguments.
%
%      ASTAR_GUI('Property','Value',...) creates a new ASTAR_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Astar_GUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Astar_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Astar_GUI

% Last Modified by GUIDE v2.5 25-Mar-2010 12:25:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Astar_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Astar_GUI_OutputFcn, ...
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


% --- Executes just before Astar_GUI is made visible.
function Astar_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Astar_GUI (see VARARGIN)

    % Clear all stored values
    if ( isappdata(0, 'startPos') )
        rmappdata(0, 'startPos');
    end
    if ( isappdata(0, 'finishPos') )
        rmappdata(0, 'finishPos');
    end
    if ( isappdata(0, 'whichList') )
        rmappdata(0, 'whichList');
    end
    if ( isappdata(0, 'figHandle') )
        rmappdata(0, 'figHandle');
    end
    if ( isappdata(0, 'objMap') )
        rmappdata(0, 'objMap');
    end
    if ( isappdata(0, 'mapSize') )
        rmappdata(0, 'mapSize');
    end
    if ( isappdata(0, 'specOption') )
    	getappdata(0, 'specOption');
    end
    
    % Set the window position
    tempPos = get(gcf, 'Position');
    set(gcf, 'Position', [20 35 tempPos(3) tempPos(4)]);

% Choose default command line output for Astar_GUI
handles.output = hObject;

% Deselect specify and type
set(handles.specifypanel,'SelectedObject',[]);  % No selection

% On change use appropriate callbacks
set(handles.specifypanel,'SelectionChangeFcn',@specify_CallBack);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Astar_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Astar_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on change in selection on specifypanel.
function specify_CallBack(hObject, eventdata)
    handles = guidata(hObject);
    
    % get the figure handle
    figHandle = getappdata(0, 'figHandle');
    
    setappdata(0, 'handles', handles);
    
    % See which field is selected
    switch get(eventdata.NewValue, 'Tag')
        case 'startradio'
            % Set the option to 1 - Start
            specOption = 1;
            % Store specOption
            setappdata(0, 'specOption', specOption);
            
            % Call the function if mouse is pressed
            set(figHandle, 'WindowButtonDownFcn',@figButton_CallBack);
            
        case 'finishradio'
            % Set the option to 1 - Finish
            specOption = 2;
            % Store specOption
            setappdata(0, 'specOption', specOption);
            % Call the function if mouse is pressed
            set(figHandle, 'WindowButtonDownFcn',@figButton_CallBack);

        case 'obstacleradio'
            % Set the option to 1 - Obstacle
            specOption = 3;
            % Store specOption
            setappdata(0, 'specOption', specOption);
            % Call the function if mouse is pressed
            set(figHandle, 'WindowButtonDownFcn',@figButton_CallBack);

            
    end



function figButton_CallBack(hObject, eventdata)
    
    % get the figure handle, specOption and objMap
    figHandle = getappdata(0, 'figHandle');
    specOption = getappdata(0, 'specOption');
    objMap = getappdata(0, 'objMap');
    % Find min and max of objMap
    minObjMap = min(min(objMap));
    maxObjMap = max(max(objMap));
    % Get the handle of object that was pressed
    tempObj = get(figHandle, 'CurrentObject');
    % Check that mouse was pressed on the grid
    if ( (tempObj >= minObjMap) && (tempObj <= maxObjMap) )
        % Get matrix coordinates by using object handle and whichList
        [x y] = find(objMap == tempObj);
        whichList = getappdata(0, 'whichList');
        % Set walkable and unwalkable 'constants'
        walkable = 1;
        unwalkable = 4;
    
        switch specOption
            case 1      % If it's start radio
                
                % If startPosition has been defined previously
                if (isappdata(0, 'startPos')),
                    % Get start position
                    startPos = getappdata(0, 'startPos');
                    % If it's the same point
                    if ( (x == startPos(1)) && (y == startPos(2)) )
                        % Remove the point
                        set(tempObj, 'FaceColor', 'white');
                        rmappdata(0, 'startPos');
                    % Check if finish point is present
                    elseif ( isappdata(0, 'finishPos') )
                        finishPos = getappdata(0, 'finishPos');
                        % If it's instead of finish point
                        if ( (x == finishPos(1)) && (y == finishPos(2)) )
                            % Find coordinates of previous startPos
                            prevStartPos = getappdata(0, 'startPos');
                            set(objMap(prevStartPos(1),prevStartPos(2)), 'FaceColor', 'white');
                            % Set new one and remove finishPos
                            set(tempObj, 'FaceColor', 'green');
                            startPos(1) = x;
                            startPos(2) = y;
                            setappdata(0, 'startPos', startPos);
                            rmappdata(0, 'finishPos');
                        else
                            % Find coordinates of previous startPos
                            prevStartPos = getappdata(0, 'startPos');
                            set(objMap(prevStartPos(1),prevStartPos(2)), 'FaceColor', 'white');
                            % Set new startPoint
                            set(tempObj, 'FaceColor', 'green');
                            startPos(1) = x;
                            startPos(2) = y;
                            setappdata(0, 'startPos', startPos);
                        end
                    % If obstacle is located at the location
                    elseif (whichList(x,y) == unwalkable)
                        % Find coordinates of previous startPos
                        prevStartPos = getappdata(0, 'startPos');
                        set(objMap(prevStartPos(1),prevStartPos(2)), 'FaceColor', 'white');
                        % Set new startPoint
                        set(tempObj, 'FaceColor', 'green');
                        startPos(1) = x;
                        startPos(2) = y;
                        setappdata(0, 'startPos', startPos);
                        % Set the point as walkable and store matrix
                        whichList(x,y) = walkable;
                        setappdata(0, 'whichList', whichList);
                    % If new start pos is on neutral spot
                    else
                        % Remove previous start position and assign new
                        % Find coordinates of previous startPos
                        prevStartPos = getappdata(0, 'startPos');
                        set(objMap(prevStartPos(1),prevStartPos(2)), 'FaceColor', 'white');
                        % Set new startPos
                        set(tempObj, 'FaceColor', 'green');
                        startPos(1) = x;
                        startPos(2) = y;
                        setappdata(0, 'startPos', startPos);
                    end
                % If finish position is set
                elseif ( isappdata(0, 'finishPos') )
                	finishPos = getappdata(0, 'finishPos');
                    % If it's instead of finish point
                    if ( (x == finishPos(1)) && (y == finishPos(2)) )
                        % Set new one and remove finishPos
                        set(tempObj, 'FaceColor', 'green');
                        startPos(1) = x;
                        startPos(2) = y;
                        setappdata(0, 'startPos', startPos);
                        rmappdata(0, 'finishPos');
                    else
                        % Set new startPoint
                        set(tempObj, 'FaceColor', 'green');
                        startPos(1) = x;
                        startPos(2) = y;
                        setappdata(0, 'startPos', startPos);
                    end
                    
                % If it's instead of obstacle
                elseif (whichList(x,y) == unwalkable)
                	% Set new startPoint
                    set(tempObj, 'FaceColor', 'green');
                    startPos(1) = x;
                    startPos(2) = y;
                    setappdata(0, 'startPos', startPos);
                    % Set the point as walkable and store matrix
                    whichList(x,y) = walkable;
                    setappdata(0, 'whichList', whichList);
                % If no start or finish position was previously defined
                else
                    set(tempObj, 'FaceColor', 'green');
                    startPos(1) = x;
                    startPos(2) = y;
                    setappdata(0, 'startPos', startPos);
                end

                
            % If it's finish radio
            case 2      
                % If finishPosition has been defined previously
                if (isappdata(0, 'finishPos')),
                    % Get finish position
                    finishPos = getappdata(0, 'finishPos');
                    % If it's the same point
                    if ( (x == finishPos(1)) && (y == finishPos(2)) )
                        % Remove the point
                        set(tempObj, 'FaceColor', 'white');
                        rmappdata(0, 'finishPos');
                    % Check if start point is present
                    elseif ( isappdata(0, 'startPos') )
                        startPos = getappdata(0, 'startPos');
                        % If it's instead of start point
                        if ( (x == startPos(1)) && (y == startPos(2)) )
                            % Find coordinates of previous finishPos
                            prevFinishPos = getappdata(0, 'finishPos');
                            set(objMap(prevFinishPos(1),prevFinishPos(2)), 'FaceColor', 'white');
                            % Set new one and remove startPos
                            set(tempObj, 'FaceColor', 'red');
                            finishPos(1) = x;
                            finishPos(2) = y;
                            setappdata(0, 'finishPos', finishPos);
                            rmappdata(0, 'startPos');
                        else
                            % Find coordinates of previous finishPos
                            prevFinishPos = getappdata(0, 'finishPos');
                            set(objMap(prevFinishPos(1),prevFinishPos(2)), 'FaceColor', 'white');
                            % Set new finishPoint
                            set(tempObj, 'FaceColor', 'red');
                            finishPos(1) = x;
                            finishPos(2) = y;
                            setappdata(0, 'finishPos', finishPos);
                        end
                    % If obstacle is located at the location
                    elseif (whichList(x,y) == unwalkable)
                        % Find coordinates of previous finishPos
                        prevFinishPos = getappdata(0, 'finishPos');
                        set(objMap(prevFinishPos(1),prevFinishPos(2)), 'FaceColor', 'white');
                        % Set new finishPoint
                        set(tempObj, 'FaceColor', 'red');
                        finishPos(1) = x;
                        finishPos(2) = y;
                        setappdata(0, 'finishPos', finishPos);
                        % Set the point as walkable and store matrix
                        whichList(x,y) = walkable;
                        setappdata(0, 'whichList', whichList);
                    % If new finish pos is on neutral spot
                    else
                        % Remove previous finish position and assign new
                        % Find coordinates of previous finishPos
                        prevFinishPos = getappdata(0, 'finishPos');
                        set(objMap(prevFinishPos(1),prevFinishPos(2)), 'FaceColor', 'white');
                        % Set new finishPoint
                        set(tempObj, 'FaceColor', 'red');
                        finishPos(1) = x;
                        finishPos(2) = y;
                        setappdata(0, 'finishPos', finishPos);
                    end
                % If start position is set
                elseif ( isappdata(0, 'startPos') )
                	startPos = getappdata(0, 'startPos');
                    % If it's instead of start point
                    if ( (x == startPos(1)) && (y == startPos(2)) )
                        % Set new one and remove startPos
                        set(tempObj, 'FaceColor', 'red');
                        finishPos(1) = x;
                        finishPos(2) = y;
                        setappdata(0, 'finishPos', finishPos);
                        rmappdata(0, 'startPos');
                    else
                        % Set new finishPoint
                        set(tempObj, 'FaceColor', 'red');
                        finishPos(1) = x;
                        finishPos(2) = y;
                        setappdata(0, 'finishPos', finishPos);
                    end
                    
                % If it's instead of obstacle
                elseif (whichList(x,y) == unwalkable)
                	% Set new finishPoint
                    set(tempObj, 'FaceColor', 'red');
                    finishPos(1) = x;
                    finishPos(2) = y;
                    setappdata(0, 'finishPos', finishPos);
                    % Set the point as walkable and store matrix
                    whichList(x,y) = walkable;
                    setappdata(0, 'whichList', whichList);
                % If no start or finish position was previously defined
                else
                    set(tempObj, 'FaceColor', 'red');
                    finishPos(1) = x;
                    finishPos(2) = y;
                    setappdata(0, 'finishPos', finishPos);
                end
                
                
                
            % If it's obstacle radio
            case 3     
                % If both, start and finish points exist
                if ( (isappdata(0, 'startPos')) && (isappdata(0, 'finishPos')) )
                    startPos = getappdata(0, 'startPos');
                    finishPos = getappdata(0, 'finishPos');
                    % If obstacle is set instead of start
                    if ( (x == startPos(1)) && (y == startPos(2)) )
                        % Remove startPos and put obstacle instead
                        set(tempObj, 'FaceColor', 'black');
                        whichList(x,y) = unwalkable;
                        rmappdata(0, 'startPos');
                    % If obstacle is set instead of finish
                    elseif ( (x == finishPos(1)) && (y == finishPos(2)) )
                        % Remove startPos and put obstacle instead
                        set(tempObj, 'FaceColor', 'black');
                        whichList(x,y) = unwalkable;
                        rmappdata(0, 'finishPos');
                    % If obstacle exists at that location
                    elseif ( whichList(x,y) == unwalkable )
                        % Remove obstacle
                        set(tempObj, 'FaceColor', 'white');
                        whichList(x,y) = walkable;
                    else
                        % Put new obstacle
                        set(tempObj, 'FaceColor', 'black');
                        whichList(x,y) = unwalkable;
                    end
                % If only startPos exists
                elseif ( isappdata(0, 'startPos') )
                    startPos = getappdata(0, 'startPos');
                    % If obstacle is set instead of it
                    if ( (x == startPos(1)) && (y == startPos(2)) )
                        % Remove startPos and put obstacle instead
                        set(tempObj, 'FaceColor', 'black');
                        whichList(x,y) = unwalkable;
                        rmappdata(0, 'startPos');
                    % If obstacle exists at that location
                    elseif ( whichList(x,y) == unwalkable )
                        % Remove obstacle
                        set(tempObj, 'FaceColor', 'white');
                        whichList(x,y) = walkable;
                    else
                        % Put new obstacle
                        set(tempObj, 'FaceColor', 'black');
                        whichList(x,y) = unwalkable;
                    end
                % If only finishPos exists
                elseif ( isappdata(0, 'finishPos') )
                    finishPos = getappdata(0, 'finishPos');
                    % If obstacle is set instead of it
                    if ( (x == finishPos(1)) && (y == finishPos(2)) )
                        % Remove startPos and put obstacle instead
                        set(tempObj, 'FaceColor', 'black');
                        whichList(x,y) = unwalkable;
                        rmappdata(0, 'finishPos');
                    % If obstacle exists at that location
                    elseif ( whichList(x,y) == unwalkable )
                        % Remove obstacle
                        set(tempObj, 'FaceColor', 'white');
                        whichList(x,y) = walkable;
                    else
                        % Put new obstacle
                        set(tempObj, 'FaceColor', 'black');
                        whichList(x,y) = unwalkable;
                    end
                % If no start or finish point exists
                else
                    % If obstacle exists at that location
                    if ( whichList(x,y) == unwalkable )
                        % Remove obstacle
                        set(tempObj, 'FaceColor', 'white');
                        whichList(x,y) = walkable;
                    else
                        % Put new obstacle
                        set(tempObj, 'FaceColor', 'black');
                        whichList(x,y) = unwalkable;
                    end
                end
                    
                % Store whichList
                setappdata(0, 'whichList', whichList);
                
        end
        
        handles = getappdata(0, 'handles');
        % If start and finish positions are set, make start button visible
        if ( isappdata(0, 'startPos') && isappdata(0, 'finishPos') )
            set(handles.startbutton, 'Visible', 'on');
            set(handles.simspeedpopup, 'Visible', 'on');
            set(handles.simspeedtext, 'Visible', 'on');
        else
            set(handles.startbutton, 'Visible', 'off');
            set(handles.simspeedpopup, 'Visible', 'off');
            set(handles.simspeedtext, 'Visible', 'off');
        end
    end

   

% --- Executes on selection change in mapsizepopup.
function mapsizepopup_Callback(hObject, eventdata, handles)
% hObject    handle to mapsizepopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns mapsizepopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        mapsizepopup


% --- Executes during object creation, after setting all properties.
function mapsizepopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mapsizepopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in openmapbutton.
function openmapbutton_Callback(hObject, eventdata, handles)
% hObject    handle to openmapbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Clear all stored values
    if ( isappdata(0, 'startPos') )
        rmappdata(0, 'startPos');
    end
    if ( isappdata(0, 'finishPos') )
        rmappdata(0, 'finishPos');
    end
    if ( isappdata(0, 'whichList') )
        rmappdata(0, 'whichList');
    end
    if ( isappdata(0, 'figHandle') )
        rmappdata(0, 'figHandle');
    end
    if ( isappdata(0, 'objMap') )
        rmappdata(0, 'objMap');
    end

    % Get map size figure
%     mapSize = getappdata(0, 'mapSize');
    switch get(handles.mapsizepopup, 'Value')
        case 1
            mapSize = 10;
        case 2
            mapSize = 15;
        case 3
            mapSize = 20;
        case 4
            mapSize = 25;
        case 5
            mapSize = 30;
        otherwise
            mapSize = 10;
    end
    
    
    % Create map
    [figHandle objMap] = nav_createMap(mapSize);
    % Store figure handle and sfoMap
    setappdata(0, 'figHandle', figHandle);
    setappdata(0, 'objMap', objMap);
    % Make specify fields visible
    set(handles.specifytext, 'Visible', 'on');
    set(handles.specifypanel, 'Visible', 'on');
    % Create whichList array
    whichList = zeros(mapSize,mapSize);
    setappdata(0, 'whichList', whichList);

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


% --- Executes on button press in nexbutton.
function nexbutton_Callback(hObject, eventdata, handles)
% hObject    handle to nexbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in startbutton.
function startbutton_Callback(hObject, eventdata, handles)
% hObject    handle to startbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Get required data
    startPos = getappdata(0, 'startPos');
    finishPos = getappdata(0, 'finishPos');
    whichList = getappdata(0, 'whichList');
    figHandle = getappdata(0, 'figHandle');
    objMap = getappdata(0, 'objMap');
    
    % Get the speed option
    switch ( get(handles.simspeedpopup, 'Value') )
        case 1
            speedOpt = 1;
            set(handles.nextsteptext, 'Visible', 'off');
        case 2
            speedOpt = 2;
            set(handles.nextsteptext, 'Visible', 'off');
        case 3
            speedOpt = 3;
            set(handles.nextsteptext, 'Visible', 'off');
        case 4
            speedOpt = 4;
            set(handles.nextsteptext, 'Visible', 'on');
        otherwise
            speedOpt = 1;
            set(handles.nextsteptext, 'Visible', 'off');
    end
    
    figure(figHandle);
    % Call the Astar function
    Astar(startPos(1), startPos(2), finishPos(1), finishPos(2), whichList, figHandle, objMap, speedOpt);


% --- Executes on button press in explainbutton.
function explainbutton_Callback(hObject, eventdata, handles)
% hObject    handle to explainbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Open PDF documentation
    open('Astar_help.pdf');

