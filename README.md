# dnsperf
# - Google.com (A/AAAA):

echo -e "google.com A\ngoogle.com AAAA" > google && dnsperf -s 172.17.0.10 -l 30 -c 100 -d google
# - Google.com (AAAA):
echo "google.com AAAA" > google && dnsperf -s 172.17.0.10 -l 30 -c 100 -d google
# - Varied targets:

wget ftp://ftp.nominum.com/pub/nominum/dnsperf/data/queryfile-example-current.gz; gzip -d queryfile-example-current.gz; dnsperf -s 172.17.0.10 -l 11 -c 10 -Q 60 -d queryfile-example-current
