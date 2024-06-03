# Lesjs
A tool to fastly get all javascript sources/files
# Installation

```
git clone https://github.com/XJOKZVO/Lesjs.git
```

# Options:
```
     / /                                                 
    / /         ___        ___           ( )      ___    
   / /        //___) )   ((   ) )       / /     ((   ) ) 
  / /        //           \ \          / /       \ \     
 / /____/ / ((____     //   ) )   ((  / /     //   ) )   
                                                         
Usage:
    Lesjs [options]

     Options:
       --url URL          The URL to get the JavaScript sources from
       --method METHOD    The request method (GET or POST) (default: GET)
       --output FILE      Output file to save the results to
       --input FILE       Input file with URLs
       --header HEADER    Any HTTP headers (-H "Authorization:Bearer token")
       --insecure         Skip SSL security checks
       --timeout SECONDS  Max timeout for the requests (default: 10 seconds)
       --help, -h         Show this help message

```
# Usage:
```
To fetch JavaScript sources from a single URL and print them to the console:
perl Lesjs.pl --url "http://example.com"

To fetch JavaScript sources from multiple URLs listed in an input file:
perl Lesjs.pl --input urls.txt

To save the fetched JavaScript sources to an output file:
perl Lesjs.pl --url "http://example.com" --output js_sources.txt

To include custom HTTP headers in the request:
perl Lesjs.pl --url "http://example.com" --header "Authorization: Bearer token"

To disable SSL verification (useful for testing with self-signed certificates):
perl Lesjs.pl --url "https://example.com" --insecure

To set a custom timeout for HTTP requests:
perl Lesjs.pl --url "http://example.com" --timeout 20

```
