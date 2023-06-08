m = 300; n = 300; % 表示森林的矩阵行列 m x n

Plight = 5e-6;    % 闪电概率
Pgrowth = 1e-2;   % 生长概率

% 邻居方位 d 和点燃概率 p
d = {[1,0], [0,1], [-1,0], [0,-1]}; 
p = [    1,     1,      1,      1];

% % 改进元胞自动机
% d = {[1,0], [0,1], [-1,0], [0,-1], [1,1], [-1,1], [-1,-1], [1,-1]};
% p = [ones(1,4), ones(1,4)*(sqrt(1/2)-1/2)];

% 考虑风的情况
d = {[1,0], [0,1], [-1,0], [0,-1], [1,1], [-1,1], [-1,-1], [1,-1], [0,-2]};
p = [ 0.80,  0.30,   0.80,   1.00,  0.12,   0.12,    0.30,   0.30,    0.8]; 

% 空=0, 火=1, 树=2
E = 0; F = 1; T = 2;

S = T*(rand(m,n)<0.5);

imh = image(cat(3, S==F, S==T, zeros(m,n)));
axis image;

for t = 1:3000

    % 计算邻居中能传播着火的个数
    sum = zeros(size(S));
    for j = 1:length(d)
        sum = sum + p(j) * (circshift(S,d{j})==F);
    end
    
    isE = (S==E); isF = (S==F); isT = (S==T);     % 找出三种不同的状态
    
    ignite = rand(m,n)<sum | (rand(m,n)<Plight);  % 着火条件
    
    % 规则 1: 着火
    Rule1 = T*(isT & ~ignite) + F*(isT & ignite);
    % 规则 2: 烧尽
    Rule2 = F*isF - F*isF;
    % 规则 3: 新生
    Rule3 = T*(isE & rand(m,n)<Pgrowth);
    
    S = Rule1 + Rule2 + Rule3;

    set(imh, 'cdata', cat(3, isF, isT, zeros(m,n)) )
    drawnow
end
