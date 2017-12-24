% Simply run this script

% Image path
FilterSpec = '*.tif;*.tiff;*.jpg;*.png;*.bmp;*.gif';
DialogTitle = 'Select multiple images to generate mask...';
[FileName,PathName,FilterIndex] = uigetfile(FilterSpec,DialogTitle,'MultiSelect','on');

% Number of images
Nim = numel(FileName);

% Read a sample image
sample = imread(fullfile(PathName,FileName{1}));

% Load the images
rangev = range(1):range(2);
imdb = zeros(size(sample,1),size(sample,2),Nim,'like',sample);
good_im = 0;
tic
for ii = 1:Nim
    if toc > 1
        fprintf('Loading image %d of %d (%s)\n',ii,Nim,FileName{ii}); tic
    end
    % Try to read the image
    try
        img = imread(fullfile(PathName,FileName{ii}));
        % Convert rgb to gray
        if size(img,3) > 1
            img = rgb2gray(img);
        end
        imdb(:,:,ii) = img;
        good_im = good_im+1;
    catch me
        % Skip image if something goes wrong
        fprintf(2,'Skipping image %s because of %s\n',FileName{ii},me.message);
        continue
    end
end

if good_im < 2
    error('You must select at least 2 images to run the script')
end

if good_im < 50
    warning('The number of images selected might be insufficient for the script to work')
end
% Generate the mask showing the debug information
[mask,p] = mask_detect(imdb,1);

% Save the mask
filename = sprintf('mask_%s',FileName{1});
imwrite(mask,filename);
fprintf('The mask file was saved as %s\n',filename);
