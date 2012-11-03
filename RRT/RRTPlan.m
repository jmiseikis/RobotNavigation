%% MAIN FUNCTION

function RRTPlan(mapMatrix, mapSize, start, finish, distThresh, stepSize, iter, goalProb, delayOption, figHandle)

    % Constants
    emptyNode = 0;
    success = 0;
    
    nearestNode = start;
    
    % Set the first element of a tree
    pathTree(1).x = start(1);
    pathTree(1).y = start(2);
    pathTree(1).parent = 1;
    
    % Print out options
    fprintf('---------------------------------------------------- \n');
    fprintf('##### RRT - Real-Time Randomised Path Planning ##### \n');
    fprintf('---------------------------------------------------- \n\n');
    fprintf('Starting the simulation \n');
    fprintf('Using the following options: \n');
    fprintf('Max number of iterations: %d \n', iter);
    fprintf('Distance to the target threshold: %d \n', distThresh);
    fprintf('Goal probability: %f \n', goalProb);
    fprintf('Step size: %d \n', stepSize);
    fprintf('Start position: %d, %d \n', start(1), start(2));
    fprintf('Finish position: %d, %d \n', finish(1), finish(2));
    fprintf('Map size: %d \n\n\n', mapSize);
    
    fprintf('Searching for the optimum path... \n');
    
    % Loop until nearest is close enough to goal ##### DOUBLE CHECK #####
    for i=1:iter,
        
        % Delay
        switch delayOption
            case 1
                % No delay
            case 2
                pause(0.1);
            case 3
                pause(0.15);
            case 4;
                disp('Press any key (for example space) for next step');
                pause;
        end
        
        % If branch got close enough to the target, terminate
        if (i ~= 1)
            if (Dist(nearestNode, finish) < distThresh )
                success = 1;
                break;
            end
        end
        
        % Call the function to select the next target
        target = ChooseTarget(finish, mapSize, goalProb);
        % Call the function to find the closest node to target
        [nearestNode nearestNodeID] = NearestNode(pathTree, target);
        % Call the function to extend the branch towards next target
        extended = Extend(mapMatrix, nearestNode, target, stepSize);
        % If extended didn't hit the wall, add it as a new branch
        if (extended ~= emptyNode)
            pathTree = AddNode(pathTree, extended, nearestNodeID);
            
            % Plot line
            figure(figHandle);
            plot([nearestNode(1) extended(1)], [nearestNode(2) extended(2)]);
            hold on;
        end
    end
    
    

    % Check if goal was reached
    if (success == 1),
        btX = finish(1);
        btY = finish(2);
        currNode = pathTree(length(pathTree));
        % Distance counter
        btDist = 0;
        % Backtrack the best path
        while (1)
            % find parent of current node
            parentID = currNode.parent;
            % Plot backtrack in red line
            plot([btX pathTree(parentID).x], [btY pathTree(parentID).y], 'm', 'LineWidth', 2);
            hold on;
            % Change current node to its parent
            currNode = pathTree(parentID);
            btX = currNode.x;
            btY = currNode.y;
            % Increment distance counter
            btDist = btDist + stepSize;
            
            % If startpoint was reached, break out of the loop
            if ( (btX == start(1)) && (btY == start(2)) )
                break;
            end
        end
        
        % Print out results
        fprintf('Goal was reached! \n');
        fprintf('Path distance: %d \n', btDist);
        fprintf('Number of iterations: %d \n', i);
        fprintf('Number of tree branches: %d \n', length(pathTree));
    else
        fprintf('After %d iterations, goal was not reached...\n', iter);
    end
end

%% CHOSE TARGET FUNCTION
function target = ChooseTarget(finish, mapSize, goalProb)
    % Create a random value between 0 and 1
    p = rand;
    
    if ( (p > 0) && (p < goalProb) )
        target = finish;
    elseif ( (p > goalProb) && (p < 1) )
        target = rand(1,2) * mapSize;
    end
end

%% NEAREST NODE FUNCTION
function [nearestNode nearestNodeID] = NearestNode(tree, target)
    % Find distances from all nodes to the target
    for i=1:length(tree)
        tempNode(1) = tree(i).x;
        tempNode(2) = tree(i).y;
        nodeDistArray(i) = Dist(tempNode, target);
    end
    
    % Find the ID of minimum distance
    nearestNodeID = find(nodeDistArray == min(nodeDistArray));
    nearestNode(1) = tree(nearestNodeID).x;
    nearestNode(2) = tree(nearestNodeID).y;
end

%% EUCLIDEAN DISTANCE BETWEED TWO 2D POINTS
function distance = Dist(x, y)
    % Calculate the euclidean distance between x and y
    distance  = sqrt( (x(1) - y(1))^2 + (x(2) - y(2))^2 );
end

%% EXTEND FUNCTION
function extended = Extend(mapMatrix, nearest, target, stepSize)

    % Get dimensions of mapMatrix
    [x y] = size(mapMatrix);
    
    % Find diffX and diffY
    diffX = abs(nearest(1) - target(1));
    diffY = abs(nearest(2) - target(2));
    
    % Find distance between them
    dist = Dist(nearest, target);
    
    % Find sin and cos
    sinA = diffX/dist;
    cosA = diffY/dist;
    
    % Find new position after the step towards target, round them to
    % nearest integer
    if ( ((nearest(1) - target(1)) < 0) && ((nearest(2) - target(2)) < 0) )
        newPos(1) = round(nearest(1) + (stepSize * sinA));
        newPos(2) = round(nearest(2) + (stepSize * cosA));
        
    elseif ( ((nearest(1) - target(1)) > 0) && ((nearest(2) - target(2)) < 0) )
        newPos(1) = round(nearest(1) - (stepSize * sinA));
        newPos(2) = round(nearest(2) + (stepSize * cosA));
        
    elseif ( ((nearest(1) - target(1)) < 0) && ((nearest(2) - target(2)) > 0) )
        newPos(1) = round(nearest(1) + (stepSize * sinA));
        newPos(2) = round(nearest(2) - (stepSize * cosA));
        
    else
        newPos(1) = round(nearest(1) - (stepSize * sinA));
        newPos(2) = round(nearest(2) - (stepSize * cosA));
    end
    
    % Check if it's not out of bounds
    if ( (newPos(1) > x) || (newPos(1) < 1) || (newPos(2) > y) || (newPos(2) < 1) ),
        extended = 0;
    % Check if that coordinate is not covered by an obstacle
    elseif (mapMatrix(newPos(1),newPos(2)) == 1)
        extended = 0;
    else
        extended = newPos;
    end
    
end

%% ADD NODE FUNCTION
function pathTree = AddNode(pathTree, extended, parentNodeID)
    % Get the length of the tree
    tlength = length(pathTree);
    
    % Add new element to the tree
    pathTree(tlength+1).x = extended(1);
    pathTree(tlength+1).y = extended(2);
    pathTree(tlength+1).parent = parentNodeID;
    
end
    