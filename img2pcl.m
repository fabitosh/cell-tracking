function pcl = img2pcl(img)
    size_x = size(img, 2);
    size_y = size(img, 1);
    L = size_x * size_y;
    pcl = struct();
    pcl.x = NaN(L, 1);
    pcl.y = NaN(L, 1);
    pcl.val = NaN(L, 1);
    pcl.x = repmat(1:size_x, 1, size_y)';
    yvec = [];
    for ii = 1:1:size_y 
        yvec = [yvec; ones(size_x, 1).*ii];
    end
    pcl.y = yvec;
    pcl.val = img(:);
    %scatter3(pcl.x, pcl.y, pcl.val, pcl.val, pcl.val, '.')
end