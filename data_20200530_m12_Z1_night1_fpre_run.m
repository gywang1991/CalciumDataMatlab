function [nrd_c,Name,TagCode,raw_data,raw_tag] = data_20200530_m12_Z1_night1_fpre_run()
%�Ƴ������ݶ������
%--------------------------------------------------------%
%�������Ķ�ʹ��˵����
%�����������ʱ���齫���ļ��и��ƶ�ݷֱ����ݿ���ʹ�á�
%��ϵ�ˣ�LiuKaiyuan (Guan lab Shanghai Tech)
%--------------------------------------------------------%
%ʹ�÷�����
%1.�ڱ����������ò���
%2.����a_pre_runԤ��������
%3.����a_light_leak����©�⣨�粻��Ҫ�������˲���������������
%4.����a_pre_stats����ͳ�Ʋ���
%5.����a_stats_anova��ʾͳ�ƽ��
mouse_name = 'data_20200530_m12_Z1_night1';%����.mat֮ǰ������
single_name = mouse_name(6:end);
data_name = mouse_name(6:13);
load([mouse_name '.mat']);%��������
cell_no = 180;%ϸ������
fstep = 1200;%��֡��
fps = 10;%����Ƶ��
d = 1;%��ʵ������ͬ�첻ͬʵ��������ֿ����棩
ca_no = 11;%ÿ��ʵ��trial��������d��Ӧ��
% load('tag_sum.mat');
eval(['tag_sum = tag_sum_',data_name,';']);

%tag��С
tag_cut1 = 0.5;%Сtag�жϣ����ڸ�ֵ��ΪСtag��
tag_cut2 = 80;%��tag�жϣ����ڸ�ֵ��Ϊ��tag��

%����Ҫ��ֵ�block��ֻ��blue_air��Ҫ��֣�
base_block = [1,6,11];
base_t = round(fps);
eval(['[tag_sum_',single_name,',',mouse_name,']= tag_sep_time_based2(tag_sum,tag_cut1,base_t,base_block,',mouse_name,');']);


ch_cn = 1:cell_no;
eval(['data1 = ',mouse_name,';']);
raw_d(1).data = data1(:,ch_cn,:);%��һ��ʵ�����ݱ���λ��
eval(['tag1 = tag_sum_',single_name,';']);
raw_tag(1).tag = tag1;%��һ��tag����λ��
%raw_d(2).data = data_20181019_M3;%�ڶ���ʵ�����ݱ���λ��
%raw_tag(2).tag = Tag_sum_20181019;%��һ��tag����λ��
%raw_d(3).data = data_20181018_M3_new;%������ʵ�����ݱ���λ��
%raw_tag(3).tag = Tag_sum_20181018;%��һ��tag����λ��
%raw_d(4).data = data_20181019_M3;%������ʵ�����ݱ���λ��
%raw_tag(4).tag = Tag_sum_20181018;%��һ��tag����λ��
raw_t_d = [1];%ÿ��ʵ���Ӧ�ڼ���
%����������ʵ��ֱ�Ϊa,b,c ��һ��ab �ڶ���c ��ȡ[1 1 2];

%��¼ÿ��trialʵ������
%���ͬһtag�����ж����������blue/red����Ϊ3��������no����
tag_multi = 0;%����ʹ�øù�����tag_multi��������Ϊ0
%              1 2 3 4 5 6 7 8 9 0 1 2 3 4 5
tag(1).type = [1,5,3,5,3,1,5,3,5,3,1];
tag(1).t_no = [1,1,1,1,1,1,1,1,1,1,1];
% tag(2).type = [1 3 2 5 3 1];
% tag(2).t_no = [1 1 1 1 1 1];
% tag(3).type = [1 3 3 5 3 2 1];
% tag(3).t_no = [1 1 1 1 1 1 1];
%tag: r v a vr ar b vv va tag����
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

%ע�ͣ�v:visual a:auditory r:air
%vr:visual_air ar:auditory_air
%vv:visual_visual va:visual_auditory
%b:baseline
%�»���_��ʾ�ӳ�һ��ʱ�� �Ӻ�+��ʾͬʱ
max_type = 8;%����������һ�㲻�ģ�

%r is small tag. air��tag��Сtag

%air��Ӧ��tag��delay����
%��light_delay_air,light+delay=0.67ms,fps=30��ȡdelay=-20
air_tag_delay = -2;

%tag��С
tag_cut1 = 0.5;%Сtag�жϣ����ڸ�ֵ��ΪСtag��
tag_cut2 = 80;%��tag�жϣ����ڸ�ֵ��Ϊ��tag��

%�۲췶Χ
t_before = 1;%tagǰʱ�䣨��λ��s��
t_after = 4;%tag��ʱ�䣨��λ��s��

%ǰ������ʱ�䣨��ֹ����tag֮��0.5s�����ݵ����޷��۲�������
cut_t = 7;%�������ٴ���5s

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