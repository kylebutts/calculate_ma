mata:

/* -----------------------------------------------------------------------------
Calculate market access. Requires three variables:

Inputs: 
  1xn vector Y - measure of market size
  nxn matrix tau - measure of iceberg trade costs
  scalar theta - measure of elasticity of trade with respect to trade costs
  
Output: 
  nx1 vector ma - market access 
  
Description: 
  Our calculation of market access follows Jaworski and Kitchens (2019), the
  equation for MA_c on page 781.
----------------------------------------------------------------------------- */
real vector calculate_ma(real vector Y, real matrix tau, real scalar theta) {
	
	real vector ma, ma_new, matemp
	real scalar Tol, N
	
	Tol = 0.1
	N = length(Y')
	matemp = J(N,1,1)
	
	/* Initial guess at market access */
	ma_new = rowsum( (tau :^ -theta) :* (J(N, 1, 1) * Y'))
	
	/* Fixed point iteration */
	while(sqrt(sum((ma_new-matemp):^2)) > Tol) {
        matemp = normalize(ma_new)
        
		ma_new = rowsum( (tau :^ -theta) :* ( (J(N, 1, 1) * matemp'):^ -1) :* (J(N,1,1) * Y'))
        
        ma_new = normalize(ma_new)
    }
	
	ma = ma_new * 1000
	
	return(ma)
}

/* helper function to normalize vector by L^2 norm */
real vector normalize(real vector v) {
	return(v / sqrt(sum(v :^2)))
}


/* Simple test example */
Y = (1, 2, 1, 1, 1)'
tau = (
	1.0, 1.1, 1.1, 1.1, 1.1 \ 
	1.1, 1.0, 1.1, 1.1, 1.1 \ 
	1.1, 1.1, 1.0, 1.1, 1.1 \ 
	1.1, 1.1, 1.1, 1.0, 1.1 \ 
	1.1, 1.1, 1.1, 1.1, 1.0
)
theta = 5

ma = calculate_ma(Y, tau, theta)
ma


end
