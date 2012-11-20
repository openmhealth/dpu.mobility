# Mobility DPU functions

This R package contains some DPU functions related to mobile health and mobility.

The DPUs are written in R and deployed through the OpenCPU framework. For more information about the API, visit www.opencpu.org.

## Examples

### geodistance

Calculates the total distance between a number of long/lat locations using Haversine formula. For example to calculate the distance from LA to New York and back:

	https://public.opencpu.org/R/call/dpu.mobility/geodistance/json?long=[-74.0064,-118.2430,-74.0064]&lat=[40.7142,34.0522,40.7142]
	https://public.opencpu.org/R/call/dpu.mobility/geodistance/json?long=[-74.0064,-118.2430,-74.0064]&lat=[40.7142,34.0522,40.7142]&unit="miles"

### mobility.smooth

Smooths a vector of mobility modes. Useful to do some 'noise filtering'. Argument x will always be treated as categorical, even it contais integers. Don't use this for smoothing real numbers.

	https://public.opencpu.org/R/call/dpu.mobility/mobility.smooth/json?x=["drive","drive","drive","walk","drive","drive","drive","drive","walk","walk","walk","walk","walk","walk","sit","sit","sit","sit","sit","sit","drive","sit","sit","sit","sit"]
	https://public.opencpu.org/R/call/dpu.mobility/mobility.smooth/json?x=[1,1,1,3,1,1,1,1,3,3,3,3,3,3,2,2,2,2,2,2,1,2,2,2,2]
	
There is an optional smoothing parameter that controls the degree of smoothing. This is roughly the number of neighboring days that are taken into account.  

	https://public.opencpu.org/R/call/dpu.mobility/mobility.smooth/json?x=[1,1,1,1,1,1,2,1,2,1,1,1,1,1,1,1,1,3,1,3,3,3,3,3,3,3,3,3,3,3,3,1]&strength=5
	https://public.opencpu.org/R/call/dpu.mobility/mobility.smooth/json?x=[1,1,1,1,1,1,2,1,2,1,1,1,1,1,1,1,1,3,1,3,3,3,3,3,3,3,3,3,3,3,3,1]&strength=3
	https://public.opencpu.org/R/call/dpu.mobility/mobility.smooth/json?x=[1,1,1,1,1,1,2,1,2,1,1,1,1,1,1,1,1,3,1,3,3,3,3,3,3,3,3,3,3,3,3,1]&strength=10			
	
### mobility.summarize

Some simple summary statistics for a mobility vector. 

	https://public.opencpu.org/R/call/dpu.mobility/mobility.summarize/json?x=["drive","drive","drive","walk","drive","drive","drive","drive","walk","walk","walk","walk","walk","walk","sit","sit","sit","sit","sit","sit","drive","sit","sit","sit","sit"]
	https://public.opencpu.org/R/call/dpu.mobility/mobility.summarize/json?x=[1,1,1,3,1,1,1,1,3,3,3,3,3,3,2,2,2,2,2,2,1,2,2,2,2]
