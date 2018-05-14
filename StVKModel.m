classdef StVKModel
    
    properties
        mu,lambda,Psi,F,E
    end
    
    methods
        function obj = StVKModel(F,k,v)
            %F: deformation gradient; k:young's modulus; v:Poisson's ratio
            
            % set deformation gradient F
            obj.F = F;
            % Lame coefficients are computed by young's modulus(k) and 
            % Poisson's ratio(v)
            obj.mu = k/(2*(1+v));
            obj.lambda = k*v/((1+v)*(1-2*v));
            % compute S 
            %[R,S,V] =  poldecomp(F);
            %A = R'*R;
            obj.E = (F'*F-eye(3))/2;
            temp = obj.E.*obj.E;
            obj.Psi = obj.mu*sum(temp(:))+obj.lambda*(trace(obj.E)^2)/2;
        end
        function P = computeP(obj)
            P = obj.F*(2*obj.mu*obj.E+obj.lambda*trace(obj.E)*eye(3));
        end
      
    end
    
end

