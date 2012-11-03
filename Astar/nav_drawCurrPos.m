function nav_drawCurrPos(figHandle, x, y, color, objMap)
    % Redraw the map
    figure(figHandle);
    hold on;
    
    % Plot the point
    
    tempObjHandle = objMap(x,y);
    set(tempObjHandle, 'FaceColor', color);

end