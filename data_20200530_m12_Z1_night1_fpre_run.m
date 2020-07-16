function [nrd_c,Name,TagCode,raw_data,raw_tag] = data_20200530_m12_Z1_night1_fpre_run()
%钙成像数据读入程序
%--------------------------------------------------------%
%请认真阅读使用说明！
%处理多组数据时建议将该文件夹复制多份分别将数据拷入使用。
%联系人：LiuKaiyuan (Guan lab Shanghai Tech)
%--------------------------------------------------------%
%使用方法：
%1.在本程序中设置参数
%2.运行a_pre_run预处理数据
%3.运行a_light_leak处理漏光（如不需要可跳过此步，不建议跳过）
%4.运行a_pre_stats设置统计参数
%5.运行a_stats_anova显示统计结果
mouse_name = 'data_20200530_m12_Z1_night1';%复制.mat之前的文字
single_name = mouse_name(6:end);
data_name = mouse_name(6:13);
load([mouse_name '.mat']);%载入数据
cell_no = 180;%细胞数量
fstep = 1200;%总帧数
fps = 10;%采样频率
d = 1;%总实验数（同天不同实验条件需分开保存）
ca_no = 11;%每次实验trial数（需与d对应）
% load('tag_sum.mat');
eval(['tag_sum = tag_sum_',data_name,';']);

%tag大小
tag_cut1 = 0.5;%小tag判断（大于该值记为小tag）
tag_cut2 = 80;%大tag判断（大于该值记为大tag）

%不需要拆分的block（只有blue_air需要拆分）
base_block = [1,6,11];
base_t = round(fps);
eval(['[tag_sum_',single_name,',',mouse_name,']= tag_sep_time_based2(tag_sum,tag_cut1,base_t,base_block,',mouse_name,');']);


ch_cn = 1:cell_no;
eval(['data1 = ',mouse_name,';']);
raw_d(1).data = data1(:,ch_cn,:);%第一天实验数据保存位置
eval(['tag1 = tag_sum_',single_name,';']);
raw_tag(1).tag = tag1;%第一天tag保存位置
%raw_d(2).data = data_20181019_M3;%第二天实验数据保存位置
%raw_tag(2).tag = Tag_sum_20181019;%第一天tag保存位置
%raw_d(3).data = data_20181018_M3_new;%第三天实验数据保存位置
%raw_tag(3).tag = Tag_sum_20181018;%第一天tag保存位置
%raw_d(4).data = data_20181019_M3;%第四天实验数据保存位置
%raw_tag(4).tag = Tag_sum_20181018;%第一天tag保存位置
raw_t_d = [1];%每次实验对应第几天
%如做了三个实验分别为a,b,c 第一天ab 第二天c 则取[1 1 2];

%记录每个trial实验条件
%如果同一tag类型有多种情况（如blue/red都记为3），则以no区分
tag_multi = 0;%若不使用该功能则将tag_multi参数设置为0
%              1 2 3 4 5 6 7 8 9 0 1 2 3 4 5
tag(1).type = [1,5,3,5,3,1,5,3,5,3,1];
tag(1).t_no = [1,1,1,1,1,1,1,1,1,1,1];
% tag(2).type = [1 3 2 5 3 1];
% tag(2).t_no = [1 1 1 1 1 1];
% tag(3).type = [1 3 3 5 3 2 1];
% tag(3).t_no = [1 1 1 1 1 1 1];
%tag: r v a vr ar b vv va tag类型
%type 2 3 4 5  6  1 7  8
% name(type,t_no) = true name
t_name(1,1).n = 'base';
t_name(2,1).n = 'air';
t_name(3,1).n = 'blue';
t_name(3,2).n = 'yellow';
t_name(3,3).n = 'blue+blue';
t_name(3,4).n = 'blue+yellow';
t_name(3,5).n = 'blue+sound';
t_name(4,1).n = 'auditory';
t_name(5,1).n = 'blue+air';
t_name(6,1).n = 'auditory+air';
t_name(7,1).n = 'blue yellow';
t_name(7,2).n = 'blue blue';
t_name(7,3).n = 'yellow blue';
t_name(7,4).n = 'auditory blue';
t_name(7,5).n = 'blue auditory';
t_name(8,1).n = 'air auditory';
t_name(8,2).n = 'air blue';

%注释：v:visual a:auditory r:air
%vr:visual_air ar:auditory_air
%vv:visual_visual va:visual_auditory
%b:baseline
%下划线_表示延迟一段时间 加号+表示同时
max_type = 8;%总类型数（一般不改）

%r is small tag. air的tag是小tag

%air对应的tag做delay修正
%如light_delay_air,light+delay=0.67ms,fps=30则取delay=-20
air_tag_delay = -2;

%tag大小
tag_cut1 = 0.5;%小tag判断（大于该值记为小tag）
tag_cut2 = 80;%大tag判断（大于该值记为大tag）

%观察范围
t_before = 1;%tag前时间（单位：s）
t_after = 4;%tag后时间（单位：s）

%前后舍弃时间（防止出现tag之后0.5s无数据导致无法观察的情况）
cut_t = 7;%建议至少大于5s

[ca,cut_tip,a_t,b_t,max_t_no] = fload_sort(d,ca_no,tag,cut_t,fps,t_before,t_after,tag_multi,raw_t_d,raw_d,cell_no,raw_tag,fstep);
[cas,sl] = fslide_ana_first(fstep,ca,d,tag,tag_cut2,fps,cut_tip,max_type,b_t);
rd_c = ftag_cell_nomax_f0(d,cas,cell_no,a_t,b_t,max_type,max_t_no,tag,sl);

[~,yr,zr] = size(rd_c);
nrd_c = [];
for k = 1:yr
    for r = 1:zr
        nrd_c{k,r} = rd_c(1,k,r).d;
    end
end

figure;
for k = 1:yr
    subplot(1,yr,k);
    srdc = [];
    for r = 1:zr
        d1 = mean(rd_c(1,k,r).d);
        srdc = [srdc; d1];
    end
    imagesc(srdc);caxis([0 0.2]);
end

Name = [];
TagCode = [];
for k = 1:yr
    Name{k,1} = t_name(tag(1).type(k),tag(1).t_no(k)).n;
    TagCode{k,1} = tag(1).type(k);
    TagCode{k,2} = tag(1).t_no(k);
end

raw_data = raw_d(1).data;
raw_tag = raw_tag(1).tag;
save(['rdc3_' mouse_name '.mat'],'nrd_c','Name','TagCode','raw_data','raw_tag');