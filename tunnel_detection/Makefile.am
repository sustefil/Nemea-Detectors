
include ../supinclude.am

bin_PROGRAMS=dnstunnel_detection
dnstunnel_detection_SOURCES=tunnel_detection_dns.c \
         tunnel_detection_dns.h \
         parser_pcap_dns.c \
         parser_pcap_dns.h \
         tunnel_detection_dns_structs.h \
         fields.c fields.h
dnstunnel_detection_LDADD=-ltrap -lunirec -lm -lnemea-common
dnstunnel_detection_CXXFLAGS=-std=c++98 -O2
dnstunnel_detection_CFLAGS=-std=gnu99 -O2

pkgdocdir=${docdir}/dnstunnel_detection

include ../aminclude.am
