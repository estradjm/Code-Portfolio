%Digital Image Processing

%%
%Excercise: Write Matlab code to convolve an input image with a Gaussian
%kernel. The standard deviation should be an allowable input.
sigma=input('Please input the value of sigma:');
my_image=imread('image.jpg');
my_image = double(my_image);
my_image = mean(my_image,3);


%testing random values for x and y interval:
len = ceil(sqrt(-log(1e-6*2*pi*sigma^2)*2*sigma^2));
[X, Y] = meshgrid(-len:len, -len:len);
%solve for x in inequality of kernal equation to determine dependence of 
%sigma and which to set to zero in Kernel. 10^(-6).
Ker = (1/(2*pi*sigma^2))*exp((-X.^2-Y.^2)/(2*sigma^2));

%   Extend the input image using reflective boundary conditions
[rows, cols] = size(my_image);
ex_image = zeros(rows+2*len, cols+2*len);
ex_image(len+1:(len+rows), len+1:(len+cols)) = my_image;
ex_image([1:len], :) = ex_image([2*len:-1:(len+1)], :); %Fill "top slot"
ex_image([(end-len+1):end], :) = ex_image([end-len:-1:(end-2*len+1)], :);  %Fill "bottom slot"

ex_image(:, [1:len]) = ex_image(:, [2*len:-1:(len+1)]); %Fill "left slot"
ex_image(:, [(end-len+1):end]) = ex_image(:, [end-len:-1:(end-2*len+1)]);  %Fill "right slot"

%   Now actually perform the convolution to do the blurring
Blurred_Image=conv2(ex_image,Ker,'same');

%   Take the interior part of the image (i.e. the stuff that corresponds to
%   the "not-extended" image)
bimage = Blurred_Image(len+1:(len+rows), len+1:(len+cols));

%   Plot the images together
subplot(1,2,1);
colormap(gray);
imagesc(my_image);
subplot(1,2,2);
colormap(gray);
imagesc(Blurred_Image);

%imwrite(Blurred_Image);
%%
%Blurring using the Heat Equation as an iterative process

iterations=input('Number of iterations: ');
current_iteration=0;
while current_iteration~=iterations;
    %Code for Heat equation and blurring using same code as before
    % sigma=input('Please input the size of the mask:');
my_image=imread('image.jpg');
my_image = double(my_image);
my_image = mean(my_image,3);

%testing random values for x and y interval:
len = ceil(sqrt(-log(1e-6*2*pi*sigma^2)*2*sigma^2));
[X, Y] = meshgrid(-len:len, -len:len);
[rows, cols] = size(my_image);
out2=0; %Calculation of derivatives //NEEDS MODIFICATION
for i=2:(length(rows)+1)
    m1=cols(i)-cols(i-1);
    m2=cols(i-1)-cols(i-2);
    deltau=00; %NEED MODIFICATION
    deltay=m2-m1;
    deltax=(rows(i)-rows(i-1)).^2;
    out2(i)=deltau./deltax;
    out1(i)=deltau./deltay;
end
xdoubleprime=out1;
ydoubleprime=out2;
Ker = k.*(ydoubleprime+xdoubleprime); %NUMERICAL HEAT EQUATION KERNEL (SECOND PARTIAL DERIVATIVE)
%QUESTION: What is the value of k or how is it determined?

%   Extend the input image using reflective boundary conditions

ex_image = zeros(rows+2*len, cols+2*len);
ex_image(len+1:(len+rows), len+1:(len+cols)) = my_image;
ex_image([1:len], :) = ex_image([2*len:-1:(len+1)], :); %Fill "top slot"
ex_image([(end-len+1):end], :) = ex_image([end-len:-1:(end-2*len+1)], :);  %Fill "bottom slot"

ex_image(:, [1:len]) = ex_image(:, [2*len:-1:(len+1)]); %Fill "left slot"
ex_image(:, [(end-len+1):end]) = ex_image(:, [end-len:-1:(end-2*len+1)]);  %Fill "right slot"

%   Now actually perform the convolution to do the blurring
Blurred_Image=conv2(ex_image,Ker,'same');

%   Take the interior part of the image (i.e. the stuff that corresponds to
%   the "not-extended" image)
bimage = Blurred_Image(len+1:(len+rows), len+1:(len+cols));

%   Plot the images together
subplot(1,2,1);
colormap(gray);
imagesc(my_image);
subplot(1,2,2);
colormap(gray);
imagesc(Blurred_Image);
    %End of reuse of old code
    
    current_iteration=current_iteration +1;
end
