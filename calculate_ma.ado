*! version 0.1


capture program drop calculate_ma
program define calculate_ma
	version 13
	syntax varlist(min=1 max=1 numeric), tau(string) formula(string) [theta(string) GENerate(string)]
	
	/* Check options */

	/* default for theta */
	if "`theta'" == "" {
		display "Setting theta to 5"
		local theta = 5
	} 
	
	confirm matrix `tau'
	confirm name `generate'
	confirm numeric variable `varlist'

	/* 
	if(!("`formula'" == "income" | "`formula'" == "population")) {
		disp "formula must be either income or population"
		exit
	}
	*/
	
	
	/* Display Information */
	local divider = "-"*40 
	disp "`divider'"
	disp "Calculating Market Access using"
	disp "Market Size: `varlist'"
	disp "tau: `tau'"
	disp "theta: `theta'"
	disp "formula: `formula'"
	disp "`divider'"
	disp "Results stored in `generate'"
	disp "`divider'"
	
	
	/* Load Data into mata variables */
	mata: Y = .
	mata: st_view(Y, .,"`varlist'")
	mata: tau = st_matrix("`tau'")
	mata: theta = `theta'
	mata: formula = "`formula'"
	
	/* Calculate Market Access */
	mata: calculate_ma(Y, tau, theta, formula)
	
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
  string formula - which formula for market access should be used
  
Output: 
  nx1 vector ma - market access 
  
Description: 
  Our calculation of market access is determined by *formula*:
  
  income: Jaworski and Kitchens (2019), the equation for MA_c on page 781.
  population: Donaldson and Hornbeck (2016), equation (9)
  simple: Donaldson and Hornbeck (2016), equation (12)
----------------------------------------------------------------------------- */
real vector calculate_ma(real vector Y, real matrix tau, real scalar theta, string scalar formula) {
	
	real vector ma, ma_new, matemp
	real scalar Tol, delta, N
	
	/* Jaworski and Kitchens (2019) */
	if(formula == "income"){
		
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
	}
	/* Equation (9) from Donaldson and Hornbeck (2016) */
	if(formula == "population") {
		
		Tol = 0.1
		delta = 1
		N = length(Y')
		matemp = J(N,1,1)
		
		/* Initial guess at market access */
		ma_new = rowsum( (tau :^ -theta) :* (J(N, 1, 1) * Y'))
		
		/* Fixed point iteration */
		while( delta > Tol) {
			matemp = normalize(ma_new)
			
			ma_new = rowsum( (tau :^ -theta) :* ( (J(N, 1, 1) * matemp'):^ -((1 + theta)/theta)) :* (J(N,1,1) * Y'))
			
			ma_new = normalize(ma_new)
			
			delta = sqrt(sum((ma_new-matemp):^2))
		}
		
		ma = ma_new * 1000
	}
	/* Equation (12) from Donaldson and Hornbeck (2016) */
	if(formula == "simple") {
		delta = 0
		N = length(Y')
		
		ma_new = rowsum( (tau :^ -theta) :* (J(N,1,1) * Y'))
		
		ma_new = normalize(ma_new)
		
		ma = ma_new * 1000
	}
	
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
