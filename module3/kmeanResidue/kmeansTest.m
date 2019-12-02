%Correct RSSI value based on distance measurement
rssiCorr=LMSRssiCorr(sqrt(replayData.x.^2+(replayData.z+replayData.zCorr').^2),replayData.rssi);

%Centroid found from previous script
centroid=[203.33 181.78];

%Reshape data so that data can be plotted
[rows,cols]=size(rssiCorr);
rssi=reshape(rssiCorr',[],1);
x=reshape(repmat(replayData.x',rows,1),[],1);
idx=reshape(repmat([1:rows]',1,cols)',[],1);

%Select random starting row for test data
sec=randi([1,rows]);
while true
    if sec+500>rows
        sec=randperm(rows,1);
    else
        break
    end
end

%Get mask of test data
msk1 = idx>=sec & idx<sec+500;

%Plot data
figure(1)
subplot(2,1,1)
c=colorRSSI(rssi,msk1);
scatter(idx(msk1),x(msk1),5,c.color,'filled');
title('RSSI scan'); xlabel('Scan Number'); ylabel('Scan Width(mm)')
colorbar
caxis([c.min,c.max])
grp = getGrp(centroid,rssi(msk1));

% Plot estimate of surface residue
resPercent=sum(grp==1)*100/length(grp);
figure(1)
subplot(2,1,2)
gscatter(idx(msk1),x(msk1),grp)

title(['k-means residue estimate ',num2str(resPercent),'%']); xlabel('Scan Number'); ylabel('Scan Width(mm)')
legend({'Residue','Soil'})

%Function to assign color to value base on rssi
function ret=colorRSSI(rssi,mask)
    localMax=prctile(rssi(mask),95);
    localMin=prctile(rssi(mask),5);

    colScale=255*(1-(localMax-rssi(mask))/(localMax-localMin));
    r=255*(1-(255-colScale)/127.5);r(r<0)=0;
    b=255-r;
    g=255*(1-(127.5-colScale)/127.5); g(g>255)=255;
    color=([r,g,b])./255;
    ret.min=localMin; 
    ret.max=localMax;
    ret.color=color;
end

%Classification based on k-means centroid
function ret=getGrp(centroid,data)
    diff=abs(data-centroid);
    ret=ones(size(data));
    ret(diff(:,1)>diff(:,2))=2; 
end
