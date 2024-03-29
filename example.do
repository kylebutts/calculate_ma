* Example of calculate_ma.ado --------------------------------------------------

do ado/calculate_ma.ado

clear
set obs 5
gen Y = 1 + 0.20 * (_n==2)

matrix input tau = (1.0, 1.1, 1.1, 1.1, 1.1 \ 1.1, 1.0, 1.1, 1.1, 1.1 \ 1.1, 1.1, 1.0, 1.1, 1.1 \ 1.1, 1.1, 1.1, 1.0, 1.1 \ 1.1, 1.1, 1.1, 1.1, 1.0)


calculate_ma Y, tau("tau") theta(8) generate("ma") formula("income")

calculate_ma Y, tau("tau") theta(8) generate("ma_pop") formula("population")

calculate_ma Y, tau("tau") theta(8) generate("ma_simple") formula("simple")





* Example of gen_dist_mat -----------------------------------------------------------

do ado/gen_dist_mat.ado

clear
* four points exaclty 1km away from the first point
input lat lon
39.9522 -75.1642
39.9612062665079  -75.1642000000000
39.9521994093929  -75.1524977114628
39.9431937194577  -75.1642000000000
39.9521994093929  -75.1759022885372
end

gen_dist_mat, lat("lat") lon("lon") generate("tau")

matrix list tau




* Example using real data ------------------------------------------------------

set matsize 4000
insheet using data/Tau2010cost1.csv, clear
mkmat *, matrix(tau)

insheet using data/Y2010.csv, clear

rename v1 Y

calculate_ma Y, tau("tau") theta(8) generate("ma") formula("income")








