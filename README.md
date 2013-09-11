# Mobility DPU functions

This R package contains some DPU functions related to mobile health and mobility. The DPUs are written in R and deployed through the OpenCPU framework. For more information about the API, visit www.opencpu.org. 

## Calling the API

OpenCPU allows POST request content types `application/x-www-form-urlencoded`, `multipart/form-data` or `application/json`. For example:

	curl https://public.opencpu.org/ocpu/library/dpu.mobility/R/geodistance/json -d 'long=[-74.0064,-118.2430,-74.0064]&lat=[40.7142,34.0522,40.7142]'

This is equivalent to:

	curl https://public.opencpu.org/ocpu/library/dpu.mobility/R/geodistance/json \
	 -H "Content-Type: application/json" -d '{"long":[-74.0064,-118.2430,-74.0064],"lat":[40.7142,34.0522,40.7142]}'

## Examples

### geodistance

Calculates the total distance between a number of long/lat locations using Haversine formula. For example to calculate the distance from LA to New York and back:

	curl https://public.opencpu.org/ocpu/library/dpu.mobility/R/geodistance/json -d 'long=[-74.0064,-118.2430,-74.0064]&lat=[40.7142,34.0522,40.7142]'
	curl https://public.opencpu.org/ocpu/library/dpu.mobility/R/geodistance/json -d 'long=[-74.0064,-118.2430,-74.0064]&lat=[40.7142,34.0522,40.7142]&unit="miles"'

### diameter

Approximates the "daily diameter" (greatest distance between any two points in a given set). Default result in Kilometers. For example, for some points on UCLA campus:

	curl https://public.opencpu.org/ocpu/library/dpu.mobility/R/diameter/json -d 'long=[-118.453989, -118.450041, -118.444376, -118.439569, -118.439484, -118.444204, -118.444118, -118.441887]&lat=[34.073777, 34.069547, 34.064001, 34.077225, 34.070400, 34.070008, 34.069085, 34.070578]'
	curl https://public.opencpu.org/ocpu/library/dpu.mobility/R/diameter/json -d 'long=[-118.453989, -118.450041, -118.444376, -118.439569, -118.439484, -118.444204, -118.444118, -118.441887]&lat=[34.073777, 34.069547, 34.064001, 34.077225, 34.070400, 34.070008, 34.069085, 34.070578]&unit="miles"'

### mobility.smooth

Smooths a vector of mobility modes. Useful to do some 'noise filtering'. Argument x will always be treated as categorical, even it contais integers. Don't use this for smoothing real numbers.

	curl https://public.opencpu.org/ocpu/library/dpu.mobility/R/mobility.smooth/json -d 'x=["drive","drive","drive","walk","drive","drive","drive","drive","walk","walk","walk","walk","walk","walk","sit","sit","sit","sit","sit","sit","drive","sit","sit","sit","sit"]'
	curl https://public.opencpu.org/ocpu/library/dpu.mobility/R/mobility.smooth/json -d 'x=[1,1,1,3,1,1,1,1,3,3,3,3,3,3,2,2,2,2,2,2,1,2,2,2,2]'
	
There is an optional smoothing parameter that controls the degree of smoothing. This is roughly the number of neighboring days that are taken into account.

	curl https://public.opencpu.org/ocpu/library/dpu.mobility/R/mobility.smooth/json -d 'x=[1,1,1,1,1,1,2,1,2,1,1,1,1,1,1,1,1,3,1,3,3,3,3,3,3,3,3,3,3,3,3,1]&strength=5'
	curl https://public.opencpu.org/ocpu/library/dpu.mobility/R/mobility.smooth/json -d 'x=[1,1,1,1,1,1,2,1,2,1,1,1,1,1,1,1,1,3,1,3,3,3,3,3,3,3,3,3,3,3,3,1]&strength=3'
	curl https://public.opencpu.org/ocpu/library/dpu.mobility/R/mobility.smooth/json -d 'x=[1,1,1,1,1,1,2,1,2,1,1,1,1,1,1,1,1,3,1,3,3,3,3,3,3,3,3,3,3,3,3,1]&strength=10'
	
### mobility.summarize

Some simple summary statistics for a mobility vector. 

	curl https://public.opencpu.org/ocpu/library/dpu.mobility/R/mobility.summarize/json -d 'x=["drive","drive","drive","walk","drive","drive","drive","drive","walk","walk","walk","walk","walk","walk","sit","sit","sit","sit","sit","sit","drive","sit","sit","sit","sit"]'
	curl https://public.opencpu.org/ocpu/library/dpu.mobility/R/mobility.summarize/json -d 'x=[1,1,1,3,1,1,1,1,3,3,3,3,3,3,2,2,2,2,2,2,1,2,2,2,2]'
