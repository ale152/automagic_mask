function [mask,p] = mask_detect(imdb,varargin)
%[mask,p] = MASK_DETECT(imdb)
% Detect a mask given the database of images imdb, a 3d matrix formed as:
% imdb = cat(3,image1,image2,image3, ...)
%
% mask = mask_detection(imdb,1) enables the debug mode
% [mask,p] = mask_detection(imdb) returns the probability function

CleanMask = true; % Morphological cleaning of the mask
block_size = 100; % To evaluate statistics in blocks that fit into memory
Nrange = size(imdb,3);
sample = imdb(:,:,1);
if nargin > 1
    debug = true;
else
    debug = false;
end

% Evaluate skewness and kurtosis in blocks
skew = zeros(size(sample));
kurt = zeros(size(sample));
Nblock = ceil(size(sample,2)/block_size);
for i = 1:Nblock
    if debug
        c = fprintf('Block %d of %d',i,Nblock);
    end
    j1 = (i-1)*block_size+1;
    j2 = min(i*block_size,size(sample,2));
    block = double(imdb(:,j1:j2,:));
    
    % Evaluate kurtosis and skeweness
    [kurt(:,j1:j2),skew(:,j1:j2)] = my_stat(block,Nrange);
    if debug
        fprintf('%s',repmat(char(8),1,c))
    end
end

% Pixels with constant intensity present a NaN kurtosis. Those pixels
% should be surely masked out, set the kurtosis to 3 and skewness to 0
kurt(isnan(kurt)) = 3;
skew(isnan(skew)) = 0;
% Evalaute the JB statistic
jbtest = size(imdb,3)/6*(skew.^2 + (kurt-3).^2/4);
% Evaluate the p-value
p = 1-chi2cdf(jbtest,2);

if debug
    figure,imagesc(jbtest),title 'JB statistic'
    figure,imagesc(log(p)),title 'Logarithm of probability'
end

% Median filter the probability
p_flt = medfilt2(p,[5 5],'symmetric');
% Automatic clustering of bg and flow using kmeans
bf = log(p_flt(:));
mi = min(bf(~isinf(abs(bf))));
ma = max(bf(~isinf(abs(bf))));
bf = (bf-mi)/(ma-mi);
[id,cen] = kmeans(bf(:),2);
% Identify kmeans output using the probability
[~,idobj] = max(cen(:,1));
mask = zeros(size(id));
mask(id==idobj) = 1;
mask = reshape(mask,size(p,1),size(p,2));

if debug
    figure,imagesc(mask),title 'Image of the mask'
end

%% Morphological operations
if CleanMask
    mask = bwmorph(mask,'close');
    mask = imfill(mask,'holes');
    Nit = 5;
    % Clean mask from spurious pixels
    mask = bwmorph(mask,'majority',Nit);
end

%% Show image
if debug
    %%
    rgb = zeros(size(imdb,1),size(imdb,2),3);
    im = double(imdb(:,:,1));
    im = adapthisteq(normal(double(im)));
    im = im.^0.7;
    rgb(:,:,1) = im*.6+mask/2;
    rgb(:,:,2) = im*.6;
    rgb(:,:,3) = im*.6;
    
    figure,imshow(rgb)
    title 'Final mask'
end

function [mykurt,mysk] = my_stat(block,N)
s = sum(block,3);
mu = s/N;
sig = bsxfun(@minus,block,mu);
sigsq = sig.^2;
sigcb = sigsq.*sig;
sigsqsq = sigsq.^2;
Esigsq = sum(sigsq,3)/N;
mykurt = sum(sigsqsq,3)/N./(Esigsq).^2;
mysk = sum(sigcb,3)/N./sqrt(Esigsq.^3);

function x = normal(x)
% normalize x
M = max(x(:));
m = min(x(:));
if M-m ~= 0
    x = (x-m)/(M-m);
else
    warning 'Skip normalization, constant value'
end
