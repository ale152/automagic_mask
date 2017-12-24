% Image path
imdir = '\my_image_path\';
imname = 'A_%05d_a.tif';
range = [1 600];

[imdir,imname,range] = read_images(9);

% Number of images
Nim = range(2)-range(1)+1;

% Read a sample image
sample = imread(fullfile(imdir,sprintf(imname,range(1))));

% Load the images
rangev = range(1):range(2);
imdb = zeros(size(sample,1),size(sample,2),Nim,'like',sample);
c = 0; % Just for display
for ri = 1:Nim
    fprintf('%s',repmat(char(8),1,c))
    c = fprintf('Loading image %d of %d (%s)\n',ri,Nim,sprintf(imname,ri));
    imdb(:,:,ri) = imread(fullfile(imdir,sprintf(imname,rangev(ri))));
end

% Generate the mask showing the debug information
[mask,p] = mask_detect(imdb,1);