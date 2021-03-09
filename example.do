/* Example of calculate_ma.ado */

do calculate_ma.ado

clear
set obs 5
gen Y = 1 + 0.20 * (_n==2)

matrix input tau = (1.0, 1.1, 1.1, 1.1, 1.1 \ 1.1, 1.0, 1.1, 1.1, 1.1 \ 1.1, 1.1, 1.0, 1.1, 1.1 \ 1.1, 1.1, 1.1, 1.0, 1.1 \ 1.1, 1.1, 1.1, 1.1, 1.0)


calculate_ma Y, tau("tau") theta(4) generate("ma")
