% Input image reading and RGB spectrums reading
inputImage = imread('resized_sunflower_3_x2.jpg');
filters = load('RGB_Filters.mat');
B_filter = filters.RGB_Value(1,:);
G_filter = filters.RGB_Value(2,:);
R_filter = filters.RGB_Value(3,:);

%Converting the input image colours to normalised RGB values
inputImage = double(inputImage)/255;

% Dimensions of the input image
[rows, cols, channels] = size(inputImage);

% Check if the image is RGB
if channels ~= 3
    error('The input image must be an RGB image.');
end

% Initialising the new image with zeros for each channel, which is to
% assign 2x2 subpixels
newRows = rows * 2;
newCols = cols * 2;
bayerImageR = zeros(newRows, newCols);
bayerImageG = zeros(newRows, newCols);
bayerImageB = zeros(newRows, newCols);

% Define the dominance threshold
dominanceThreshold = 1;

% Define the 20 intensity levels (we have to discretion intensity levels)
intensityLevels = linspace(0, 1 , 21);

% Fill the new image with the Bayer RGBG pattern using custom(designed in simulations) filters
for i = 1:rows
    for j = 1:cols
        % Get the RGB values of the current pixel
        R = inputImage(i, j, 1);
        G = inputImage(i, j, 2);
        B = inputImage(i, j, 3);
        
        % Apply the custom filters
        R_filtered = filters.RGB_Value(3,:);
        G_filtered = filters.RGB_Value(2,:);
        B_filtered = filters.RGB_Value(1,:);

        
        

         % Approximate each intensity to the nearest of the 20 levels
        R_filtered = intensityLevels(find(abs(intensityLevels - R) == min(abs(intensityLevels - R)), 1));
        G_filtered = intensityLevels(find(abs(intensityLevels - G) == min(abs(intensityLevels - G)), 1));
        B_filtered = intensityLevels(find(abs(intensityLevels - B) == min(abs(intensityLevels - B)), 1));

        % Calculate the positions in the new image
        new_i = (i - 1) * 2 + 1;
        new_j = (j - 1) * 2 + 1;
        
        % Determine dominance and assign values accordingly
        if R < 0.05 && G < 0.05 && B < 0.05
            % All values are very low, assign black (to reduce writting time)
            bayerImageR(new_i, new_j) = 0;
            bayerImageR(new_i, new_j + 1) = 0;
            bayerImageR(new_i + 1, new_j) = 0;
            bayerImageR(new_i + 1, new_j + 1) = 0;
            bayerImageG(new_i, new_j) = 0;
            bayerImageG(new_i, new_j + 1) = 0;
            bayerImageG(new_i + 1, new_j) = 0;
            bayerImageG(new_i + 1, new_j + 1) = 0;
            bayerImageB(new_i, new_j) = 0;
            bayerImageB(new_i, new_j + 1) = 0;
            bayerImageB(new_i + 1, new_j) = 0;
            bayerImageB(new_i + 1, new_j + 1) = 0;

        else
            % Regular Bayer pattern
            bayerImageR(new_i, new_j) = R_filtered;          % Top-left (Red)
            bayerImageG(new_i, new_j + 1) = G_filtered;      % Top-right (Green)
            bayerImageG(new_i + 1, new_j) =  0;      % Bottom-left (Green)
            bayerImageB(new_i + 1, new_j + 1) = B_filtered;  % Bottom-right (Blue)
        end
    end
end

bayerImageR_Store = double(bayerImageR.*20);
save('bayer_r.mat','bayerImageR_Store');
bayerImageG_Store = bayerImageG.*20;
save('bayer_g.mat','bayerImageG_Store');
bayerImageB_Store = bayerImageB.*20;
save('bayer_b.mat','bayerImageB_Store');

% Normalize the values to fit within the range [0, 255]
bayerImageR = uint8( 255*(bayerImageR));
bayerImageG = uint8(255*(bayerImageG));
bayerImageB = uint8( 255*(bayerImageB));

% Combine the channels into one image
bayerImage = cat(3, bayerImageR, bayerImageG, bayerImageB);

% Display the new Bayer image for verification
imshow(bayerImage);

% Save the new Bayer image
imwrite(bayerImage, 'bayer_image_mapped_newsize_sunflowers_x2.png');


