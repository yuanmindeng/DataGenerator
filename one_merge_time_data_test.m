% 6-EFNN-near Young's Modulus
E =10000:30000:1000000;
k = E(1,1);
numE = size(E,2);
fhat = load(strcat('./test/',int2str(k),'/neoH/Out_F_hat.txt'));
phat = load(strcat('./test/',int2str(k),'/neoH/Out_P_hat_neoH.txt'));
NUM = size(fhat,1);
input = zeros(NUM*numE,6);
target= zeros(NUM*numE,1);

input(1:NUM,1:6) = [fhat(1:NUM,1:3) phat(1:NUM,:)];
target(1:NUM,:) = fhat(1:NUM,4);

for i = 2:numE
    k = E(1,i);
    fhat = load(strcat('./test/',int2str(k),'/neoH/Out_F_hat.txt'));
    phat = load(strcat('./test/',int2str(k),'/neoH/Out_P_hat_neoH.txt'));
    input((i-1)*NUM+1:i*NUM,1:6) = [fhat(1:NUM,1:3)  phat(1:NUM,:)];
    target((i-1)*NUM+1:i*NUM,:) =fhat(1:NUM,4);
    
end


scaleVar =load('./6-EFNN/neoH/scaleVar-train.txt');
input_fhat_range = scaleVar(1);
input_phat_range= scaleVar(2); 
target_range= scaleVar(3);


input_fhat = input(:,1:3);
input_fhat = input_fhat/input_fhat_range;

input_phat = input(:,4:6);
input_phat = input_phat/input_phat_range;
target = target/target_range;


scaleVar = [input_fhat_range input_phat_range target_range];


input_scale = [input_fhat input_phat];

target_scale = target;



all = [input_scale target_scale];
sizeall = size(all, 1);
rowrank = randperm(sizeall); 
newAll = all(rowrank, :);

x = newAll(:,1:6);
y = newAll(:,7);

input_scale_validate = x(1:floor(sizeall/2),:);
input_scale_test = x(floor(sizeall/2):sizeall,:);


target_scale_validate = y(1:floor(sizeall/2),:);
target_scale_test = y(floor(sizeall/2):sizeall,:);

if ~exist('./6-EFNN/neoH')
	mkdir('./6-EFNN/neoH');
end

save('./6-EFNN/neoH/input-scale-validate.txt','input_scale_validate','-ascii');
save('./6-EFNN/neoH/target-scale-validate.txt','target_scale_validate','-ascii');
save('./6-EFNN/neoH/input-scale-test.txt','input_scale_test','-ascii');
save('./6-EFNN/neoH/target-scale-test.txt','target_scale_test','-ascii');
save('./6-EFNN/neoH/E-test.txt','E','-ascii');
save('./6-EFNN/neoH/scaleVar-test.txt','scaleVar','-ascii');