# Makefile

SRCTOP=..
include $(SRCTOP)/build/vars.mak

build: package
unittest:
systemtest: test-setup test-run
jtestTest:
	$(MAKE) NTESTFILES="systemtest/jtest.ntest" RUNFLOGTESTS=1 test-setup test-run

NTESTFILES ?= systemtest

test-setup:
	$(EC_PERL) ../EC-JTest/systemtest/setup.pl $(TEST_SERVER) $(PLUGINS_ARTIFACTS)

test-run: systemtest-run

include $(SRCTOP)/build/rules.mak
