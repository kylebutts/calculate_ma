*! version 0.1


capture program drop calculate_ma
program define calculate_ma
	version 13
	syntax varlist(min=1 max=1 numeric), tau(string) formula(string) GENerate(string) [theta(real 0) tradecost(string)]
	
	/* Check options */
	confirm matrix `tau'
	confirm name `generate'
	confirm variable `varlist'
	confirm numeric variable `varlist'

	/* Check formula */
	if(!("`formula'" == "income" | "`formula'" == "population" | "`formula'" == "basic")) {
		disp "formula must be either income, population, or basic. See {stata help calculate_ma:calculate_ma} for details on formula"
		exit
	}

	/* Set defauls for theta */
	if("`tradecost'" == "traveltime" & "`theta'" == "0") {
		/* Page 782 of Jaworski and Kitchens (2019) */
		local theta 8
	}
	if("`tradecost'" == "distance" & "`theta'" == "0") {
		/* Page 19 of Bartelme (2018 Working Paper) */
		local theta 1.01
	}
	if("`tradecost'" == "tau" & "`theta'" == "0") {
		/* Table 3.5 from Head and Mayer (2012) */
		local theta 5.13
	}
	if("`tradecost'" == "" & "`theta'" == "0") {
		disp "Warning: you did not specify the option of tradecost so the elasticity of trade cost, theta, is set to 5. See {stata help calculate_ma:calculate_ma} for details on tradecost"
		local theta 5
	}
	
	
	/* Display Information */
	disp "{hline 59}"
	disp "Calculating Market Access using"
	disp "Market Size: {col 18}{result:`varlist'}"
	disp "tau: {col 18}{result:`tau'}"
	disp "theta: {col 18}{result:`theta'}"
	disp "formula: {col 18}{result:`formula'}"
	disp "{hline 59}"
	disp "Results stored in {result:`generate'}"
	disp "{hline 59}"
	
	
	/* Load Data into mata variables */
	mata: Y = .
	mata: st_view(Y, .,"`varlist'")
	mata: tau = st_matrix("`tau'")
	mata: theta = `theta'
	mata: formula = "`formula'"
	
	/* Calculate Market Access */
	mata: ma = calculate_ma(Y, tau, theta, formula)
	
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
