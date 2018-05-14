% 6-EFNN-near Young's Modulus
E =10000:30000:1000000;
k = E(1,1);
numE = size(E,2);
fhat = load(strcat('./test/',int2str(k),'/neoH/Out_F_hat.txt'));
phat = load(strcat('./test/',int2str(k),'/neoH/Out_P_hat_neoH.txt'));
NUM = size(fhat,1);
input = zeros((NUM-1)*numE,12);
target= zeros((NUM-1)*numE,1);

input(1:(NUM-1),1:12) = [fhat(2:NUM,1:3)  phat(2:NUM,:) fhat(1:(NUM-1),1:3) phat(1:(NUM-1),:)];
target(1:(NUM-1),:) = fhat(1:(NUM-1),4);

for i = 2:numE
    k = E(1,i);
    fhat = load(strcat('./test/',int2str(k),'/neoH/Out_F_hat.txt'));
    phat = load(strcat('./test/',int2str(k),'/neoH/Out_P_hat_neoH.txt'));
    input((i-1)*(NUM-1)+1:i*(NUM-1),1:12) = [fhat(2:NUM,1:3)  phat(2:NUM,:) fhat(1:(NUM-1),1:3) phat(1:(NUM-1),:)];
    target((i-1)*(NUM-1)+1:i*(NUM-1),:) =fhat(1:(NUM-1),4);
    
end


scaleVar = load('./6-EFNN/neoH/scaleVar-train.txt');
input_range = scaleVar(1,1);

input_scale = input/input_range;
target_scale = target;
scaleVar = input_range;


if ~exist('./6-EFNN/neoH')
	mkdir('./6-EFNN/neoH');
end


save('./6-EFNN/neoH/input-scale-test.txt','input_scale','-ascii');
save('./6-EFNN/neoH/target-scale-test.txt','target_scale','-ascii');
save('./6-EFNN/neoH/E-test.txt','E','-ascii');
save('./6-EFNN/neoH/scaleVar-test.txt','scaleVar','-ascii');