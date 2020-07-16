function [cas,sl] = fslide_ana_first(fstep,ca,d,tag,tag_cut2,fps,cut_tip,max_type,b_t)
%滑窗平均+预处理
% ca(1).no = 11;
% ca(2).no = 9;
% ca(3).no = 10;
% cell_no = 85;
%tag cut 512 518
%fstep = 3600;
%200ms light 500ms delay 6ms air
ns = fstep;
wd = 1;%1：无滑窗
sl = (wd - 1)/2;
cas = ca;
%tag处理
for k = 1:d
    for r = 1:cas(k).no
        a = ca(k).trial(r).tag;
        switch tag(k).type(r)
            case {2 8}
                tag_cut = tag_cut1;
            case {1 3 4 5 6 7}
                tag_cut = tag_cut2;
        end
        switch tag(k).type(r)
            case {1 2 3 4 5 6}
                for s = 1:fstep
                    if a(s) > tag_cut
                        a(s) = 1;
                    else
                        a(s) = 0;
                    end
                end
            case {7 8}
                for s = 1:fstep
                    if a(s) > tag_cut
                        a(s) = 1;
                    else
                        a(s) = 0;
                    end
                    s = s + round(fps);
                end
        end
        
        cas(k).trial(r).tag_h = a;
    end
end
%滑窗平均
for k = 1:d
    for r = 1:cas(k).no
        u1 = cas(k).trial(r).tag_h;
        du1 = u1(2:ns) - u1(1:ns - 1);
        a1 = find(du1 == 1);
        a2 = find(du1 == -1);
        [~,la1] = size(a1);
        if la1 > 0
            for s = 1:5
                if a1(1) < cut_tip
                    a1 = a1(2:la1);
                    la1 = la1 - 1;
                end
                if fstep - a1(la1) < cut_tip
                    a1 = a1(1:la1 - 1);
                    la1 = la1 - 1;
                end
            end
        end
        v1 = zeros(1,ns);
        tag_type = zeros(la1,1) + tag(k).type(r);
        for s = 1:la1
            switch tag_type(s)
                case 1
                    la1 = 0;
                case {3 4 5 6}
                    v1(a1(s) + 1) = 1;
                case 2
                    if a1(s) + air_tag_delay > 0 && a1(s) + air_tag_delay < fstep
                        a1(s) = a1(s) + air_tag_delay;
                    end
                    v1(a1(s) + air_tag_delay + 1) = 1;
                case {7 8}
                    if s < la1
                        if a1(s + 1) - a1(s) < fps
                            v1(a1(s) + 1) = 1;
                        else
                            a1 = [a1(1:s-1) a1(s+1:la1)];
                            la1 = la1 - 1;
                        end
                    end
                    if s == la1
                        a1 = a1(1:la1 - 1);
                        la1 = la1 - 1;
                    end
            end
        end
        for s = 1:max_type
            ar(s).data = [];
        end
        if la1 == 0
            sd = round(1.2*b_t);
            for s = cut_tip:fstep - cut_tip
                if sum(v1(s - sd:s + sd)) == 0
                    ar(1).data = [ar(1).data, s];
                    v1(s) = 3;
                else
                    for t = s - sd:s + sd
                        if v1(t) > 0
                            s = t + sd;%算法没有问题
                            break;
                        end
                    end
                end
            end
        end
        cas(k).trial(r).tag = v1;
        for s = 1:la1
            s1 = tag_type(s);
            switch s1
                case {2 3 4 5 6 7 8}
                    ar(s1).data = [ar(s1).data, a1(s)];
            end
        end
        %tag: v a r vr ar b
        %type 3 4 2 5  6  1
        cas(k).trial(r).tag_r_no = ar(2).data;
        cas(k).trial(r).tag_v_no = ar(3).data;
        cas(k).trial(r).tag_a_no = ar(4).data;
        cas(k).trial(r).tag_vr_no = ar(5).data;
        cas(k).trial(r).tag_ar_no = ar(6).data;
        cas(k).trial(r).tag_vv_no = ar(7).data;
        cas(k).trial(r).tag_va_no = ar(8).data;
        cas(k).trial(r).tag_b_no = ar(1).data;
    end
end
for k = 1:d
    for r = 1:cas(k).no
        for s = 1:5
            switch s
                case 1
                 tg1 = cas(k).trial(r).tag_r_no;
                case 2
                 tg1 = cas(k).trial(r).tag_v_no;
                case 3
                 tg1 = cas(k).trial(r).tag_vr_no;
                case 4
                 tg1 = cas(k).trial(r).tag_vv_no;
                case 5
                 tg1 = cas(k).trial(r).tag_b_no;
            end
            if numel(tg1) > 0
                break;
            end
        end
        cas(k).trial(r).tag_sum = numel(tg1);
    end
end