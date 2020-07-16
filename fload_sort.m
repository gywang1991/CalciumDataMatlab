function [ca,cut_tip,a_t,b_t,max_t_no] = fload_sort(d,ca_no,tag,cut_t,fps,t_before,t_after,tag_multi,raw_t_d,raw_d,cell_no,raw_tag,fstep)
%¶ÁÈ¡Êý¾Ý
matno = zeros(1,d);
for k = 1:d
    ca(k).no = ca_no(k);
    matno(k) = max(tag(k).t_no);
end
max_t_no = max(matno);
cut_tip = round(cut_t*fps);
b_t = round(t_after*fps);%after time
a_t = round(t_before*fps) - 1;%before time
if tag_multi == 0
    for k = 1:d
        tag(k).t_no = ones(1,ca_no(k));
    end
end

stn = zeros(1,d);
for k = 1:d
    r1 = raw_t_d(k);
    c1 = stn(r1);
    c2 = ca(k).no;
    trial_d(k).data = raw_d(r1).data(:,1:cell_no,c1 + 1:c1 + c2);
    trial_tag(k).tag = raw_tag(r1).tag(1,:,c1 + 1:c1 + c2);
    stn(r1) = c1 + c2;
end

for s = 1:d
    for k = 1:ca(s).no
        for r = 1:cell_no
            a = zeros(1,fstep);
            a(1,:) = trial_d(s).data(:,r,k);
            ca(s).trial(k).cell(r).data = a;
        end
        b = zeros(1,fstep);
        b(1,:) = trial_tag(s).tag(1,:,k);
        ca(s).trial(k).tag = b;
    end
end

