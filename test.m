matrix=zeros(63,7);
a=0.7;
count=0;
for x=1:63
    matrix(x,1:6)=binary(x,6);
end

for x=1:63
    res=sum(matrix(x,1:6));
    modul=mod(res,2);
    matrix(x,7)=modul;
end

w_z=-0.5 + 0.5 .*rand(6,6);
w_z_z=-0.5 + 0.5 .*rand(6,6);
w_y=-0.5+ 0.5 .*rand(1,6);
input=zeros(1,6);
hide_la=zeros(1,6);
dz=zeros(1,6);
dzz=zeros(1,6);
hide_la_la=zeros(1,6);
dv=zeros(6,6);
dvv=zeros(6,6);
dw=zeros(1,6);
countn=0;
%netz,nety값 설정
error=1;
while error > 0.1
    error=0;
    count=0;
for x=1:48
    count=count+1;
fprintf('count는%d\n',count);
    d=matrix(x,7);
    
    input=matrix(x,1:6);
    for y=1:6
        Netz=0;
        for z=1:6
        Netz=Netz+input(z)*w_z(y,z);
        end
        hide_la(y)=1/(1+exp(-Netz));
    end
    %Netzz
     for y=1:6
        Netzz=0;
        for z=1:6
        Netzz=Netzz+hide_la(z)*w_z_z(y,z);
        end
        hide_la_la(y)=1/(1+exp(-Netzz));
    end
    %%Nety
    
    Nety=0;
    for y=1:6
    Nety=Nety+w_y(y)*hide_la_la(y);
    end
    out=1/(1+exp(-Nety));
    fprintf('y는 %.4f, 목표치는 %d \n',out,d);
    %%제곱오차
    e=(d-out)*(d-out);
    error=error+e;
    fprintf('오차는 %.4f\n',e);
    %오차신호
    dy=(d-out)*out*(1-out);
    for y=1:6
        dzz(y)=hide_la_la(y)*(1-hide_la_la(y))*dy*w_y(y);
    end
    for z=1:6
        for y=1:6
            dz(y)=hide_la(y)*(1-hide_la(y))*dzz(z)*w_z(z,y);
        end
    end
    %%연경강도 변화량
    for y=1:6
        dw(y)=a*hide_la_la(y)*dy;
    end
     for y=1:6
        for z=1:6
            dvv(y,z)=a*hide_la(z)*dzz(y);
        end
    end
    for y=1:6
        for z=1:6
            dv(y,z)=a*input(z)*dz(y);
        end
    end
    
    for y=1:6
        for z=1:6
            w_z(y,z)=w_z(y,z)+dv(y,z);
        end
    end
    for y=1:6
        for z=1:6
            w_z_z(y,z)=w_z_z(y,z)+dvv(y,z);
        end
    end
    
    for y=1:6
        w_y(y)=w_y(y)+dw(y);
    end
    
    
    

end
fprintf('error는%.4f\n',error);

countn=countn+1;
fprintf('\n////////////////////\n');
fprintf('반복횟수는%d\n',countn);
end
    input_r=zeros(1,6);
for x=49:63
   result=matrix(x,7);
    
    input_r=matrix(x,1:6);
    for y=1:6
        Netz=0;
        for z=1:6
        Netz=Netz+input_r(z)*w_z(y,z);
        end
        hide_la(y)=1/(1+exp(-Netz));
    end
    %Netzz
    for y=1:6
        Netzz=0;
        for z=1:6
        Netzz=Netzz+hide_la(z)*w_z_z(y,z);
        end
        hide_la_la(y)=1/(1+exp(-Netzz));
    end
    %%Nety
    
    Nety=0;
    for y=1:6
    Nety=Nety+w_y(y)*hide_la_la(y);
    end
    out=1/(1+exp(-Nety));
    fprintf('예상값은%.4f,,,, 실제값은 %d \n',out,result);
end
