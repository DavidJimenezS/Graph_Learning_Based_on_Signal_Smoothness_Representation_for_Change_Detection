clc;
clear all;
close all;


%Make sure the GMMSP, the GSPbox, and the Unlocbox toolboxes are in the same folder of the this script (main.m)
% otherwise add them to the path
addpath(genpath(pwd));


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


%% 

dataset = "Gloucester_1_dataset";
%if you want to try your own dataset it must be like:
%   dataset{1} = before; 
%   dataset{2} = after;


params = struct;
params.beforeType = "MS"; 
params.afterType = "MS";
params.Vx = 144;
params.K = 171;
params.Alpha = 0.1;

C = G_SMO_CD(dataset, params);
% If you have a multi-channel images please feed the RGB image to the model
% as follows: C = G_SMO_CD(dataset, params, RGB_before, RGB_after);
% Or if is an heterogeneous case:
% C = G_SMO_CD(dataset, params, [], RGB_after); or C = G_SMO_CD(dataset, params, RGB_before, []);

%% Metrics and error map

%all available datasets has the gt
load(dataset,'gt');

[MA, FA, Precision, recall, kappa, OE] = cohensKappa(gt, C, 1);
