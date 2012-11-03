function [mapMatrix mapSize figHandle ax] = RRT_createMap(mapNo)

	% Create map matrix
    mapSize = 200;
    mapMatrix = zeros(mapSize,mapSize);
    figHandle = figure('Visible', 'on');
    % Change the position of the window
    tempPos = get(gcf, 'Position');
    set(gcf, 'Position', [450 250 tempPos(3) tempPos(4)]);

    ax = axes('XLim',[0,200],'YLim',[0,200]);
    hold on;
    
    switch mapNo
        case 1
            % ## MAP 1 ##
            rectangle('Position', [50 0 10 100], 'FaceColor', 'black');
            rectangle('Position', [60 90 80 10], 'FaceColor', 'black');
            rectangle('Position', [100 150 10 50], 'FaceColor', 'black');
            mapMatrix(50:60,1:100) = 1;
            mapMatrix(60:140, 90:100) = 1;
            mapMatrix(100:110, 150:200) = 1;
        case 2
            % ## MAP 2 ##
            rectangle('Position', [0 40 120 10], 'FaceColor', 'black');
            rectangle('Position', [80 90 180 10], 'FaceColor', 'black');
            rectangle('Position', [0 140 120 10], 'FaceColor', 'black');
            mapMatrix(1:120, 40:50) = 1;
            mapMatrix(80:200, 90:100) = 1;
            mapMatrix(1:120, 140:150) = 1;
        case 3
            % ## MAP 3 ##
            rectangle('Position', [70 0 10 110], 'FaceColor', 'black');
            rectangle('Position', [0 160 110 10], 'FaceColor', 'black');
            rectangle('Position', [160 160 40 10], 'FaceColor', 'black');
            mapMatrix(70:80, 1:110) = 1;
            mapMatrix(1:110, 150:160) = 1;
            mapMatrix(160:200, 150:160) = 1;
        case 4
            % ## MAP 4 ##
            rectangle('Position', [40 0 10 80], 'FaceColor', 'black');
            rectangle('Position', [90 60 10 100], 'FaceColor', 'black');
            rectangle('Position', [90 160 70 10], 'FaceColor', 'black');
            rectangle('Position', [150 60 10 100], 'FaceColor', 'black');
            rectangle('Position', [120 0 10 40], 'FaceColor', 'black');
            mapMatrix(40:50, 1:80) = 1;
            mapMatrix(90:100, 60:160) = 1;
            mapMatrix(90:160, 160:170) = 1;
            mapMatrix(150:160, 60:160) = 1;
            mapMatrix(120:130, 1:40) = 1;
        case 5
            % ## MAP 5 ##
            rectangle('Position', [0 50 100 10], 'FaceColor', 'black');
            rectangle('Position', [140 30 10 40], 'FaceColor', 'black');
            rectangle('Position', [90 100 50 100], 'FaceColor', 'black');
            rectangle('Position', [140 130 30 10], 'FaceColor', 'black');
            mapMatrix(1:100, 50:60) = 1;
            mapMatrix(140:150, 30:70) = 1;
            mapMatrix(90:140, 100:200) = 1;
            mapMatrix(140:170, 130:140) = 1;
    end
    
    % #### END ####
    
end