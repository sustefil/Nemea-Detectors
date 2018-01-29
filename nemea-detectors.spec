Summary: Package with detection modules of the Nemea system
Name: nemea-detectors
Version: 1.3.9
Release: 1
URL: http://www.liberouter.org/
Source: https://www.github.com/CESNET/Nemea-Detectors/%{name}-%{version}-%{release}.tar.gz
Group: Liberouter
License: BSD
Vendor: CESNET, z.s.p.o.
Packager: Travis CI User <travis@example.org>
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}
Requires: nemea-framework wget libidn openssl
BuildRequires: gcc gcc-c++ make doxygen pkgconfig nemea-framework-devel libidn-devel openssl-devel
Provides: nemea-detectors

%description

%prep
%setup

%build
./configure --disable-silent-rules --prefix=%{_prefix} --libdir=%{_libdir} --bindir=%{_bindir}/nemea --sysconfdir=%{_sysconfdir}/nemea --disable-repobuild --docdir=%{_docdir}/nemea-detectors;
make

%install
make -j5 DESTDIR=$RPM_BUILD_ROOT install

%post

%files
%{_bindir}/nemea/amplification_detection
%{_bindir}/nemea/booterfilter2idea.py
%{_bindir}/nemea/booterfilter-update.sh
%{_bindir}/nemea/ddos_detector
%{_bindir}/nemea/dnstunnel_detection
%{_bindir}/nemea/haddrscan_detector
%{_bindir}/nemea/ipblacklistfilter
%{_bindir}/nemea/sip_bf_detector
%{_bindir}/nemea/vportscan_aggregator.py
%{_bindir}/nemea/brute_force_detector
%{_bindir}/nemea/haddrscan_aggregator.py
%{_bindir}/nemea/hoststatsnemea
%{_bindir}/nemea/miner_detector
%{_bindir}/nemea/voip_fraud_detection
%{_bindir}/nemea/vportscan_detector
%{_docdir}/nemea-detectors/*/README*
%config(noreplace) %{_sysconfdir}/nemea/hoststats.conf
%config(noreplace) %{_sysconfdir}/nemea/miner_detector/userConfigFile.xml
%config(noreplace) %{_sysconfdir}/nemea/hoststats.conf.default
%config(noreplace) %{_sysconfdir}/nemea/ipblacklistfilter/bld_userConfigFile.xml
%config(noreplace) %{_sysconfdir}/nemea/ipblacklistfilter/userConfigFile.xml
%config(noreplace) %{_sysconfdir}/nemea/available-sup/booterfilter.sup
%config(noreplace) %{_sysconfdir}//nemea/cron.d/booterfilter.cron
%{_mandir}/man1/*.1.gz

