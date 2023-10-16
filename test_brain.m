clc;
clear all;
close all
D='abnormal';
cd(D)
I=imread('3.jpg');
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
imshow(eimg,[]);colormap(jet);
F=getframe;
RGB=F.cdata;
[L,NL] = superpixels(RGB,25);
figure
BW = boundarymask(L);
imshow(imoverlay(R,BW,'cyan'),'InitialMagnification',67)
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
     figure,imshow(tf,[])
     [GLFV,CFV]=my_fvtrvect(tf);
     fv(p,:)=[GLFV CFV];
     p=p+1;
     end     
end

if strcmp(D,'normal')==1
    FF=mean(fv).*1e-1;
else
    FF=mean(fv);
end
 
load SS
CS=svmclassify(SS,FF)   

                 
     
 
