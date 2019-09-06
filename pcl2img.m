function I = pcl2img(pcl, ncols, nrows)
%     xq = linspace(0, ncols);
%     yq = linspace(0, nrows);
    [xq, yq] = meshgrid(1:nrows, 1:ncols);
    vq = griddata(pcl.x, pcl.y, double(pcl.val), xq, yq);
    
%     mesh(xq,yq,vq)
%     hold on
%     plot3(pcl.x, pcl.y, pcl.val,'.')
    I = uint16(vq);
end
