function avgDist = calculateMinimumDistancePoints( meanValueArray )
    DISTANCE_RATIO = 0.25;
    
    [ TMPpeakY, TMPpeakX ] = findpeaks( meanValueArray ); 
    countMaxima = numel( TMPpeakX );
    for ii = 1 : countMaxima
        if ii ~= countMaxima
           MinPeakDistanceAVG( ii ) = TMPpeakX( ii + 1 ) - TMPpeakX( ii );
        end
    end
    avgDist = mean2( MinPeakDistanceAVG ) * DISTANCE_RATIO;
end
