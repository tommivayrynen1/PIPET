function f = scroll_channels(raw,lims,varargin)
    
    ognargin = nargin;
    % chan x time
    % ylimits
    % OPTIONAL : second data set to plot of equal size.
    
    f = figure('Position',[523 626 1583 1033]);
    p = uipanel(f,'Position',[0 0 1 0.05]);
    c = uicontrol(p,'Style','slider');    
    c.Position = [500 20 500 20]
    c.Min = 0;c.Max = 1;
    if size(raw,1)==1
        c.SliderStep = [1 1];
    else
        c.SliderStep = [1/(size(raw,1)-1) 1/(size(raw,1)-1)];
    end
    set(c,'Callback',@SliderChangeFunction);
    plot(raw(1,:),'Color','k');ylim(lims);xlim([1 size(raw,2)])
    a=annotation('textbox',[.8 .67 .3 .3],'String',sprintf('Channel: %i / %i',1,size(raw,1)),'FitBoxToText','on');
    if ognargin > 2
        hold on;plot(varargin{1}(1,:),'Color',[.6 .6 .6]);end
    
        function SliderChangeFunction(hObject,eventdata)
          delete(a)
          %latestvalue = event.Value; % Current slider value
          %app.PressureGauge.Value = latestvalue;  % Update gauge   
          slidervalues = linspace(0,1,size(raw,1));
          [~,ind2plot]=min(abs((hObject.Value - slidervalues)));      
          a=annotation('textbox',[.8 .67 .3 .3],'String',sprintf('Channel: %i / %i',ind2plot,size(raw,1)),'FitBoxToText','on');
          cla
          plot(raw(ind2plot,:),'Color','k');ylim(lims);xlim([1 size(raw,2)])
          if ognargin > 2
            hold on;plot(varargin{1}(ind2plot,:),'Color',[.6 .6 .6]);end

        end
    

end