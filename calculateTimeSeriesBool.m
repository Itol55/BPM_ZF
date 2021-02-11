function [ timeSeriesErrorBool, averageDisctanceTab, ...
    averageDisctanceUpperError, averageDisctancelowerError ] = ...
    calculateTimeSeriesBool( countMaxima, peakX, timeSeriesError ) ...
    
    timeSeriesErrorBool = false; 
    for ii = 1 : countMaxima
        if ii ~= countMaxima
           peakDistance( ii ) = peakX( ii + 1 ) - peakX( ii );
        end
    end

    averageDisctance = mean2( peakDistance );

    averageDisctanceTab = [];
    averageDisctanceUpperError = [];
    averageDisctancelowerError = [];
    for ii = 1:numel( peakDistance )
        averageDisctanceTab(ii) = averageDisctance;
        averageDisctanceUpperError(ii) = averageDisctance * ( 100 + ...
            timeSeriesError ) / 100;
        averageDisctancelowerError(ii) = averageDisctance * ( 100 - ...
            timeSeriesError ) / 100;

        if ( averageDisctanceUpperError(1) < peakDistance(ii) ) | ...
                ( averageDisctancelowerError > peakDistance(ii) )
            timeSeriesErrorBool = true;
        end
    end
end

