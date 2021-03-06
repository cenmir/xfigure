function xfigure_KPF(source,event,xfigure_This)
% xfigure_KPF KeyPressCallback_3D
% Used by xfigure

% global xfigure_This
%% modifier
modifier = get(source,'currentModifier');
if isempty(modifier)
    modifier = 0;
end

%% CTRL + R reset axis
if ~isempty(find(strcmp(modifier,'control'),1)) && strcmp(event.Key,'r')
    try
        ch = get(xfigure_This.axes, 'Children');
        if numel(ch) > 0
            xmax = zeros(numel(ch),1);
            ymax = xmax; zmax = ymax; xmin = xmax; ymin = xmax; zmin = zmax;
            
            for i = 1:numel(ch)
                try xd = get(ch(i),'XData'); end
                try yd = get(ch(i),'YData'); end
                try zd = get(ch(i),'ZData'); end
                try
                    xd = xd(:);
                    xmax(i) = max(xd);
                    xmin(i) = min(xd);
                end
                try
                    yd = yd(:);
                    ymax(i) = max(yd);
                    ymin(i) = min(yd);
                end
                try
                    zd = zd(:);
                    zmax(i) = max(zd);
                    zmin(i) = min(zd);
                end
                
            end
            xfigure_This.axis = [xmin, xmax, ymin, ymax, zmin, zmax];
            axis(xfigure_This.axis)
        end
    catch
        zoom reset
        
        try
            set(gca,'Position',xfigure_This.PanStart)
        end
        
    end
    
    view([xfigure_This.azO,xfigure_This.elO] );
    set(xfigure_This.axes,'Position',xfigure_This.axesPosO);
    
end

%% SHIFT + P
if ~isempty(find(strcmp(modifier,'shift'),1))  && strcmp(event.Key,'p')
    WindowPosition = get(xfigure_This.gui,'Position');
    AxisPosition = get(gca,'Position');
    CameraZoom = get(gca,'CameraViewAngle');
    
    [az,el] = view();
    View = [az,el];
    try
        save(xfigure_This.filename, 'WindowPosition', 'View', 'AxisPosition', 'CameraZoom')
        set(xfigure_This.StatusBox, 'String', ['Figure position saved to: ', xfigure_This.filename])
    catch ex
        error(['Error saving figure position.\n',ex.message])
    end

end

%% h - help
if strcmp(event.Key,'h')
    if strcmpi(get(xfigure_This.uiTextHelp,'Visible'),'off')
        set(xfigure_This.uiTextHelp,'Visible','on')
    else
        set(xfigure_This.uiTextHelp,'Visible','off')
    end
end

%% g - grid & axis
if strcmp(event.Key,'g')
    gridf = getappdata(xfigure_This.gui, 'grid');
    if ~isempty(gridf)
        xfigure_This.grid = gridf;
    end
    
    switch mod(xfigure_This.grid,4)
        case 0
            grid(xfigure_This.axes,'On');
            set(gca,'Visible','on')
        case 1
            grid(xfigure_This.axes,'minor');
        case 2
            grid(xfigure_This.axes,'Off');
            %                     set(xfigure_This.axes,'XColor', xfigure_This.bcolor,'YColor', xfigure_This.bcolor, 'ZColor', xfigure_This.bcolor)
        case 3
            grid(xfigure_This.axes,'Off');
            %                     set(xfigure_This.axes,'XColor', 'black','YColor', 'black', 'ZColor', 'black')
            set(gca,'Visible','off')
    end
    xfigure_This.grid = xfigure_This.grid +1;
    setappdata(xfigure_This.gui, 'grid', xfigure_This.grid)
end

%% SHIFT + s - normal to
if ~isempty(find(strcmp(modifier,'shift'),1)) && strcmp(event.Key,'s')
    [xfigure_This.az,xfigure_This.el] = view;
    v = [xfigure_This.az,xfigure_This.el];
    roundTargets = [-360 -270 -180 -90 0 90 180 270 360];
    vRounded = interp1(roundTargets,roundTargets,v,'nearest');
    xfigure_This.az = vRounded(1);
    xfigure_This.el = vRounded(2);
    view([xfigure_This.az, xfigure_This.el]);
%     set(xfigure_This.StatusBox, 'String', ['Az: ',num2str(xfigure_This.az), ' El: ', num2str(xfigure_This.el) ])

end

%%
if strcmpi(event.Key,'numpad4')
    [az,el] = view();
    if ~isempty(find(strcmp(modifier,'control'),1))
        az = az+0.1;
    else
        az = az+5;
    end
    
    view(az,el)
    set(xfigure_This.StatusBox, 'String', ['Az: ',num2str(az), ' El: ', num2str(el) ])
end
if strcmpi(event.Key,'numpad6')
    [az,el] = view();
    if ~isempty(find(strcmp(modifier,'control'),1))
        az = az-0.1;
    else
        az = az-5;
    end
    view(az,el)
    set(xfigure_This.StatusBox, 'String', ['Az: ',num2str(az), ' El: ', num2str(el) ])
end
if strcmpi(event.Key,'numpad8')
    [az,el] = view();
    if ~isempty(find(strcmp(modifier,'control'),1))
        el = el-0.1;
    else
        el = el-5;
    end
    view(az,el)
    set(xfigure_This.StatusBox, 'String', ['Az: ',num2str(az), ' El: ', num2str(el) ])
end
if strcmpi(event.Key,'numpad2')
    [az,el] = view();
    if ~isempty(find(strcmp(modifier,'control'),1))
        el = el+0.1;
    else
        el = el+5;
    end
    view(az,el)
    set(xfigure_This.StatusBox, 'String', ['Az: ',num2str(az), ' El: ', num2str(el) ])
end
if strcmpi(event.Key,'numpad5')
    [az,el] = view();
    v = [az,el];
    roundTargets = [-360 -270 -180 -90 0 90 180 270 360];
    vRounded = interp1(roundTargets,roundTargets,v,'nearest');
    az = vRounded(1);
    el = vRounded(2);
    view([az, el]);
    set(xfigure_This.StatusBox, 'String', ['Az: ',num2str(az), ' El: ', num2str(el) ])
end

