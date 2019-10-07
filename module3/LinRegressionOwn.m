%Initialize array
dist=repmat([],length(rssiDistData),1);
rssi=repmat([],length(rssiDistData),1);

%Get mean of each data set where incident angle is bewteen 89.5 and 90.5
%and remove outlier from infrared beam reflections at the edge of the test bed.
for i=1:length(rssiDistData)
    mask1=(rssiDistData(i).angle<=90.5 & rssiDistData(i).angle>=89.5);
    mask2=rssiDistData(i).polDist>1000;
    outlierMask=rssiDistData(i).polDist>3500 & rssiDistData(i).rssi>122;
    
    dist(i)=mean(rssiDistData(i).polDist(mask1 & mask2 & ~outlierMask));
    rssi(i)=mean(rssiDistData(i).rssi(mask1 & mask2 & ~outlierMask));
end

dist(isnan(dist))=[];
rssi(isnan(rssi))=[];

%Linear fit
linFit=fitlm(dist,rssi);

%Get confidence interval
CI=coefCI(linFit);
CI_L=CI(2,1)*dist+CI(1,1);
CI_H=CI(2,2)*dist+CI(1,2);

% Plot data, linear fit and confidence interval
figure
scatter(dist,rssi)
hold on
plot(dist,linFit.Fitted)
plot(dist,CI_L, 'g--')
plot(dist,CI_H, 'g--')
xlabel('Distance(mm)')
ylabel('RSSI')
legend({'Data','Linear Fit','95% Confidence Interval'})
title('RSSI vs Distance linear fit')
hold off
