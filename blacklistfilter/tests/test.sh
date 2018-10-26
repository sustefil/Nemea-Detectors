#!/bin/bash

IPFILTER_BIN="../ipblacklistfilter"
URLFILTER_BIN="../urlblacklistfilter"
LOGGER_BIN="/usr/local/bin/logger"
LOGREPLAY_BIN="/usr/local/bin/logreplay"

BLACKLIST_FOLDER="test_blacklists"

IPFILTER_CONFIG="ipdetect_config_test.xml"

IPV4_REF_OUTPUT_FOLDER="ref_output4"
IPV6_REF_OUTPUT_FOLDER="ref_output6"
IPV4_OUTPUT_FOLDER="output4"
IPV6_OUTPUT_FOLDER="output6"

rm -r $IPV4_OUTPUT_FOLDER $IPV6_OUTPUT_FOLDER 2>/dev/null
mkdir $IPV4_OUTPUT_FOLDER $IPV6_OUTPUT_FOLDER


function test4
{
    sed -i "s/test_blacklists\/ip4_dummy.blist/test_blacklists\/ip4_1.blist/" $IPFILTER_CONFIG

    TEST_COUNT=6
    MAIN_RET=0
    for ((i=1; i<=$TEST_COUNT;i++)); do
        # Replace the blacklist in the config file
        sed -i "s/test_blacklists\/ip4_.\.blist/test_blacklists\/ip4_$i.blist/" $IPFILTER_CONFIG
        # Suppress ipv6 for ipv4 tests
        sed -i "s/test_blacklists\/ip6_.\.blist/test_blacklists\/ip6_dummy.blist/" $IPFILTER_CONFIG

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
        $LOGGER_BIN -t -i f:out > $IPV4_OUTPUT_FOLDER/$i.out
        cmp $IPV4_OUTPUT_FOLDER/$i.out $IPV4_REF_OUTPUT_FOLDER/$i.out
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
        rm -r $IPV4_OUTPUT_FOLDER
    else
        echo "Keeping output folder to check for errors"
    fi

    return $MAIN_RET
}

function test6
{
    sed -i "s/test_blacklists\/ip6_dummy.blist/test_blacklists\/ip6_1.blist/" $IPFILTER_CONFIG

    TEST_COUNT=2
    MAIN_RET=0
    for ((i=1; i<=$TEST_COUNT;i++)); do
        # Replace the blacklist in the config file
        sed -i "s/test_blacklists\/ip4_.\.blist/test_blacklists\/ip4_dummy.blist/" $IPFILTER_CONFIG
        # Suppress ipv6 for ipv4 tests
        sed -i "s/test_blacklists\/ip6_.\.blist/test_blacklists\/ip6_$i.blist/" $IPFILTER_CONFIG

        # Run blacklistfilter
        $IPFILTER_BIN -i u:blacklist_test,f:out:w -u $IPFILTER_CONFIG &
        sleep 1

        $LOGREPLAY_BIN -f testfile_1000 -i u:blacklist_test

        sleep 1
        $LOGGER_BIN -t -i f:out > $IPV6_OUTPUT_FOLDER/$i.out
        cmp $IPV6_OUTPUT_FOLDER/$i.out $IPV6_REF_OUTPUT_FOLDER/$i.out
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
        rm -r $IPV6_OUTPUT_FOLDER
    else
        echo "Keeping output folder to check for errors"
    fi

    return $MAIN_RET
}

# test4
RET4=$?

test6
RET6=$?

exit $(( $RET4 || $RET6 ))
