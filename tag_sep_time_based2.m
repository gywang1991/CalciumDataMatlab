function [y,new_data] = tag_sep_time_based2(xx,a2,fps,isbas,data)
% xx为混合tag,a为判断阈值,a1是大标 blue,
% a2 means small tag air,fps为采样频率
[~,~,nx3] = size(xx);
nb = numel(isbas);
kn = 0;
for k = 1:nx3
    kn = kn + 1;
    x = xx(1,:,k);
    x = x - median(x);
    data1 = data(:,:,k);
    r1 = 0;
    for r = 1:nb
        if isbas(r) == kn
            r1 = 1;
            break;
        end
    end
    if k == 1
            y = x;
            new_data = data1;
    else
        if r1 == 1
            y(:,:,end+1) = x;
            new_data(:,:,end+1) = data1;
        else
            kn = kn + 1;
            [y1,y2] = subtag(x,a2,fps);
            y(:,:,end+1) = y1;
            y(:,:,end+1) = y2;
            new_data(:,:,end+1) = data1;
            new_data(:,:,end+1) = data1;
        end
    end
end

end
function [y1,y2]=subtag(x,a2,fps)
n=numel(x);
y1=0*x;
for k=fps+1:n-fps
    if x(k) > a2
        if x(k + 2) > a2 || x(k + 3) > a2
            y1(k-fps:k+fps) = 1;
            k = k + fps;
        end
    end
end
y2=1-y1;

y1=y1.*x;
y2=y2.*x;
end