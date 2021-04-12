*! version 0.1


capture program drop gen_dist_mat
program define gen_dist_mat
	version 15
	syntax, LATitude(string) LONgitude(string) GENerate(string) [elasticity(real -1), dist_cutoff(real -1)]
	
	/* Check options */
	confirm numeric variable `latitude'
	confirm numeric variable `longitude'

	
	/* Load Data into mata variables */
	mata: lat = .
	mata: st_view(lat, .,"`latitude'")
	mata: lon = .
	mata: st_view(lon, .,"`longitude'")
	mata: dist_cutoff = `dist_cutoff'
	mata: elasticity = `elasticity'
	
	/* Calculate Tau */
	mata: tau = gen_dist_mat(lat, lon, elasticity, dist_cutoff)
	
	/* Store results */
	mata: st_matrix("`generate'", tau)
end



capture mata mata drop gen_dist_mat()
mata:

/* -----------------------------------------------------------------------------
Calculate nxn matrix of trade costs from lat and long. Tau is modeled as a constant elasticity function of distance tau = dist^-elasticity.
 
Requires four variables:

Inputs: 
  nx1 vector lat - latitude
  nx1 vector lon - longitude
  1x1 scalar tau - elasticity of trade cost
  1x1 scalar dist_cutoff - minimum distance threshold to have non-zero value in matrix
  
Output: 
  nxn matrix tau - distance matrix in km
  
Description: 
  Uses haversine distance to create matrix of distances between units
----------------------------------------------------------------------------- */
real matrix gen_dist_mat(real vector lat, real vector lon, real scalar elasticity, real scalar dist_cutoff) {
	
	real matrix tau
	real scalar N, lat1, lat2, lon1, lon2, a1, b1, dlon, dlat, a, c, R, rad
	
	N = length(lat)
	tau = J(N, N, 1)
	
	R = 6372.8 
	rad = pi() / 180
	
	for(i = 1; i <= N; i++) {
		for(j = 1; j <= N; j++) {
  
			lat1 = lat[i]
			lat2 = lat[j]
			lon1 = lon[i]
			lon2 = lon[j]
			
			dlon = (lon2 - lon1)*rad
			dlat = (lat2 - lat1)*rad
			lat1 = lat1*rad
			lat2 = lat2*rad
			
 
            a = sin(dlat / 2)^2 + cos(lat1) * cos(lat2) * sin(dlon / 2)^2
            c = 2 * asin(sqrt(a))
			
			/* store distance if distance > dist_cutoff */
			tau[i,j] = (R*c)^(-elasticity) * (R*c > dist_cutoff)
			tau[j,i] = (R*c)^(-elasticity) * (R*c > dist_cutoff)
			
			
			/* 1 on diagonal */
			if(i == j) tau[i,j] = 1 
		}
	}
	
	return(tau)
}

	
end

/*
mata:

/* https://rosettacode.org/wiki/Haversine_formula#python */
/* should be ~2887 km */
lat = (36.12, 33.94)
lon = (-86.67, -118.40)
gen_dist_mat(lat, lon, -1, -1)


lat = (39.9522, 39.9612062665079, 39.9521994093929, 39.9431937194577, 39.9521994093929)'
lon = (-75.1642, -75.1642000000000, -75.1524977114628, -75.1642000000000, -75.1759022885372)'

/* No Cutoff */
gen_dist_mat(lat, lon, -1, -1)

/* Cutoff */
gen_dist_mat(lat, lon, -1,  20037.217)



end
*/