#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
use LWP::UserAgent;
use HTTP::Request;
use HTML::TreeBuilder;
use URI;
use IO::File;
use Pod::Usage;

print <<'HEADER';
                                                         
     / /                                                 
    / /         ___        ___           ( )      ___    
   / /        //___) )   ((   ) )       / /     ((   ) ) 
  / /        //           \ \          / /       \ \     
 / /____/ / ((____     //   ) )   ((  / /     //   ) )   
                                                         
HEADER

# Define default values for options
my $url;
my $method = 'GET';
my $output_file;
my $input_file;
my @headers;
my $insecure = 0;
my $timeout = 10;
my $help = 0;

# Parse command-line arguments
GetOptions(
    'url=s' => \$url,
    'method=s' => \$method,
    'output=s' => \$output_file,
    'input=s' => \$input_file,
    'header=s' => \@headers,
    'insecure' => \$insecure,
    'timeout=i' => \$timeout,
    'help|h' => \$help,
) or pod2usage(2);

# Display help message if needed
pod2usage(1) if $help;

# Function to print error messages
sub error_message {
    my ($message) = @_;
    print STDERR "Error: $message\n";
}

# Read URLs from standard input if available
my @urls;
if (! -t STDIN) {
    while (<STDIN>) {
        chomp;
        push @urls, $_;
    }
}

# Read URLs from input file if specified
if ($input_file) {
    open my $fh, '<', $input_file or die "Could not open input file: $!";
    while (<$fh>) {
        chomp;
        push @urls, $_;
    }
    close $fh;
}

# Add URL from command-line argument if specified
push @urls, $url if $url;

# Exit if no URLs are provided
if (!@urls) {
    error_message("No URLs supplied");
    exit 1;
}

# Function to get JavaScript sources from a URL
sub get_script_src {
    my ($url, $method, $headers, $insecure, $timeout) = @_;
    my $ua = LWP::UserAgent->new;
    $ua->timeout($timeout);
    $ua->ssl_opts(verify_hostname => !$insecure);

    my $req = HTTP::Request->new($method => $url);
    foreach my $header (@$headers) {
        my ($key, $value) = split /:/, $header, 2;
        $req->header($key => $value);
    }

    my $res = $ua->request($req);
    if (!$res->is_success) {
        error_message("$url returned " . $res->status_line);
        return;
    }

    my $tree = HTML::TreeBuilder->new;
    $tree->parse($res->decoded_content);
    $tree->eof;

    my @sources;
    foreach my $script ($tree->find_by_tag_name('script')) {
        my $src = $script->attr('src') || $script->attr('data-src');
        push @sources, $src if $src;
    }

    $tree = $tree->delete;
    return @sources;
}

# Main processing loop for each URL
my @all_sources;
foreach my $e (@urls) {
    my @sources = get_script_src($e, $method, \@headers, $insecure, $timeout);

    foreach my $src (@sources) {
        print $src, "\n";
    }

    push @all_sources, @sources if $output_file;
}

# Save to output file if specified
if ($output_file) {
    open my $out_fh, '>', $output_file or die "Could not open output file: $!";
    foreach my $src (@all_sources) {
        print $out_fh $src, "\n";
    }
    close $out_fh;
}

__END__

=head1 NAME

Lesjs - Fetch JavaScript sources from web pages

=head1 SYNOPSIS

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

=head1 DESCRIPTION

This script fetches JavaScript sources from the specified URLs and prints or saves the results to a file.

=cut
