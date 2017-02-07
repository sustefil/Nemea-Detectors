
include ../supinclude.am

script_files=booterfilter-update.sh booterfilter2idea.py
bin_SCRIPTS=$(script_files)

pkgdocdir=${docdir}/booterfilter

crondir=$(sysconfdir)/cron.d
cron_DATA=booterfilter.cron

EXTRA_DIST+=$(script_files) booterfilter.cron
