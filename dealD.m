function dealD(all,str)

name{1}='rectal temperature';
name{2}='pulse';
name{3}='respiratory rate';
name{4}='temperature of extremities';
name{5}='peripheral pulse';
name{6}='mucous membranes';
name{7}='capillary refill time';
name{8}='pain';
name{9}='peristalsis';
name{10}='abdominal distension';
name{11}='nasogastric tube';
name{12}='nasogastric reflux';
name{13}='nasogastric reflux PH';
name{14}='rectal examination';
name{15}='abdomen';
name{16}='packed cell volume';
name{17}='total protein';
name{18}='abdominocentesis appearance';
name{19}='abdomcentesis total protein';
name{20}='outcome';
name{21}='surgical lesion';
name{22}='type of lesion 1';
name{23}='type of lesion 2';
name{24}='type of lesion 3';

data=zeros(size(all,1),24);
size(data)
size(all)
for i=1:size(all,1)
    for j=1:24
        data(i,j) = str2double(all{i,j+3});
    end
end

%  绘制直方图，用qq图检验其分布是否为正态分布。
for i=1:24
  fig=figure();
  hist(data(:,i));   
  xlabel(name{i});
  ylabel('Value');
  saveas(fig,['../figure/',num2str(i),'_','hist_',str,'.jpg']);
  fig= figure();
  qqplot(data(:,i));
  xlabel(name{i});
  ylabel('Value');
  saveas(fig,['../figure/',num2str(i),'_','qq_',str,'.jpg']);
end

%  绘制盒图，对离群值进行识别
for i=1:24
   fig= figure();
    boxplot(data(:,i));
    ylabel(name{i})
    saveas(fig,['../figure/',num2str(i),'_','box_',str,'.jpg']);
end

end