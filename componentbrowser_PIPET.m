function ic2reject = componentbrowser_PIPET(data)

    addpath(genpath('eeglab14_1_2b'))
    chanlocs = data.chanlocs;
    raw = data.comp.trial{1};

    f = figure('Position',[ 547 584 1851 1139]);
    p = uipanel(f,'Position',[.965 0 0.05 1]);
    c = uicontrol(p,'Style','slider');    
    c.Position = [20 300 20 500]
    c.Min = 0;c.Max = 1;
    
    p2 = uipanel(f,'Position',[0 0 1 0.05]);
    c2 = uicontrol(p2,'Style','slider');    
    c2.Position = [1000 20 500 20]
    c2.Min = 0;c2.Max = 1;
    t = [1:size(raw,2)]./data.fsample;
    
    if size(raw,1)==1
        c.SliderStep = [1 1];
        c2.SliderStep = [1 1];
    else
        c.SliderStep = [1/((size(raw,1)-1)/5) 1/((size(raw,1)-1)/5)];
        c2.SliderStep = [30/((size(raw,2))/data.fsample) 30/((size(raw,2))/data.fsample)];
    end  
    
    set(c,'Callback',@SliderChangeFunction);
    set(c2,'Callback',@SliderChangeFunction2);

    
    for i = 1:5 
        ax1(i)=subplot(5,5,i*5-2:i*5); % PLOT COMPONENT ACTIVATIONS
        lims = [min(raw(i,1:30*data.fsample))-500, max(raw(i,1:30*data.fsample))+500];
        plot(t(1:30*data.fsample),raw(i,1:30*data.fsample),'Color','k');ylim(lims);xlim([0 30]);
        xlabel('time/s')
        
        ax2(i)=subplot(5,5,5*(i-1)+1); % CHANLOCS FROM INITIALIZE VARS? OR INPUT FUNCTION
        topoplot(data.comp.topo(:,i),chanlocs,'electrodes','on','conv','on','numcontour',3,'shading','interp');colorbar
        title(sprintf('IC %i',i));
        
        ax3(i)=subplot(5,5,5*(i-1)+2); %calculate power TODO IN CURRENT EPOCH?
        [p,f]=pspectrum(raw(i,:),data.fsample);
        plot(f,p,'Color','k','LineWidth',2);xlim([0 20]);set(gca,'YScale','log')
        xlabel('Frequency / Hz')

    end
    data.cfg.ind2plot = 1;
    data.cfg.tind2plot = 1;
    
%     prompt = {'Enter components to remove separated with comma'};
%     dlgtitle = 'Channels to remove';
%     definput = {''};
%     dims = [1 35];
%     comp2remove = inputdlg(prompt,dlgtitle,dims,definput);
%     disp(answer)
    
    a=annotation('textbox',[.8 .67 .3 .3],'String',sprintf('Channel: %i / %i',1,size(raw,1)),'FitBoxToText','on');
    ic2reject = input('ICs to reject separated with comma:','s');

    
    
    function SliderChangeFunction(hObject,eventdata)
        delete(a)
        slidervalues = linspace(0,1,size(raw,1));
        [~,ind2plot]=min(abs((hObject.Value - slidervalues)));
        data.cfg.ind2plot = ind2plot;
        a=annotation('textbox',[.8 .67 .3 .3],'String',sprintf('Channel: %i / %i',ind2plot,size(raw,1)),'FitBoxToText','on');
        doPlotting
 
    end
        
    function SliderChangeFunction2(hObject,eventdata)
        
        slidervalues = linspace(0,1,size(raw,2));
        [~,tind2plot]=min(abs((hObject.Value - slidervalues)));
        data.cfg.tind2plot = tind2plot;      
        doPlotting
        
    end
        
    function doPlotting
        
        ind2plot=data.cfg.ind2plot;
        tind2plot=data.cfg.tind2plot;
                
        arrayfun(@(x) cla(x), findall(gcf,'Type','Axes'))
        delete(findall(gcf,'Type','Colorbar'))
        
        for i = 1:5
            lims = [min(raw(ind2plot-1+i,tind2plot:tind2plot+30*data.fsample))-500 max(raw(ind2plot-1+i,tind2plot:tind2plot+30*data.fsample))+500];
            ax1(i)=subplot(5,5,i*5-2:i*5) % PLOT COMPONENT ACTIVATIONS
            plot(t(tind2plot:tind2plot+30*data.fsample),raw(ind2plot-1+i,tind2plot:tind2plot+30*data.fsample),'Color','k');ylim(lims);xlim([t(tind2plot) t(tind2plot+30*data.fsample)])
            xlabel('time/s')
 
            
            ax2(i)=subplot(5,5,5*(i-1)+1); % CHANLOCS FROM INITIALIZE VARS? OR INPUT FUNCTION
            topoplot(data.comp.topo(:,ind2plot-1+i),chanlocs,'electrodes','on','conv','on','numcontour',3,'shading','interp');colorbar
            title(sprintf('IC %i',ind2plot-1+i));
            
            ax3(i)=subplot(5,5,5*(i-1)+2); %calculate power TODO IN CURRENT EPOCH?
            [p,f]=pspectrum(raw(ind2plot-1+i,:),data.fsample);
            plot(f,p,'Color','k','LineWidth',2);xlim([0 20]);set(gca,'YScale','log')
            xlabel('Frequency / Hz')

        end
    end
        
    
    
    
    
    
    

end









