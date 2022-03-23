function normalized = normalize_data(data, Type)


if strcmp(Type, 'MS')
    
    channels = size(data, 3);
    
    normalized = data;
    
    for i = 1 : channels
        
        img = normalized(:, :, i);
        normalized(:, :, i) = img./max(img(:));
        
    end
    
else
    
    data(abs(data)<=0) = min(data(abs(data)>0));
    if ~isreal(log(data))
        
        normalized = abs(log(data+1));
    else
        
        normalized = log(data+1);
    end
    
    if max(normalized(:)) == inf
        
        aux = normalized;
        idx = find(normalized == inf);
        aux(idx) = nan;
        normalized(idx) = max(aux(:));
        
        
        clear aux
        
    end
    
    normalized = (normalized - min(normalized(:)))./(max(normalized(:))-min(normalized(:)));
    
end