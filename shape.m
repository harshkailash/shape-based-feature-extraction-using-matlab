q=imread('D:\18bce1340\TPTest1.png');
q=im2bw(q,graythresh(q));
[B,L]=bwboundaries(q);
figure; imshow(q); hold on;
for k=1:length(B),
    boundary=B{k};
    plot(boundary(:,2),boundary(:,1),'g','LineWidth',2);
end
[L,N]=bwlabel(q);
RGB=label2rgb(L,'hsv',[.5 .5 .5],'shuffle');
figure;imshow(RGB); hold on;
for k=1:length(B)
    boundary=B{k};
    plot(boundary(:,2),boundary(:,1),'w','LineWidth',2);
    text(boundary(1,2)-11,boundary(1,1)+11,num2str(k), 'Color','y','FontSize',14,'Fontweight','bold');
end
Centroid=[];
info_table = cell2table(cell(0,9),'VariableNames',{'Object' 'Area' 'Centroid' 'Orientation' 'Euler_number' 'Eccentricity' 'Aspect_ratio' 'Perimeter' 'Thiness_ratio' });
stats=regionprops(L,'all');
temp=zeros(1,N);
for k=1:N
    area=stats(k,1).Area;
    per=stats(k,1).Perimeter;
    centroid=stats(k,1).Centroid;
    ori=stats(k,1).Orientation;
    en=stats(k,1).EulerNumber;
    ecc=stats(k,1).Eccentricity;
    aspr=(stats(k,1).BoundingBox(3))/(stats(k,1).BoundingBox(4));
    thinr=4*pi*area/(per)^2;
    stats(k).ThinnessRatio=thinr;
    new_row={k,area,centroid,ori,en,ecc,aspr,per,thinr};
    info_table=[info_table;new_row];    
    
end
areas=zeros(1,N);
for k=1:N
    areas(k)=stats(k).Area;
end
TR=zeros(1,N);
for k=1:N
    TR(k)=stats(k).ThinnessRatio;
end
cmap=colormap(lines(16));
for k=1:N
    scatter(areas(k),TR(k),[],cmap(k,:),'filled'),ylabel('Thinness Ratio'),xlabel('Area')
    hold on
end
writetable(info_table,'Shape1-DB.csv');
