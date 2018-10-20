#!/bin/bash

IPFILTER_BIN="../ipblacklistfilter"
URLFILTER_BIN="../urlblacklistfilter"
LOGGER_BIN="/usr/local/bin/logger"
LOGREPLAY_BIN="/usr/local/bin/logreplay"

BLACKLIST_FOLDER="test_blacklists"

IPFILTER_CONFIG="ipdetect_config_test.xml"
REF_OUTPUT_FOLDER="ref_output"
OUTPUT_FOLDER="output"

rm -r $OUTPUT_FOLDER 2>/dev/null
mkdir $OUTPUT_FOLDER

TEST_COUNT=5
MAIN_RET=0
for ((i=1; i<=$TEST_COUNT;i++)); do
    # Replace the blacklist in the config file
    sed -i "s/test_blacklists\/ip.\.blist/test_blacklists\/ip$i.blist/" $IPFILTER_CONFIG

    # Run blacklistfilter
    $IPFILTER_BIN -i u:blacklist_test,f:out:w -u $IPFILTER_CONFIG &
    sleep 1

    # The first two testcases use testfile_20
    if [[ $i < 3 ]]; then
        $LOGREPLAY_BIN -f testfile_20 -i u:blacklist_test
    else
        $LOGREPLAY_BIN -f testfile_1000 -i u:blacklist_test
    fi

    sleep 1
    $LOGGER_BIN -t -i f:out > $OUTPUT_FOLDER/$i.out
    cmp $OUTPUT_FOLDER/$i.out $REF_OUTPUT_FOLDER/$i.out
    RET=$?

    if [[ $RET -eq 0 ]]; then
        echo "Test $i/$TEST_COUNT: SUCCESS"
    else
        echo "Test $i/$TEST_COUNT: FAIL"
        MAIN_RET=1
    fi
done

rm out
# On success, delete the output folder
if [[ $MAIN_RET -eq 0 ]]; then
    rm -r $OUTPUT_FOLDER
else
    echo "Keeping output folder to check for errors"
fi

exit $MAIN_RET
