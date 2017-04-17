close all;
clear variables;
clc;
warning off; %#ok<WNOFF>

%data=textscan(fid,'%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s');
%fclose(fid);

[t01,t02,t03,t04,t05,t06,t07,t08,t09,t10,t11,t12,t13,t14,t15,t16,t17,t18,t19,t20,t21,t22,t23,t24,t25,t26,t27,t28] =textread('../data/horse-colic.data','%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s');

%bia = cell(1,1);
%biao = [season ,size,speed];
%shu = [mxPH,mnO2,Cl,NO3,NH4,oPO4,PO4,Chla,a1,a2,a3,a4,a5,a6,a7];
all =[t01,t02,t03,t04,t05,t06,t07,t08,t09,t10,t11,t12,t13,t14,t15,t16,t17,t18,t19,t20,t21,t22,t23,t24,t25,t26,t27];

%%%%%%%%%%%%%%
% 摘要

%给出标称属性的频数
freSurgery=tabulate(all(:,1));  
freAge=tabulate(all(:,2));
freHospitalNumber=tabulate(all(:,3));

%数值属性
info{1,1}='Info';
info{2,1}='rectal temperature';
info{3,1}='pulse';
info{4,1}='respiratory rate';
info{5,1}='temperature of extremities';
info{6,1}='peripheral pulse';
info{7,1}='mucous membranes';
info{8,1}='capillary refill time';
info{9,1}='pain';
info{10,1}='peristalsis';
info{11,1}='abdominal distension';
info{12,1}='nasogastric tube';
info{13,1}='nasogastric reflux';
info{14,1}='nasogastric reflux PH';
info{15,1}='rectal examination';
info{16,1}='abdomen';
info{17,1}='packed cell volume';
info{18,1}='total protein';
info{19,1}='abdominocentesis appearance';
info{20,1}='abdomcentesis total protein';
info{21,1}='outcome';
info{22,1}='surgical lesion?';
info{23,1}='type of lesion 1';
info{24,1}='type of lesion 2';
info{25,1}='type of lesion 3';

%最大、最小、均值、中位数、四分位数及缺失值
info{1,2}='min';
info{1,3}='q1';
info{1,4}='median';
info{1,5}='mean';
info{1,6}='q3';
info{1,7}='max';
info{1,8}='NA';

%给出最大、最小、均值、中位数、四分位数及缺失值的个数。
[jj,ii]= find(strcmp(all, '?'));   %缺失值位置
for i=1:24   %对于第i个数值属性            
    s= find(ii==(i+3));
    s=jj(s,:);                    %缺失值的行数
    que=length(s);
    for k=1:length(all) 
        Attribute{k,1}=all{k,i+3};    %取出对应样本
    end
    Attribute(s,:)=[];      %令缺失值为空
    for k=1:length(Attribute)
        data(k,1)=str2double(Attribute{k,1});    %得到数值数据
    end
    
    %计算
    maxdata=max(data);
    mindata=min(data);
    meandata = mean(data);
    mediandata=median(data);
    q1data=prctile(data,25);
    q3data=prctile(data,75);
    
    info{i+1,2}=mindata;
    info{i+1,3}=q1data;
    info{i+1,4}=mediandata;
    info{i+1,5}=meandata;
    info{i+1,6}=q3data;
    info{i+1,7}=maxdata;
    info{i+1,8}=que;
end

%%%%%%%%%%%%%%%%%
%   数据缺失的处理

%    将缺失部分剔除
sho = zeros(1,27);
[ii,jj]= find(strcmp(all, '?'));  %(ii-样本数,jj-属性)
A=[ii,jj]; %缺失坐标
d=[ii];
tab = tabulate(A(:,2)); % 缺失属性频数
n=length(tab);
tab= int8(tab(:,1:2));  % 去掉频率
for i = 1:n
    sho(1,tab(i,1))= tab(i,2);  % 缺失值频数
end
all1 =all;  %原始数据集
nm=all(d,:);  %存在缺失数据的数据集
all1(d,:)=[];   %删除缺失数据后的数据集

%    用最高频率值来填补缺失值(不含'?')
freout=cell(27,1);
for j = 1:27  % 列数
    %取样本中无缺失值的部分
    At = all(:,j);
    dr = find(strcmp(At, '?'));
    At(dr) = [];
    tmp = zeros(length(At),1);
    for i = 1:length(At)  % 行数
        tmp(i) = length(find(strcmp(At,At(i))));
    end
    [~, index] = max(tmp,[],1);
    freout(j) = At(index(1,1));
end

all2 = all;
for i = 1:length(A)
    position =A(i,:);
    all2{position(1),position(2)}=freout(position(2),1);    %用最高频率值填补缺失值后的数据集
end


%    通过属性的相关关系来填补缺失值
shu1 = zeros(size(all,1), 26);

for i=1:size(all,1)
    for j=1:26
        shu1(i,j)=str2double(all(i,j));
    end
end

% 相关性矩阵,最后一特征无意义，去掉
relationship = zeros(26,26);   
for i=1:26
    for j=i+1:26
            Column = zeros(size(all,1),2); 
            Column(:,1)=str2double(all(:,i));
            Column(:,2)=str2double(all(:,j));
            [ii,jj]=find(strcmp(all(:,[i,j]),'?'));
            Column(ii,:)=[];
            relationship([i,j],[i,j])=corrcoef(Column);
    end
end

[~,indexm]=sort(relationship,2);


for i=1:length(indexm)
    for j = 1:25
        y=indexm(i,j);
        Column = zeros(size(all,1),2); 
        Column(:,1)=str2double(all(:,i));
        Column(:,2)=str2double(all(:,y));
        [ii,jj]=find(strcmp(all(:,[i,y]),'?'));
        Column(ii,:)=[];
        c1=Column(:,1);
        c2=Column(:,2);
        c2=[ones(length(c2),1),c2];
        [b,~,~,~,~]=regress(c1,c2);
        pra{i,j}=b;
    end
end
%找到相关性最大且存在特征
all3=all;
for i = 1:length(A)
    position =A(i,:);
    for j = 25:-1:1
        k = indexm(position(2),j);
        if k==position(2) || isnan(str2double(all3(position(1),k)))
            continue
        end
        temp = pra{position(2),j}(1,1)+pra{position(2),j}(2,1)*str2double(all3{position(1),k});
        if position(2)~=4 && position(2)~=16 &&position(2)~=19 &&position(2)~=20 &&position(2)~=22
            temp = int8(temp);
        end
        all3{position(1),position(2)}=num2str(temp);    %用属性相关关系填补缺失值后的数据集
        break
    end
end

%    通过数据对象之间的相似性来填补缺失值
all4 = all;
idd=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27];
tab=tabulate(A(:,1));
tab= int16(tab(:,1:2));   % 每一样本缺失值频数
for i=1:length(tab)  % 样本
    num=tab(i,2);  % 频数
    if num==0
        continue;
    end
    index=find(A(:,1)==i);
    index=A(index,2);
    index(find(index<=0))=[];
    value = all(i,:);   % 取出样本i
    for j=1:length(index)
        value{:,index(j)}='0.00000';
    end
    data2 = str2double(all(:,:));
    data2(:,index) = 0;
    for j=1:length(value)
        va(i,j)=str2num(value{1,j});
    end
    dist =pdist2(data2(:,4:27),va(:,4:27));   %去掉标称属性
    [~,in] = sort(dist);
    in=in(1:10,1);
    i
    for j = 1:length(index)
        position(1)=i;
        position(2) = index(j);
        if position(2)<4
            continue
        end
        array=all(in,position(2));
        array(strcmp(array,'?'))=[];
        all4{position(1),position(2)}=num2str(median(str2double(array)));  % 取中位数
    end
end

save('./OmitedData.mat','all1');
save('./FreData.mat','all2');
save('./LinearData.mat','all3');
save('./ObjjectData.mat','all4');



%%%%%%%%%%%%%%%%%%%%
% 可视化
dealD(all1,'将缺失部分剔除');
dealD(all2,'用最高频率值来填补缺失值');
dealD(all3,'通过属性的相关关系来填补缺失值');
dealD(all4,'  通过数据对象之间的相似性来填补缺失值');
