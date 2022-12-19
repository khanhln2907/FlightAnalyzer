function out = trans_func()
                  
    out.M_NED_TO_BODY =   ... 
    @(phi,theta,psi) [cos(psi)*cos(theta),                                  sin(psi)*cos(theta),                                -sin(theta);
                      cos(psi)*sin(theta)*sin(phi) - sin(psi)*cos(phi),     sin(psi)*sin(theta)*sin(phi) + cos(psi)*cos(phi),   cos(theta)*sin(phi);
                      cos(psi)*sin(theta)*cos(phi) + sin(psi)*sin(phi),     sin(psi)*sin(theta)*cos(phi) - cos(psi)*sin(phi),   cos(theta)*cos(phi)];

                  
    % Return the function handles
    out.ned_to_body = @(vecNED, attRadVec) out.M_NED_TO_BODY(attRadVec(1), attRadVec(2), attRadVec(3)) * vecNED;
    out.body_to_ned = @(vecBody, phi, theta, psi) out.M_NED_TO_BODY(phi, theta, psi)' * vecBody;
end

