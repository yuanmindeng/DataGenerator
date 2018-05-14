% data1 = load('./train/1.txt');
% data2 = load('./train/2.txt');
% data3 = load('./train/3.txt');
% 
% data = [data1;data2;data3];
% 
% data = data(:,2:10);
% 
% save ./train/f.txt -ascii data;

%max_threshold = 1.782;
%min_threshold = 0.3587;

data = load('./train/f.txt');

NUM = size(data,1);
% Young's Modulus
E = [700000];

% Possion'r Radio
v = 0.45;
numE = size(E,2);

F_hats = zeros(NUM,3);
Us = zeros(NUM,9);
Vs = zeros(NUM,9);

F = zeros(3,3);

list=zeros(NUM,1);
count = 0;
for i=1:NUM
    F(1,:) = data(i,1:3);
    F(2,:) = data(i,4:6);
    F(3,:) = data(i,7:9);
    [U,F_hat,V] = svd(F);
    F_hats(i,1) = F_hat(1,1);
    F_hats(i,2) = F_hat(2,2);
    F_hats(i,3) = F_hat(3,3);
    Us(i,1:3) = U(1,1:3);   Us(i,4:6) = U(2,1:3);   Us(i,7:9) = U(3,1:3);
    Vs(i,1:3) = V(1,1:3);   Vs(i,4:6) = V(2,1:3);   Vs(i,7:9) = V(3,1:3);
    
    max_fhat = max(F_hats(i,1:3));
    min_fhat = min(F_hats(i,1:3));
	%if max_fhat<max_threshold && min_fhat>min_threshold
    count = count+1; 
    list(count,1)=i;
    %end
end

list = nonzeros(list);
NUM = size(list,1);

Out_P_hat_CLFEM = zeros(NUM,3);
Out_P_hat_neoH = zeros(NUM,3);
Out_P_hat_StVK = zeros(NUM,3);
Out_F_hat = zeros(NUM,3);
Out_Us = zeros(NUM,9);
Out_Vs = zeros(NUM,9);



for i = 1:NUM
   Out_F_hat(i,1:3)  = F_hats(list(i),:);
   Out_Us(i,1:9) = Us(list(i),:);
   Out_Vs(i,1:9)=Vs(list(i),:);
end

U = zeros(3,3);
V = zeros(3,3);
for n = 1:numE
    k = E(1,n);
    for i=1:NUM
        
        
       
        %Out_F_hat(i,4) = k;
        U(1,1:3) = Out_Us(i,1:3);   U(2,1:3) = Out_Us(i,4:6);   U(3,1:3) = Out_Us(i,7:9);
        V(1,1:3) = Out_Vs(i,1:3);   V(2,1:3) = Out_Vs(i,4:6);   V(3,1:3) = Out_Vs(i,7:9);
        
        % StVK Model
        model = StVKModel(F,k,v);
        % P
        P_StVK = model.computeP();
        
        P_hat_StVK = U'*P_StVK*V;
        Out_P_hat_StVK(i,1) = P_hat_StVK(1,1);
        Out_P_hat_StVK(i,2) = P_hat_StVK(2,2);
        Out_P_hat_StVK(i,3) = P_hat_StVK(3,3);
        %Corotated
        model = CorotatedModel(F,k,v);
        P_CLFEM = model.computeP();

        P_hat_CLFEM = U'*P_CLFEM*V;
        Out_P_hat_CLFEM(i,1) = P_hat_CLFEM(1,1);
        Out_P_hat_CLFEM(i,2) = P_hat_CLFEM(2,2);
        Out_P_hat_CLFEM(i,3) = P_hat_CLFEM(3,3);
        % NeoH
        model = NeoHModel(F,k,v);
        P_neoH = model.computeP();
       

        P_hat_neoH = U'*P_neoH*V;
        Out_P_hat_neoH(i,1) = P_hat_neoH(1,1);
        Out_P_hat_neoH(i,2) = P_hat_neoH(2,2);
        
        Out_P_hat_neoH(i,3) = P_hat_neoH(3,3);
        
    end
    

    if ~exist(strcat('./train/',int2str(k),'/neoH'))
        mkdir(strcat('./train/',int2str(k),'/neoH'));
    end
    if ~exist(strcat('./train/',int2str(k),'/CLFEM'))
        mkdir(strcat('./train/',int2str(k),'/CLFEM'));
    end
    if ~exist(strcat('./train/',int2str(k),'/StVK'))
        mkdir(strcat('./train/',int2str(k),'/StVK'));
    end
    
    save(strcat('./train/',int2str(k),'/neoH/Out_F_hat.txt'),'Out_F_hat','-ascii');
    save(strcat('./train/',int2str(k),'/CLFEM/Out_F_hat.txt'),'Out_F_hat','-ascii');
    save(strcat('./train/',int2str(k),'/StVK/Out_F_hat.txt'),'Out_F_hat','-ascii');
    
    save(strcat('./train/',int2str(k),'/neoH/Out_P_hat_neoH.txt'),'Out_P_hat_neoH','-ascii');
    save(strcat('./train/',int2str(k),'/CLFEM/Out_P_hat_CLFEM.txt'),'Out_P_hat_CLFEM','-ascii');
    save(strcat('./train/',int2str(k),'/StVK/Out_P_hat_StVK.txt'),'Out_P_hat_StVK','-ascii');
    
end