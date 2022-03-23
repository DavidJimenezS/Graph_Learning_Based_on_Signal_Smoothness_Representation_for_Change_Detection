function W = graph_smoothness_fusion(data,ksmooth)

wl = cell(2,1);
% regions{1}=region1./max(region1);
% regions{2}=region2./max(region2);
parfor i = 1 : 2
    ZAA = gsp_distanz(data{i}');
    [thetaAA, ~, ~] = gsp_compute_graph_learning_theta(ZAA,ksmooth);
    %Rango_Theta_Pre_Post{i}=Rango_Theta(theta_min_All,theta_max_All);
    [WsmoothAA] = gsp_learn_graph_log_degrees(ZAA*thetaAA,1,1);
    WsmoothAA(WsmoothAA<1e-4) = 0;
    wl{i} = WsmoothAA;
end
%clear Xl Xl_AA
%% Multimodal Weights

%n = length();
W = min(cat(3,wl{1} , wl{2}),[],3);
