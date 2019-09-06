function I = pcl2img(pcl, ncols, nrows)
    [xq, yq] = meshgrid(1:nrows, 1:ncols);
    vq = griddata(pcl.x, pcl.y, double(pcl.val), xq, yq);
    I = uint16(vq);
%     mesh(xq,yq,vq)
%     hold on
%     plot3(pcl.x, pcl.y, pcl.val,'.')
end
