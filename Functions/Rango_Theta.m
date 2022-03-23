function Theta=Rango_Theta(theta_min_All,theta_max_All)
    ThetasConMedia=sqrt(theta_min_All.*theta_max_All);
    ThetasConMedia(1)=theta_min_All(1)*1.1;
    Theta=[theta_min_All',theta_max_All',ThetasConMedia'];
end