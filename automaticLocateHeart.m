function [ cropX, cropY, cropLengthX, cropLengthY, frameHeight, ...
    frameWidth ] = automaticLocateHeart( videoFrameCell, ...
    findHeartAutomaticallyMethod, heartArea )
    
    heartLocationTabTMP = cell( [], 1 );

    for ii = 20 : 29
        if ii == 20
            videoFrameFindHeart = videoFrameCell{ ii };
        end
        heartLocationTabTMP{ ii } = imsharpen( imadjust( rgb2gray( ...
            videoFrameCell{ ii } ) ) );
    end
    
    frameHeight = size( videoFrameFindHeart, 1 );
    frameWidth = size( videoFrameFindHeart, 2 );
    
    numberOfAreasToSearch = sqrt( 2500 );
    meanArrayFindHeart = [];

    countIterations = 1;
    countGeneralIterations = 0;
    
    for ii = 20 : 29
        for xx = 1 : numberOfAreasToSearch
            for yy = 1 : numberOfAreasToSearch
                croppedFrameFindHeart = imcrop( ...
                    heartLocationTabTMP{ ii }, ...
                    [ ( ( frameWidth / numberOfAreasToSearch ) *  ...
                    ( yy - 1 ) + 1 ) ( ( frameHeight / ...
                    numberOfAreasToSearch ) * ( xx - 1 ) + 1 ) ...
                    ( frameWidth / numberOfAreasToSearch ) ...
                    ( frameHeight / numberOfAreasToSearch ) ] );
                countIterations = countIterations + 1;
                meanArrayFindHeart( ii - 19, countIterations ) = ...
                    mean2( croppedFrameFindHeart );
                countGeneralIterations = countGeneralIterations + 1;
            end
        end
        countIterations = 1;
    end
    
    countGeneralIterations = countGeneralIterations / 10;

    averagePixelValueChange = [];
    for ii = 1 : countGeneralIterations
        averagePixelValueChange( ii ) = 0;
    end
    
    for ii = 1 : countGeneralIterations
        for jj = 1 : 10
            averagePixelValueChange( ii ) = meanArrayFindHeart( jj, ii) ...
                * ( -1 )^( jj + 1 ) + averagePixelValueChange( ii );
        end
    end
    
    if findHeartAutomaticallyMethod == 1
        findHeartPixelValue = max( averagePixelValueChange( : ) );
    else
        findHeartPixelValue = min( averagePixelValueChange( : ) );
    end
    
    for ii = 1 : countGeneralIterations
        if findHeartPixelValue == averagePixelValueChange( ii )
            loopRotationHeartLocation = ii;
            % returns the remainder after division of a by b, where a is 
            % the dividend and b is the divisor.
            positionInArrayX = rem( loopRotationHeartLocation, ...
                numberOfAreasToSearch );
            positionInArrayY = ( ( loopRotationHeartLocation / ...
                numberOfAreasToSearch ) - ( positionInArrayX / ...
                numberOfAreasToSearch ) ) + 1;
        end
    end
    heartCoordinateXX = ( frameWidth / numberOfAreasToSearch ) * ...
        ( positionInArrayX - 1 ) + 1 + frameWidth / ...
        numberOfAreasToSearch / 2;
    heartCoordinateYY = ( frameHeight / numberOfAreasToSearch ) * ...
    ( positionInArrayY - 1 ) + 1 + frameHeight / numberOfAreasToSearch / 2;
    
    % the value of heartArea is expressed as a percentage (eg. 20), 
    % therefore dividing by 100
    dimensionMarkedAreaFindHeart = floor( heartArea * frameHeight / 100 );
    
    cropX = heartCoordinateXX - ( dimensionMarkedAreaFindHeart / 2 );
    cropY = heartCoordinateYY - ( dimensionMarkedAreaFindHeart / 2 );
    cropLengthX = dimensionMarkedAreaFindHeart;
    cropLengthY = dimensionMarkedAreaFindHeart;    
end