function rd_c = ftag_cell_nomax_f0(d,cas,cell_no,a_t,b_t,...
    max_type,max_t_no,tag,sl)
%tag_c(a,b).data(c,d)
%a:cell_no b:day c:trial d:time
tag_c = [];
rd_c = [];
for k = 1:d
    for r = 1:cas(k).no
        for z = 1:cell_no
            rd_c(k,r,z).d = [];
        end
    end
end
%cell_no = 85;
all_tcg = [];
t_w = a_t + b_t + 1;
for z = 1:cell_no
    no = z;
    for k = 1:d
        tc = [];
        for r = 1:max_type
            for s = 1:max_t_no
                tc(r,s).sm = [];
                tc(r,s).so = [];
                tc(r,s).sor = [];
            end
        end
        for r = 1:cas(k).no
            t_no1 = tag(k).t_no(r);
            tcg(2).v = cas(k).trial(r).tag_r_no;
            tcg(3).v = cas(k).trial(r).tag_v_no;
            tcg(4).v = cas(k).trial(r).tag_a_no;
            tcg(5).v = cas(k).trial(r).tag_vr_no;
            tcg(6).v = cas(k).trial(r).tag_ar_no;
            tcg(7).v = cas(k).trial(r).tag_vv_no;
            tcg(8).v = cas(k).trial(r).tag_va_no;
            tcg(1).v = cas(k).trial(r).tag_b_no;
            for s = 1:max_type
                [~,tcg(s).nv] = size(tcg(s).v);
            end
            for s = 1:max_type
                us = [];
                usr = [];
                um = [];
                if tcg(s).nv > 0
                    for t = 1:tcg(s).nv
                        st = tcg(s).v(t);
                        q = zeros(1,a_t + b_t + 1);
                        q(:) = cas(k).trial(r).cell(no).data(st - sl - a_t:st - sl + b_t);
                        mq = mean(q(1:a_t));
                        q = q - mq;
                        q1 = q/mq;
                        um = [um;mq];
                        us = [us;q1];
                        usr = [usr;q];
                    end
                    rd_c(k,r,z).d = us;
                end
                kk = (k - 1)/d + (r - 1)/cas(k).no/d;
                tc(s,t_no1).sm = [tc(s,t_no1).sm;um];
                tc(s,t_no1).so = [tc(s,t_no1).so;us];
                tc(s,t_no1).sor = [tc(s,t_no1).sor;usr];
            end
        end
        %tag: v a r vr ar vv va b
        %type 3 4 2 5  6  7  8  1
        for r = 1:max_type
            for s = 1:max_t_no
                tag_c(z,k,r,s).m = tc(r,s).sm;
                tag_c(z,k,r,s).rdata = tc(r,s).so;
                tag_c(z,k,r,s).rdatar = tc(r,s).sor;
            end
        end
    end
end
