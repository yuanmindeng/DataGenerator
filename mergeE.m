% 5-EBNN-far Young's Modulus
E = [10000,500000,1000000];
k = E(1,1);
numE = size(E,2);
fhat = load(strcat('./train/',int2str(k),'/neoH/Out_F_hat.txt'));
phat = load(strcat('./train/',int2str(k),'/neoH/Out_P_hat_neoH.txt'));
NUM = size(fhat,1);
input_merge = zeros(NUM*numE,4);
target_merge = zeros(NUM*numE,3);

input_merge(1:NUM,:) = fhat;
target_merge(1:NUM,:) = phat;
for i = 2:numE
    k = E(1,i);
    fhat = load(strcat('./train/',int2str(k),'/neoH/Out_F_hat.txt'));
    phat = load(strcat('./train/',int2str(k),'/neoH/Out_P_hat_neoH.txt'));
    input_merge((i-1)*NUM+1:i*NUM,:) = fhat;
    target_merge((i-1)*NUM+1:i*NUM,:) =phat;
end

E = input_merge(:,4);
fhat = input_merge(:,1:3);
phat = target_merge;

fhat_range = max(max(fhat))-min(min(fhat));
phat_range = max(max(fhat))-min(min(phat));

E_range = 1000000 - 10000;
E  = E/E_range;
fhat_scale = fhat/fhat_range;
phat_scale = phat/phat_range;
fhat_scale = [fhat_scale E];

scaleVar = [fhat_range phat_range E_range];

if ~exist('./5-EBNN-far/neoH')
	mkdir('./5-EBNN-far/neoH');
end


save('./5-EBNN-far/neoH/fhat-scale-train.txt','fhat_scale','-ascii');
save('./5-EBNN-far/neoH/phat-scale-train.txt','phat_scale','-ascii');
save('./5-EBNN-far/neoH/E-train.txt','E','-ascii');
save('./5-EBNN-far/neoH/scaleVar-train.txt','scaleVar','-ascii');