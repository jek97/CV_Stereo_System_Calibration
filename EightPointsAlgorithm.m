function [F] = EightPointsAlgorithm(P1, P2)

% Build the constraint matrix A
for i = 1 : size(P1, 2)
    x1 = P1(1,i);
    y1 = P1(2,i);
    x2 = P2(1,i);
    y2 = P2(2,i);
    A(i,:) = [x1*x2 y1*x2 x2 x1*y2 y1*y2 y2 x1 y1 1];
end

% Compute the SVD of A, and obtain F:
[U,D,V] = svd(A);
f = V(:,end);
F = reshape(f, [3,3]);

% Force the rank(F)=2 and compute the final F:
[U,D,V] = svd(F');
D(3,3) = 0;
F = U*D*V';
end