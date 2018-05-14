% 5-EBNN-far Young's Modulus
E = [10000,500000,1000000];

k = E(1,1);
numE = size(E,2);
fhat = load(strcat('./test/',int2str(k),'/neoH/Out_F_hat.txt'));
phat = load(strcat('./test/',int2str(k),'/neoH/Out_P_hat_neoH.txt'));
NUM = size(fhat,1);
input_merge = zeros(NUM*numE,4);
target_merge = zeros(NUM*numE,3);

input_merge(1:NUM,:) = fhat;
target_merge(1:NUM,:) = phat;
for i = 2:numE
    k = E(1,i);
    fhat = load(strcat('./test/',int2str(k),'/neoH/Out_F_hat.txt'));
    phat = load(strcat('./test/',int2str(k),'/neoH/Out_P_hat_neoH.txt'));
    input_merge((i-1)*NUM+1:i*NUM,:) = fhat;
    target_merge((i-1)*NUM+1:i*NUM,:) =phat;
end

E = input_merge(:,4);
fhat = input_merge(:,1:3);
phat = target_merge;
scaleVar = load(strcat('./5-EBNN-far/neoH/scaleVar-train.txt'));

fhat_range = scaleVar(1,1);
phat_range = scaleVar(1,2);
E_range = scaleVar(1,3);

fhat_scale = fhat/fhat_range;
phat_scale = phat/phat_range;
E = E/E_range;

fhat_scale = [fhat_scale E];

scaleVar = [fhat_range phat_range E_range];

all = [fhat_scale phat_scale];
sizeall = size(all, 1);
rowrank = randperm(sizeall); 
newAll = all(rowrank, :);

x = newAll(:,1:4);
y = newAll(:,5:7);

input_scale_validate = x(1:floor(sizeall/2),:);
input_scale_test = x(floor(sizeall/2):sizeall,:);


target_scale_validate = y(1:floor(sizeall/2),:);
target_scale_test = y(floor(sizeall/2):sizeall,:);



if ~exist('./5-EBNN-far/neoH')
	mkdir('./5-EBNN-far/neoH');
end

save('./5-EBNN-far/neoH/fhat-scale-validate.txt','input_scale_validate','-ascii');
save('./5-EBNN-far/neoH/phat-scale-validate.txt','target_scale_validate','-ascii');
save('./5-EBNN-far/neoH/fhat-scale-test.txt','input_scale_test','-ascii');
save('./5-EBNN-far/neoH/phat-scale-test.txt','target_scale_test','-ascii');
save('./5-EBNN-far/neoH/E-test.txt','E','-ascii');
save('./5-EBNN-far/neoH/scaleVar-test.txt','scaleVar','-ascii');