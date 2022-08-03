function ind2bad = scroll_artificial_channels(raw,lims,badch)
    
    % chan x time
    % ylimits
    % OPTIONAL : list of bad channels. Are highlighted in red. Can be
    % empty?
    badchanlist = zeros(size(raw,1),1);
    badchanlist(badch)= 1;

    %% Set up uifigure.
    
    f = figure('Position',[523 626 1583 1033]);
    p = uipanel(f,'Position',[0 0 1 0.05]);
    
    
    b = uicontrol(p,'Style','pushbutton');b.Position = [1200 5 120 40];b.String ='E/D'
    set(b,'Callback',@ButtonPush);
    
    c = uicontrol(p,'Style','slider');    
    c.Position = [500 20 500 20]
    c.Min = 0;c.Max = 1;
    if size(raw,1)==1
        c.SliderStep = [1 1];
    else
        c.SliderStep = [1/(size(raw,1)-1) 1/(size(raw,1)-1)];
    end
    set(c,'Callback',@SliderChangeFunction);
    
    if sum(1 == badch) % If first channel is marked bad
        p=plot(raw(1,:),'Color','r');ylim(lims);xlim([1 size(raw,2)]);
        badchanlist(1) = 1;
    else
        p=plot(raw(1,:),'Color','k');ylim(lims);xlim([1 size(raw,2)])
    end
    
    a=annotation('textbox',[.8 .67 .3 .3],'String',sprintf('Channel: %i / %i',1,size(raw,1)),'FitBoxToText','on');
    a2=annotation('textbox',[.01 .67 .3 .3],'String',join(['Bad Channels:',join(strcat('E',string(find(badchanlist)'),','))]),'FitBoxToText','on');
        
    waitfor(f);
    ind2bad = find(badchanlist);
    
    
    function SliderChangeFunction(hObject,eventdata)
        delete(a)
        slidervalues = linspace(0,1,size(raw,1));
        [~,ind2plot]=min(abs((hObject.Value - slidervalues)));
        a=annotation('textbox',[.8 .67 .3 .3],'String',sprintf('Channel: %i / %i',ind2plot,size(raw,1)),'FitBoxToText','on');
        cla
        if sum(ind2plot == badch) % Mark as bad if in list.
            p=plot(raw(ind2plot,:),'Color','r');ylim(lims);xlim([1 size(raw,2)]);
            badchanlist(ind2plot) = 1;
        else
            p=plot(raw(ind2plot,:),'Color','k');ylim(lims);xlim([1 size(raw,2)]);
        end
    end

    % Button push function: change color and enable/disable channel.
    function ButtonPush(hObject,eventdata)
        s=strsplit(a.String,'Channel: ');s=strsplit(s{2},' /');s=str2num(s{1});
        if p.Color == [0 0 0]
            p.Color = [1 0 0];
            badchanlist(s) = 1;
        else
            p.Color = [0 0 0]
            badchanlist(s) = 0;
        end
        delete(a2)
        a2=annotation('textbox',[.01 .67 .3 .3],'String',join(['Bad Channels:',join(strcat('E',string(find(badchanlist)'),','))]),'FitBoxToText','on');
        disp(find(badchanlist))
    end
    
    
end