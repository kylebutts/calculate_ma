{smcl}
{it:v. 1.0.0} 
{viewerjumpto "Syntax" "calculate_ma##syntax"}{...}

{title:Generate Tau Matrix from Lat/Long}

{pstd}
{bf:gen_dist_mat} - This function takes lat/long and creates an nxn matrix of distances between points (using the Haversine Formula).

{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:gen_dist_mat} {cmd:,} {cmdab:lat:itude(}{it:varname}{cmd:)} {cmdab:lon:gitude(}{it:varname}{cmd:)} {cmdab:gen:erate(}{it:string}{cmd:)} [{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Options}
{synopt :{opt lat:itude(varname)}}The name of the variable containing the observations latitude.{p_end}
{synopt :{opt lon:gitude(varname)}}The name of the variable containing the observations longitude.{p_end}
{synopt :{opt gen:erate}}The name of the matrix that you want tau to be stored as. This will the name passed to the tau option of {cmd:calculate_ma}.{p_end}
{synopt :{opt elasticity(#)}}{p_end}
{synopt :{opt dist_cutoff(#)}}The minimum distance. If distance between unit i and j is less than dist_cutoff, that distance is replaced to 0. Defaults to -1. {p_end}
{synoptline}
{p2colreset}{...}



{title:Description}

{pstd}
{bf:gen_dist_mat} takes {opt lat:itude} and {opt lon:gitude} of a set of points and returns the matrix of distances between them using the Haversine formula. It will store this matrix by the name given by {opt gen:erate}.

{title:Example}

    Example of calculating distance matrix
        {cmd:. clear}
        {cmd:. /* four points exaclty 1km away from the first point */}
        {cmd:  input lat lon}
        {cmd:  39.9522 -75.1642}
        {cmd:  39.9612062665079  -75.1642000000000}
        {cmd:  39.9521994093929  -75.1524977114628}
        {cmd:  39.9431937194577  -75.1642000000000}
        {cmd:  39.9521994093929  -75.1759022885372}
        {cmd:  end}
        {cmd:. gen_dist_mat, lat("lat") lon("lon") gen("tau") elasticity(-1)}
        {cmd:. matrix list tau}


{title:Author}

{pstd}
Taylor Jaworski    {break}
University of Colorado, Boulder      {break}

{pstd}
Kyle Butts   {break}
University of Colorado, Boulder      {break}
buttskyle96@gmail.com     {break}

{title:References}

{phang}
{browse "https://rosettacode.org/wiki/Haversine_formula#python":Haversine Formula}
{p_end}






