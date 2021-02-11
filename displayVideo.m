function displayVideo( frameRate, videoFrameCell, BPM, frames, ...
    timeSeriesErrorBool, cropX, cropY, cropLengthX, cropLengthY, ...
    frameHeight, heartArea, findHeartAutomatically, depVideoPlayer, ...
    saveVideo, doNotDisplayMedia )
    if doNotDisplayMedia == 0 || saveVideo ~= 0
        if saveVideo ~= 0
            if saveVideo == 2
                path = uigetdir();
                file = 'output.AVI';
                videoFileWriter = VideoWriter( fullfile( path, file ) );
            else
                videoFileWriter = VideoWriter( 'output.AVI' );
            end

        videoFileWriter.Quality = 95;
        videoFileWriter.FrameRate = frameRate;
        open( videoFileWriter );
        end

        text_str = cell( 1, 1 );
        textStr{ 1 } = [ num2str( BPM, '%0.0f' ) ' BPM' ];
        textPosition = 27;

        for ii = 1 : frames
            videoFrameAnimation = videoFrameCell{ ii };

            videoFrameAnimation = insertText( videoFrameAnimation, ...
                [ 1, 1 ], textStr{ 1 } );
            if BPM > 180 || BPM < 120
                videoFrameAnimation = insertText( videoFrameAnimation, ...
                    [ 1, textPosition ], "Abnormal pulse");
                textPosition = textPosition + 26;
            end

            if timeSeriesErrorBool
                videoFrameAnimation = insertText( videoFrameAnimation, ...
                    [ 1, textPosition ], "Time series error");
            end

            if BPM > 180 || BPM < 120
                textPosition = textPosition - 26;
            end

            videoFrameAnimation = insertShape( videoFrameAnimation, ...
                'rectangle', [ cropX, cropY, cropLengthX, ...
                cropLengthY ], 'Color', 'red', 'LineWidth', 2 );
            if findHeartAutomatically == 1
                videoFrameAnimation = insertShape( videoFrameAnimation, ...
                    'circle', [ cropX + heartArea * frameHeight / 200 ...
                    cropY + heartArea * frameHeight / 200 0 ], ...
                    'Color', 'green', 'LineWidth', 3 );
            end
            if saveVideo ~= 0
                writeVideo( videoFileWriter, videoFrameAnimation );
            end
            if doNotDisplayMedia == 0
                depVideoPlayer( videoFrameAnimation );
                pause( 1 / frameRate );
            end
        end
        if saveVideo ~= 0
            close( videoFileWriter );
        end
    end
end