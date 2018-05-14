% 6-EFNN-near Young's Modulus
E =10000:30000:100000;
k = E(1,1);
numE = size(E,2);
fhat = load(strcat('./train/',int2str(k),'/neoH/Out_F_hat.txt'));
phat = load(strcat('./train/',int2str(k),'/neoH/Out_P_hat_neoH.txt'));
NUM = size(fhat,1);
input = zeros(NUM*numE,6);
target= zeros(NUM*numE,1);

input(1:NUM,1:6) = [fhat(1:NUM,1:3) phat(1:NUM,:)];
target(1:NUM,:) = fhat(1:NUM,4);

for i = 2:numE
    k = E(1,i);
    fhat = load(strcat('./train/',int2str(k),'/neoH/Out_F_hat.txt'));
    phat = load(strcat('./train/',int2str(k),'/neoH/Out_P_hat_neoH.txt'));
    input((i-1)*NUM+1:i*NUM,1:6) = [fhat(1:NUM,1:3)  phat(1:NUM,:)];
    target((i-1)*NUM+1:i*NUM,:) =fhat(1:NUM,4);
    
end

% 
% 
% scaleVar =load('./6-EFNN/neoH/scaleVar-train.txt');
% input_fhat_range = scaleVar(1);
% input_phat_range= scaleVar(2); 
% target_range= scaleVar(3);




input_fhat = input(:,1:3);
max_fhat = max(max(input_fhat));
min_fhat = min(min(input_fhat));
input_fhat_range = max_fhat-min_fhat;
input_fhat = input_fhat/input_fhat_range;


input_phat = input(:,4:6);
max_phat = max(max(input(:,4:6)));
min_phat = min(min(input(:,4:6)));
input_phat_range =max(max_phat) - min(min_phat);
input_phat = input_phat/input_phat_range;

max_target  = max(target);
min_target = min(target);
target_range = max_target - min_target;
target = target/target_range;


input_scale = [input_fhat input_phat];

target_scale = target;
scaleVar = [input_fhat_range input_phat_range target_range];

if ~exist('./6-EFNN/neoH')
	mkdir('./6-EFNN/neoH');
end


save('./6-EFNN/neoH/input-scale-train.txt','input_scale','-ascii');
save('./6-EFNN/neoH/target-scale-train.txt','target_scale','-ascii');
save('./6-EFNN/neoH/E-train.txt','E','-ascii');
save('./6-EFNN/neoH/scaleVar-train.txt','scaleVar','-ascii');