function meanValueArray = averageValuePixelArray( videoFrameCell, frames, cropX, cropY, cropLengthX, cropLengthY )
    meanValueArrayTMP = [];
    for ii = 1 : frames
        videoFrame = videoFrameCell{ ii };
        greenChannel = videoFrame( :, :, 2 );
        greenChannelCropped = imcrop( greenChannel,[ cropX cropY cropLengthX cropLengthY ] );
        meanValueArray( ii + 1 ) = mean2( greenChannelCropped );
        meanValueArrayTMP( ii ) = mean2( greenChannelCropped );
    end

    averagePeakHeight = mean2( meanValueArrayTMP );
    meanValueArray( 1 ) = averagePeakHeight;
    meanValueArray( frames + 1 ) = averagePeakHeight;
end