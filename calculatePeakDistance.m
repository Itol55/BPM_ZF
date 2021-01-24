function peakDistance = calculatePeakDistance( countMaxima, peakX )
    for ii = 1 : countMaxima
        if ii ~= countMaxima
           peakDistance( ii ) = peakX( ii + 1 ) - peakX( ii );
        end
    end
end