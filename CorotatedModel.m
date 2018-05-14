classdef CorotatedModel
    
    properties
        mu,lambda,Psi,F,E,R
    end
    
    methods
        function obj = CorotatedModel(F,k,v)
            %F: deformation gradient; k:young's modulus; v:Poisson's ratio
            
            % set deformation gradient F
            obj.F = F;
            % Lame coefficients are computed by young's modulus(k) and 
            % Poisson's ratio(v)
            obj.mu = k/(2*(1+v));
            obj.lambda = k*v/((1+v)*(1-2*v));
            % compute S 
            [U,Sig,V] = svd(F);
            R = U*V';
            S = V*Sig*V';
            obj.R = R;
            obj.E = (S*S-eye(3))/2;
            obj.Psi = obj.mu*(norm(F-R)^2)+(obj.lambda/2)*(trace(R'*F-eye(3))^2);
        end
        function P = computeP(obj)
            P = 2*obj.mu*(obj.F-obj.R)+...
                +obj.lambda*trace(obj.R'*obj.F-eye(3))*obj.R;
        end
      
    end
    
end

