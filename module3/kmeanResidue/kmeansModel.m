rssiCorr=LMSRssiCorr(sqrt(replayData.x.^2+(replayData.z+replayData.zCorr').^2),replayData.rssi);
[rows,cols]=size(rssiCorr);
rssi=reshape(rssiCorr',[],1);
[~,centroid ,sumd,D] = kmeans(rssi,2);
