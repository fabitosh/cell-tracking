function pcl = img2pcl(img)
    size_x = size(img, 2);
    size_y = size(img, 1);
    L = size_x * size_y;
    pcl = struct();
    pcl.x = NaN(L, 1);
    pcl.y = NaN(L, 1);
    pcl.val = NaN(L, 1);
    pcl.y = repmat(1:size_y, 1, size_x)';
    xvec = [];
    for ii = 1:1:size_x 
        xvec = [xvec; ones(size_y, 1).*ii];
    end
    pcl.x = xvec;
    pcl.val = img(:);
    %scatter3(pcl.x, pcl.y, pcl.val, pcl.val, pcl.val, '.')
end