function [out bin] = generate_skinmap(I)
%GENERATE_SKINMAP Produce a skinmap of a given image. Highlights patches of
%"skin" like pixels. Can be used in face detection, gesture recognition,
%and other HCI applications.

%   The function reads an image file given by the input parameter string
%   filename, read by the MATLAB function 'imread'.
%   out - contains the skinmap overlayed onto the image with skin pixels
%   marked in blue color.
%   bin - contains the binary skinmap, with skin pixels as '1'.
%
%   Example usage:
%       [out bin] = generate_skinmap('nadal.jpg');
%       generate_skinmap('nadal.jpg');
%
%   Gaurav Jain, 2010.

    I_orig = I;
    img_skin_only = Skin_Detect(I);
    I = Skin_Detect(I);
    
    %Read the image, and capture the dimensions
    img_orig = I;
    height = size(img_orig,1);
    width = size(img_orig,2);
    
    %Initialize the output images
   
    out = I_orig;
    bin = zeros(height,width);
 
    %Mark Skin Pixels
   
    indexes = size(I);
    for i=1:indexes(1)
       for j=1:indexes(2)
           if img_skin_only(i,j,:) ~= [0  0 0]
              out(i,j,:) = [0 0 255];  
              bin(i,j) = 1;
           end
       end
    end


end