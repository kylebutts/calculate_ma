*! version 0.1


capture program drop calculate_ma
program define calculate_ma
	version 15
	syntax varlist(min=1 max=1 numeric), tau(string) [theta(string) GENerate(string)]
	
	/* Check options */

	/* default for theta */
	if "`theta'" == "" {
		display "Setting theta to 5"
		local theta = 5
	} 
	
	confirm matrix `tau'
	confirm name `generate'
	confirm numeric variable `varlist'

	
	/* Load Data into mata variables */
	disp "Calculating Market Access using"
	disp "Market Size: `varlist'"
	disp "tau: `tau'"
	disp "theta: `theta'"
	
	mata: Y = .
	mata: st_view(Y, .,"`varlist'")
	mata: tau = st_matrix("`tau'")
	mata: theta = `theta'
	
	/* Calculate Market Access */
	mata: ma = calculate_ma(Y, tau, theta)
	
	/* Store results */
	mata: (void) st_store(., st_addvar("float", "`generate'"), ma)
end





capture mata mata drop calculate_ma() normalize()
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
	real scalar Tol, delta, N
	
	Tol = 0.1
	delta = 1
	N = length(Y')
	matemp = J(N,1,1)
	
	/* Initial guess at market access */
	ma_new = rowsum( (tau :^ -theta) :* (J(N, 1, 1) * Y'))
	
	/* Fixed point iteration */
	while( delta > Tol) {
        matemp = normalize(ma_new)
        
		ma_new = rowsum( (tau :^ -theta) :* ( (J(N, 1, 1) * matemp'):^ -1) :* (J(N,1,1) * Y'))
        
        ma_new = normalize(ma_new)
		
		delta = sqrt(sum((ma_new-matemp):^2))
    }
	
	ma = ma_new * 1000
	
	/* returns */
	st_matrix("r(delta)", delta)
	st_matrix("r(ma)", ma)
	
	return(ma)
}

	
	

/* Helper function to normalize vector by L^2 norm */
real vector normalize(real vector v) {
	return(v / sqrt(sum(v :^2)))
}

end
