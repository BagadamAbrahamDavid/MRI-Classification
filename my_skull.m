function Rimg=my_skull(I);
SE = strel('octagon',18);
E=imerode(I,SE);
figure;imshow(E,[]);title('eroded image')
E(E~=0)=1;
figure;imshow(E,[]);title('brain selection')
%-------------------------
SE = strel('octagon',18);
D=imdilate(E,SE);
figure;imshow(D,[]);title('dilated image')
F=imfill(D,'holes');
%-------------------------------
Rimg=F.*I;
% F=imresize(F,[181 181]);
% Rimg=imresize(Rimg,[181 181]);
% figure;imshow(I,[]);title('Original image');
% figure;imshow(F,[]);title('Binary  image');
 figure;imshow(Rimg,[]);title('Skull removed  image');
