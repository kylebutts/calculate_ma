{smcl}
{it:v. 1.0.0} 


{title:Calculate Market Access}

{p 4 4 2}
{bf:calculate_ma} - This function takes a matrix of trade costs, {it:tau}, and a vector of market size, {it:Y}, and creates a new variable that contains market access following Jaworski and Kitchens (2019), {browse "https://doi.org/10.1162/rest_a_00808":National Policy for Regional Development: Historical Evidence from Appalachian Highways}.


{title:Syntax}

{p 8 8 2} {bf:calculate_ma} {it:Y} [, {it:options}]

{col 5}{it:option}          {col 44}{it:Description}          
{space 4}{hline 64}
{col 5}{ul:tau}           {col 44}string containing name of stata matrix of iceberg trade costs
{col 5}{ul:theta}         {col 44}measure of elasticity of trade with respect to trade costs. defaults to 5
{col 5}{ul:gen}erate      {col 44}name to store the created market access variable
{space 4}{hline 64}



{title:Description}

{p 4 4 2}
{bf:calculate_ma} takes a vector of market size, a matrix of iceberg trade costs, and an elasticity of trade costs, theta, and returns market access. It solves the following function from Jaworksi and Kitchens (2019).
MA_{c}= \sum_{d} \tau_{c d}^{-\theta} MA_{d}^{-1} Y_{d}


{title:Example(s)}

    Example of calculating market access
        . clear
        . set obs 5
        . gen Y = 1 + 0.20 * (_n==2)
        . matrix input tau = (1.0, 1.1, 1.1, 1.1, 1.1 \ 1.1, 1.0, 1.1, 1.1, 1.1 \ 1.1, 1.1, 1.0, 1.1, 1.1 \ 1.1, 1.1, 1.1, 1.0, 1.1 \ 1.1, 1.1, 1.1, 1.1, 1.0)
        . calculate_ma Y, tau("tau") theta(4) generate("ma")


{title:Stored results}

{p 4 4 2}
{bf:calculate_ma} stores the following in {bf:r()}:

{p 4 4 2}
Scalars

{p 8 8 2} {bf:r(delta)}: final tolerance from while loop

{p 4 4 2}
Vectors

{p 8 8 2} {bf:r(ma)}: vector of market access


{title:Author}

{p 4 4 2}
Taylor Jaworski    {break}
University of Colorado, Boulder      {break}


{p 4 4 2}
Kyle Butts   {break}
University of Colorado, Boulder      {break}
buttskyle96@gmail.com     {break}

{title:References}

{p 4 4 2}Jaworski and Kitchens (2019), {browse "https://doi.org/10.1162/rest_a_00808":National Policy for Regional Development: Historical Evidence from Appalachian Highways}


