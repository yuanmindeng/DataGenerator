classdef NeoHModel
    
    properties
        mu,lambda,Psi,F,E,R,I1,I2,I3,J
    end
    
    methods
        function obj = NeoHModel(F,k,v)
            %F: deformation gradient; k:young's modulus; v:Poisson's ratio
            
            
            % set deformation gradient F
            obj.F = F;
            obj.I1 = trace(F'*F);
            obj.I2 = trace((F'*F)^2);
            obj.I3 = det(F'*F);
            obj.J = sqrt(obj.I3);
            % Lame coefficients are computed by young's modulus(k) and 
            % Poisson's ratio(v)
            obj.mu = k/(2*(1+v));
            obj.lambda = k*v/((1+v)*(1-2*v));
            % compute S 

            obj.Psi = obj.mu*(obj.I1-log(obj.I3)-3)/2+...
                      +obj.lambda*(log(obj.I3)^2)/8;
        end
        function P = computeP(obj)
            P = obj.mu*obj.F-obj.mu*(inv(obj.F'))+...
                +(obj.lambda*log(obj.I3)/2)*(inv(obj.F'));
           %P = obj.mu*(obj.F-obj.mu*(inv(obj.F')))+obj.lambda*log(obj.J)*(inv(obj.F'));
           
        end
      
    end
    
end

