function avgDist = calculateMinimumDistancePoints( meanValueArray )
    [ TMPpeakY, TMPpeakX ] = findpeaks( meanValueArray ); 
    numberOfElementsMax = size( TMPpeakX );
    countMaxima = numberOfElementsMax( 2 );
    for ii = 1 : countMaxima
        if ii ~= countMaxima
           MinPeakDistanceAVG( ii ) = TMPpeakX( ii + 1 ) - TMPpeakX( ii );
        end
    end
    avgDist = mean2( MinPeakDistanceAVG );
end