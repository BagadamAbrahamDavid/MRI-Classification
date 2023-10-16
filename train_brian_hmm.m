clc;
clear all;
close all;
F=dir('normal');
FF=char(F.name);
sz=size(F,1)-2;
FT1=[];
TRGUESS = ones(7,7) * eps;
TRGUESS(7,7) = 1;
for r=1:6
        TRGUESS(r,r) = 0.6;
        TRGUESS(r,r+1) = 0.4;    
end
EMITGUESS = (1/255)*ones(7,255);

%h=waitbar(0,'please wait system is training');
for ss=1:sz
    str=FF(ss+2,:);
    cd normal
    I=imread(str);
    cd ..
I=imresize(I,[256 256]);
if size(I,3)>1
    I=rgb2gray(I);
end
%=========
% % perform Pre processing 
O=skmath(I);
R=uint8(O);
eimg=adapthisteq(R);
figure(1),imshow(eimg,[]);colormap(jet);
F=getframe;
close 
RGB=F.cdata;
[L,NL] = superpixels(RGB,25);
p=1;
for k=1:NL
     t=zeros(size(I));
     for ii=1:size(I,1)
         for jj=1:size(I,2)
             if L(ii,jj)==k
                 t(ii,jj)=1;
             end
         end
     end
     tf=t.*double(R);
     dd=numel(find(tf>5));
     if dd>1000
   %  figure,imshow(tf,[])
     [GLFV,CFV]=my_fvtrvect(tf);
     fv(p,:)=[GLFV CFV];
     p=p+1;
     end     
end

FT1(ss,:)=mean(fv).*1e-1;
lb(ss)=0;
end

aa=ss;
F=dir('abnormal');
FF=char(F.name);
sz=size(F,1)-2;
FT1=[];
for ss=1:sz
    str=FF(ss+2,:);
    cd abnormal
    I=imread(str);
    cd ..
I=imresize(I,[256 256]);
if size(I,3)>1
    I=rgb2gray(I);
end
%=========
% % perform Pre processing 
O=skmath(I);
R=uint8(O);
eimg=adapthisteq(R);
figure(1),imshow(eimg,[]);colormap(jet);
F=getframe;
close 
RGB=F.cdata;
[L,NL] = superpixels(RGB,25);
p=1;
for k=1:NL
     t=zeros(size(I));
     for ii=1:size(I,1)
         for jj=1:size(I,2)
             if L(ii,jj)==k
                 t(ii,jj)=1;
             end
         end
     end
     tf=t.*double(R);
     dd=numel(find(tf>5));
     if dd>1000
   %  figure,imshow(tf,[])
     [GLFV,CFV]=my_fvtrvect(tf);
     fv(p,:)=[GLFV CFV];
     p=p+1;
     end     
end

FT1(aa+1,:)=mean(fv);
lb(aa+1)=1;
aa=aa+1;
end
SS=svmtrain(FT1,lb)    
save SS SS 
