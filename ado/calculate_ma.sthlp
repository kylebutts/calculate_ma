{smcl}
{it:v. 1.0.0} 
{viewerjumpto "Syntax" "calculate_ma##syntax"}{...}
{viewerjumpto "Formulae" "calculate_ma##formulae"}{...}
{viewerjumpto "Theta" "calculate_ma##theta"}{...}

{title:Calculate Market Access}

{pstd}
{bf:calculate_ma} - This function takes a matrix of trade costs, {it:tau}, and a vector of market size, {it:Y}, and creates a new variable that contains market access. 

{help calculate_ma##formulae}


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:calculate_ma} {it:Y} [{cmd:,} {it:options}]

{phang3}where {it:Y} is a measure of market size. This {p_end}


{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Options}
{synopt :{opt tau(matname)}}string containing name of stata matrix of iceberg trade costs{p_end}
{synopt :{opt theta(#)}}measure of elasticity of trade with respect to trade costs. See {help calculate_ma##theta:Theta} for details on which elasticity to use. Defaults to 5.{p_end}
{synopt :{opt formula(string)}}which formula to use, either "income", "population", or "basic". See {help calculate_ma##formulae:Formulae} for details on options.{p_end}
{synopt :{opt gen:erate(newvar)}}name to store the created market access variable{p_end}
{synoptline}
{p2colreset}{...}



{title:Description}

{pstd}
{bf:calculate_ma} takes a vector of market size, a matrix of iceberg trade costs, and an elasticity of trade costs, theta, and returns the computed market access.


{marker formulae}
{title:Formulae}

{phang}Different theoretical foundations yield different formulae for calculating market access. Importantly, some use population and others use income (GDP) as the measure of the market size, {it:Y}. The formula option has three accepted values that indicate which formula to use: {p_end}

{phang2}
{it:"income"}: For when {it:Y} is a measure of GDP. It solves the following function from Jaworski and Kitchens (2019):

{phang3}
MA_c = \sum_d \tau_{cd}^{-\theta} MA_d^{-1} Y_d,

{phang3} where Y_d is GDP.

{phang2}
{it:"population"}: For when {it:Y} is a measure of population. It solves Equation (9) from Donaldson and Hornbeck (2016):

{phang3}
MA_c = \sum_d \tau_{cd}^{-theta} MA_{d}^{-(1 + theta)/theta} Y_{d},

{phang3} where Y_d is population.

{phang2}
{it:"basic"}: For when {it:Y} is a measure of population. It solves Equation (12) from Donaldson and Hornbeck (2016) (faster at the cost of precision):

{phang3}
MA_c = \sum_d \tau_{c d}^{-\theta} Y_d,

{phang3} where Y_d is population.

{marker theta}
{title:Theta}

{phang}
Theta is an elasticity of trade with respect to trade costs. Data on trade costs can come in three forms and the choice of theta depends importantly on this. Researchers use direct measures of trade costs, proxy costs with travel time, or proxy costs with distance. 
{p_end}

{phang}
Values of theta depend on what proxy variable is used for trade costs. And default values come from estimates in the literature. There are three options for default values of theta
{p_end}

{phang2}
{it:"traveltime"}: 8.
This should be used when the off-diagonal elements of tau is the travel time it takes between two units in hours. This estimate comes from Jaworski and Kitchens (2019).
{p_end}

{phang2}
{it:"distance"}: 1.01. 
This should be used when the off-diagonal elements of tau is the distance between two units in km. This estimate comes from Bartelme (2018 Working Paper). Note that this estimate relates to within-country distances and this estimate is not necessarily appropriate when distance refers to international trade. 
{p_end}

{phang2}
{it:"tau"}: 5.13. 
This should be used when the off-diagonal elements of tau are direct estimates of iceberg trade costs. This estimate comes from the mean structural gravity estimate of the trade cost elasticty from Table 3.5 in Head and Mayer (2014).
{p_end}



{title:Example}

    Example of calculating market access
        {cmd:. clear}
        {cmd:. set obs 5}
        {cmd:. gen Y = 1 + 0.20 * (_n==2)}
        {cmd:. matrix input tau = (1.0, 1.1, 1.1, 1.1, 1.1 \ 1.1, 1.0, 1.1, 1.1, 1.1 \ 1.1, 1.1, 1.0, 1.1, 1.1 \ 1.1, 1.1, 1.1, 1.0, 1.1 \ 1.1, 1.1, 1.1, 1.1, 1.0)}
        {cmd:. calculate_ma Y, tau("tau") theta(4) generate("ma")}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:calculate_ma} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(delta)}}final tolerance from while loop{p_end}

{p2col 5 15 19 2: Vectors}{p_end}
{synopt:{cmd:r(ma)}}vector of market access{p_end}
{p2colreset}{...}



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
Bartelme (WP), {browse "https://drive.google.com/file/d/1yxjszpuabtp--Pe_SS_mkgxgjKkR0lp-/view":Trade Costs and Economic Geography: Evidence from the U.S.}
{p_end}

{phang}
Head and Mayer (2014). {browse "https://doi.org/10.1016/B978-0-444-54314-1.00003-3":Gravity Equations: Workhorse,Toolkit, and Cookbook.} 
{p_end}

{phang}
Jaworski and Kitchens (2019), {browse "https://doi.org/10.1162/rest_a_00808":National Policy for Regional Development: Historical Evidence from Appalachian Highways}
{p_end}






