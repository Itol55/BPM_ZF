function [ cropX, cropY, cropLengthX, cropLengthY, frameHeight, ...
    frameWidth ] =  manualLocateHeart( videoFrameCell )
    
    while true
        videoFrameFindHeart = insertText( videoFrameCell{ 1 }, ...
            [ 1, 1 ], 'Mark 2 points around the heart and press enter' );
        imshow( videoFrameFindHeart )
        [ coordinatesOfHeartX, coordinatesOfHeartY ] = getpts;

        if numel( coordinatesOfHeartX ) ~= 2 && numel( ...
                coordinatesOfHeartY ) ~= 2
            disp( 'There is an invalid number of points' )
            coordinatesOfHeartX = [];
            coordinatesOfHeartY = [];
        else
            frameHeight = size( videoFrameFindHeart, 1);
            frameWidth = size( videoFrameFindHeart, 2);

            % function that checks the location of selected points and, on 
            % their basis calculates the data needed to crop the photo
            [ cropX, cropY, cropLengthX, cropLengthY ] = ...
                determineDataCroppingFrame( coordinatesOfHeartX( 1 ), ...
                coordinatesOfHeartY( 1 ), coordinatesOfHeartX( 2 ), ...
                coordinatesOfHeartY( 2 ) );
            break;
        end
    end
    close;
end