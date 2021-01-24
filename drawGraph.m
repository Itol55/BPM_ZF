function drawGraph( frames, meanValueArray, peakX, peakY, miniX, miniY, frameRate, peakDistance, averageDisctanceTab, averageDisctanceUpperError, averageDisctancelowerError, timeSeriesError, BPM )
    subplot(1,4,[1,2]);
    plot( 1 : ( frames + 1) , meanValueArray, 'r', peakX, peakY, 'bo', miniX, miniY, 'b*' )
    set( gca, 'xticklabel' ,arrayfun( @num2str, get( gca,'xtick' )*( 1 / frameRate ), 'un', 0 ) )
    textStr{ 1 } = [ 'Heart rhythm of the zebrafish embryo (' num2str( BPM, '%0.0f' ) ' BPM)'];
    title( textStr{ 1 } )
    xlabel( 'Time [ s ]' )
    ylabel( 'Pixel value' )

    subplot(1,4,[3,4]);
    plot( 1:numel( peakDistance ), peakDistance, 'b', 1:numel( averageDisctanceTab ), averageDisctanceTab, 'g', 1:numel( averageDisctanceUpperError ), averageDisctanceUpperError, 'r', 1:numel( averageDisctancelowerError ), averageDisctancelowerError, 'r' )
    set( gca, 'yticklabel' ,arrayfun( @num2str, get( gca,'ytick' )*( 1 / frameRate ), 'un', 0 ) )
    xlabel( 'Heart beat [ No ]' )
    ylabel( 'Time between beats [ s ]' )
    xlim([1,inf])
    textStr{ 2 } = [ 'Time series stationarity  (acceptability ' num2str( timeSeriesError, '%0.0f' ) '%)'];
    title( textStr{ 2 } )
end