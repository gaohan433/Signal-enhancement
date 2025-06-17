function [c1] = rms_contraction_detection(rms_envelope,window,threshold_factor)
    half_window = round(window/2);
    thr = mean(rms_envelope)+threshold_factor*std(rms_envelope);
%     thr = median(rms_envelope)+threshold_factor*iqr(rms_envelope);
%     thr = min(rms_envelope)+0.001*threshold_factor;
    c = rms_envelope>thr;
    c1 = zeros(1,length(c));
    for j = 1:length(c)
        if c(j)==1
            l = max(1,j-half_window);
            r = min(j+half_window,length(c));
            c1(l:r)=1;
        end
    end
end

