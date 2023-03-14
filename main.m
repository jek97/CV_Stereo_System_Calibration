%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                                            UNIVERSIT DEGLI STUDI DI GENOVA
%                                           COMPUTER VISION: THIRD ASSIGNMENT
%                                                Giacomo Lugano S5400573
%                                              Claudio Tomaiuolo S5630055 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


close all; clear all;


% 1. Load the two sets of corresponding points and arrange them in two matrices P1 and P2 of size 3xN (or Nx3),
% where N is the number of corresponding points. NOTE: the size 3 is because you need to add a final 1 to the
% 2D image coordinates as you will work in homogeneous coordinates 

% Select the algorithm
MyInput = input(['Select the algorithm:\n\n' ...
    '       1 for Mire Eight Points Algorithm without normalization\n' ...
    '       2 for Mire Eight Points Algorithm with normalization\n\n' ...
    '       3 for Rubik Eight Points Algorithm without normalization\n' ...
    '       4 for Rubik Eight Points Algorithm with normalization\n ']);

% Load the two sets of corresponding points according to the selected algorithm
if MyInput == 1 || MyInput == 2 
    P1 = importdata('Mire/Mire1.points');
    P2 = importdata('Mire/Mire2.points');
    Image1 = imread('Mire/Mire1.pgm');
    Image2 = imread('Mire/Mire2.pgm');
elseif MyInput == 3 || MyInput == 4
    P1 = importdata('Rubik/Rubik1.points');
    P2 = importdata('Rubik/Rubik2.points');
    Image1 = imread('Rubik/Rubik1.pgm');
    Image2 = imread('Rubik/Rubik2.pgm');
else
    msg = 'INPUT ERROR.';
    error(msg)
end

P1 = [P1 ones(size(P1,1), 1)];
P2 = [P2 ones(size(P2,1), 1)];


%Trasposition to obtain size 3xN matrix
TP1 = P1';
TP2 = P2';


% 2. Call the function for estimating the fundamental matrix F from P1 and P2

% According to the selected algorithm, it will performe Eight Points
% Algorithm with or without normalization for Mire or Rubik set
if MyInput == 1
    F = EightPointsAlgorithm(TP1, TP2);
    fprintf('Mire Eight Points Algorithm without normalization.\n');
elseif MyInput == 2
    F = EightPointsAlgorithmN(TP1, TP2);
    fprintf('Mire Eight Points Algorithm with normalization.\n');

elseif MyInput == 3
    F = EightPointsAlgorithm(TP1, TP2);
    fprintf('Rubik Eight Points Algorithm without normalization.\n');
else
    F = EightPointsAlgorithmN(TP1, TP2);
    fprintf('Rubik Eight Points Algorithm with normalization.\n');
end

% 3. Visualize the results and evaluate your estimated F

% 3.1 Check the epipolar constraint (x'TFx=0) holds for all points with the estimated F
ep = P2*F*P1';
Ep = abs(sum(sum(ep)));

% 3.2 Visualize the stereo pairs with epipolar lines of the corresponding points

visualizeEpipolarLines(Image1, Image2, F, P1, P2)

% 3.2 evaluate the epipole and determin if it's inside or outside the
% image:
[U, D, V] = svd(F);
eR = U(:,3); % epipole of the right image
eL = V(:,3); % epipole of the left image

eL = eL / eL(3);
x_eL = eL(1); %x-coordinate of the left epipole
y_eL = eL(2); %y-coordinate of the right epipole
if(x_eL > 1 && x_eL < size(Image1,2) && y_eL > 1 && y_eL < size(Image1,1))
  message = sprintf('Left epipole position for left image: \n X: %.2f\n Y: %.2f\n', ...
      x_eL, y_eL);
  msgbox(message); %message for the inside epipole
else
  message = sprintf('Left epipole position is outside left image boundary: \n X: %.2f\n Y: %.2f\n', ...
      x_eL, y_eL);
  msgbox(message); %message for the outside epipole
end

eR = eR / eR(3);
x_eR = eR(1); %x-coordinate of the right epipole
y_eR = eR(2); %y-coordinate of the right epipole
if(x_eR > 1 && x_eR < size(Image2,2) && y_eR > 1 && y_eR < size(Image2,1))
    message = sprintf('Right epipole position for right image: \n X: %.2f\n Y: %.2f\n', ...
      x_eR, y_eR);
    msgbox(message); %message for the inside epipole
else
    message = sprintf('Right epipole position is outside right image boundary: \n X: %.2f\n Y: %.2f\n', ...
      x_eR, y_eR);
    msgbox(message); %message for the outside epipole
end
