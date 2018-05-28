function result= binary(bin,num)
mat=zeros(1,num);
for x=1:num
    mat(x)=mod(bin,2);
    bin=floor(bin/2);
end
result=mat;
    
    