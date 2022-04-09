function Change_Map = G_SMO_CD(dataset, params, RGB_before, RGB_after)

% Graph Learning Based on Signal Smoothness Representation 
% for Homogeneous and Heterogeneous Change Detection
%
% FORMAT Change_map = G_SMO_CD(dataset, params)
%
% INPUTS
% dataset     - Contains an availabla dataset in string format or
%               a cell array with size 2 with before and after images
%
% params      - Parameters used by the algorithm

%               params.beforeType indicates if the image is SAR o MS as a
%               string ("MS" or "SAR") in quotation marks

%               params.afterType indicates if the image is SAR o MS as a
%               string ("MS" or "SAR") in quotation marks

%               params.Vx is an integer value that indicates the Vx and Vy values
%               for the suerpixels in the GMMSP algorithm

%               params.K is an integer value that controls the sparcity in
%               the smothness prior process.

%               params.Alpha controls the influence of the prior in the
%               optimization problem to detect the final change map. It
%               range between 0 and 1.

% RGB_bfore     If your image is MS please feed to the algorithm the RGB images
% RGB_after
%
% OUTPUTS
% Change_map  - Binary image of the change zone detected
%__________________________________________________________________________
% Copyright (C) 2022 Graph Learning Based on Signal Smoothness Representation 
%                    for Homogeneous and Heterogeneous Change Detection
% David Alejandro Jimenez Sierra


%--------------------Available datasets and Parameters---------------------
%       dataset         |    Vx = Vy    |       K       |   Alpha   |
%   Mulargia_dataset    |      11       |      1464     |   0.1     |
%   Omodeo_dataset      |      20       |      174      |   0.109   |
%   Alaska_dataset      |      11       |      1479     |   0.013   |
%   Madeirinha_dataset  |      10       |      410      |   0.2     |
%   Canada_dataset      |      44       |      2400     |   0.1     |
%   Gloucester_1_dataset|      144      |      171      |   0.1     |
%   Katios_dataset      |      23       |      102      |   0.738   |
%   Atlantico_dataset   |      17       |      2029     |   0.103   |
%   SF_dataset          |      16       |      260      |   0.215   |
%   Wenchuan_dataset    |      8        |      1740     |   0.5     |
%   Toulouse_dataset    |      86       |      192      |   0.002   |
%   California_dataset  |      73       |      291      |   0.1     |
%   Bastrop_dataset     |      23       |      393      |   0.1     |
%   Gloucester_2_dataset|      150      |      444      |   0.042   |
%--------------------------------------------------------------------------

%% Validation of inputs
warning off

if isa(dataset,'cell')
    before = dataset{1};
    after = dataset{2};
elseif isa(dataset,'string')
    load(dataset)
else
    msgbox('The dataset must be a cell by 1x2 with before and after images or a string with the name of an available dataset',...
        'Error','Error');
    return;
end

if not(isfield(params, 'Alpha')),   params.Alpha = 0.1;   end

params.beforeType = upper(params.beforeType);
params.afterType = upper(params.afterType);

if ~isa(params.afterType,'string')
     msgbox('The afterType should be a string containing MS or SAR in quotation marks',...
        'Error','Error');
    return;
    
elseif ~isa(params.afterType,'string')
     msgbox('The beforeType should be a string containing MS or SAR in quotation marks',...
        'Error','Error');
    return;
end

if nargin < 3
    
    RGB_before = [];
    RGB_after = [];
    
elseif nargin < 4
    
    RGB_after = [];   
    
end

%% Normalization of the data

%n = num_data(i);

before = im2double(before);
after = im2double(after);

before = normalize_data(before, params.beforeType);
after = normalize_data(after, params.afterType);



if ~isempty(RGB_before) && ~isempty(RGB_after)

    RGB_before_gray = rgb2gray(im2double(RGB_before));
    RGB_after_gray = rgb2gray(im2double(RGB_after));
    
elseif ~isempty(RGB_before) && isempty(RGB_after)
    
    RGB_before_gray = rgb2gray(im2double(RGB_before));
    RGB_after_gray = after;
    
elseif ~isempty(RGB_after) && isempty(RGB_before)
    
    RGB_before_gray = before;
    RGB_after_gray = rgb2gray(im2double(RGB_after));
    
else
    
    RGB_before_gray = before;
    RGB_after_gray = after;
    
end

%% False RGB image

[rowOrg , colOrg, ch] = size(before);
[~ , ~, ch_after] = size(after);

compositive_image = zeros(rowOrg, colOrg, 3);
compositive_image(:,:,1) = RGB_before_gray;
compositive_image(:,:,2) = RGB_after_gray;
compositive_image(:,:,3) = sqrt((RGB_after_gray - RGB_before_gray).^2);
%maxA = max(max(compositive_image));
%compositive_image = (compositive_image./maxA);

img = im2uint8(compositive_image);%uint8(round(compositive_image*255));


label = mx_GMMSP(img, params.Vx);
label = label(:);

NumClases= max(label);

%% Node generation

prior1  = (RGB_before_gray - RGB_after_gray)./((RGB_before_gray + RGB_after_gray));
prior2  = (RGB_after_gray - RGB_before_gray)./((RGB_before_gray + RGB_after_gray));
prior = imbinarize(prior1) + imbinarize(prior2);


feature1 = reshape(before, [rowOrg*colOrg , ch]);
feature2 = reshape(after, [rowOrg*colOrg , ch_after]);
feature3 = prior(:);

region1 = zeros(NumClases, ch);
region2 = zeros(NumClases, ch_after);
region3 = zeros(NumClases, 1);

clear before after prior1 prior2 compositive_image img v_x v_y

for j = 1 : NumClases
    
    tmp = find(label == j);
    
    b1 = feature1(tmp, :);
    b2 = feature2(tmp, :);
    b3 = feature3(tmp);
    
    region1(j, :) = mean(b1, 1);
    region2(j, :) = mean(b2, 1);
    region3(j, :) = mean(b3);
    
end

clear b1 b2 b3 tmp feature1 feature2 feature3
%kuai=dian;
region3 = imbinarize(region3);
prior = region3;
%% Smoothness prior and Graph fusion

nodes = cell(2, 1);
nodes{1} = region1;
nodes{2} = region2;

W = graph_smoothness_fusion(nodes, params.K);

%% Change map detection
D = sum(W,1);
D = diag(D);
L = D - W;
L = (pinv(D^(0.5))*L*pinv(D^(0.5)));
%L = W;


alpha = params.Alpha;
labels = pinv(L + alpha)*alpha*prior;
labels = imbinarize(labels);

%Retrieving the change_map in the original resolution
g = zeros(length(label),1);
number_of_changes = find(labels);
n2 = length(number_of_changes);

for j=1:n2

    %if labels(number_of_changes(j))==1
    g(label == number_of_changes(j))= 1;
    %end

end
%CH=reshape(g,rowOrg,colOrg);
Change_Map = reshape(g,rowOrg,colOrg);
Change_Map = logical(abs(Change_Map));


