function [cropX, cropY, cropLengthX, cropLengthY ] = determineDataCroppingFrame( firstPointX, firstPointY, secondPointX, secondPointY )
    if firstPointX < secondPointX && firstPointY < secondPointY
        cropX = firstPointX;
        cropY = firstPointY;
        cropLengthX = secondPointX - firstPointX;
        cropLengthY = secondPointY - firstPointY;
    elseif secondPointX < firstPointX && secondPointY < firstPointY
        cropX = secondPointX;
        cropY = secondPointY;
        cropLengthX = firstPointX - secondPointX;
        cropLengthY = firstPointY - secondPointY;
    elseif firstPointX > secondPointX && secondPointY > firstPointY
        cropX = secondPointX;
        cropY = firstPointY;
        cropLengthX = firstPointX - secondPointX;
        cropLengthY = secondPointY - firstPointY;
    else
        cropX = firstPointX;
        cropY = secondPointY;
        cropLengthX = secondPointX - firstPointX;
        cropLengthY = firstPointY - secondPointY;
    end
end