%Skull Stripping of MRI Brain Images using Mathematical Morphology
function O=skmath(I)
BW=im2double(I);
for ii=1:size(BW,1)
    for jj=1:size(BW,2)
        if (BW(ii,jj)>=0.2) & (BW(ii,jj)<=0.7)
            B(ii,jj)=1;
        else
            B(ii,jj)=0;
        end
    end
end      
th=otsu(I);
Bo=im2bw(im2double(I),(th));
%---------------------------------------------
se=strel('disk',8,8);
M1=imerode(Bo,se);
se=strel('disk',10,6);
M2=imdilate(M1,se);
O=M2.*double(I);
%----------------------------------------
%-----------------------------------------
function th=otsu(imag);
% Reference:Nobuyuki Otsu. A Threshold Selection Method from Gray-Level Histograms.
%   IEEE Transactions on Systems, Man, and Cybernetics. 1979.SMC-9(1):62-66

imag = imag(:, :, 1);

[counts, x] = imhist(imag);                % counts are the histogram. x is the intensity level.

GradeI = length(x);                        % the resolusion of the intensity. i.e. 256 for uint8.

varB = zeros(GradeI, 1);                   % Between-class Variance of binarized image.

prob = counts ./ sum(counts);              % Probability distribution

meanT = 0;  % Total mean level of the picture

for i = 0 : (GradeI-1)
    meanT = meanT + i * prob(i+1);
end
varT = ((x-meanT).^2)' * prob; 

% Initialization

w0 = prob(1);                               % Probability of the first class
miuK = 0;                                   % First-order cumulative moments of the histogram up to the kth level.
varB(1) = 0;

% Between-class variance calculation
for i = 1 : (GradeI-1)
    w0 = w0 + prob(i+1);
    miuK = miuK + i * prob(i+1);
    if (w0 == 0) || (w0 == 1)
        varB(i+1) = 0;
    else
        varB(i+1) = (meanT * w0 - miuK) .^ 2 / (w0 * (1-w0));
    end
end
maxvar = max(varB);
em = maxvar / varT ;
index = find(varB == maxvar);
index = mean(index);
th = (index-1)/(GradeI-1);









