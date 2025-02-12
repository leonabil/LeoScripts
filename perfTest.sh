#!/bin/bash

# LEO Signalling project.
# Netork Performance test
# BAE Systems Digital Intelligence. 2025
# contact: nabil.romero-zurita@baesystems.com

## Testing Parameters
TESTSERVER1=speedtest.novoserve.com
SERVER1PORT=5202
TESTSERVER2=iperf.as42831.net
SERVER2PORT=5301
#SERVERTRC1=8.8.8.8
SERVERTRC1=google.com
#SERVERTRC2=baesystems.com
#SERVERTRC3=starlink.com
#SERVERTRC4=oneweb.net
SERVERTRC2=theguardian.com
SERVERTRC3=apple.com
SERVERTRC4=youtube.com
TESTDUR=1200 # iperf3 test duration im seconds
NUNPACKETS=1000 # mrt number of packets

## Script parameters
script="perfTest.sh"
margs=2 # Number of mandatory parameters.

## Common functions - BEGIN

# Ensures that the number of passed args are at least equals to the declared number of mandatory args.
# It also handles the special case of the -h or --help arg.
function margs_precheck {
    if [ $1 -lt $margs ]; then
        if [ "$2" == "-h" ]; then
	    help
	    exit
	else
	    usage
	    example
	    exit 1 # error
	fi
    fi
}

function usage {
    echo -e "usage: $script MANDATORY [OPTION]\n"
}

function help {
    usage
    echo -e "MANDATORY:"
    echo -e "Network             Network to test ST: Starlink / OW: OneWeb"
    echo -e "Weather             Weather condition: D: Dry / W: Wet"
    echo -e
    example
}

function example {
    echo -e "example 1: $script ST D"
    echo -e "           This would run the performance test for Starlink Network when the weather is dry."
    echo -e "example 2: $script OW W"
    echo -e "           This would run the performance test for OneWeb Network when the weather is wet."
}

##########################
# Main
margs_precheck $# $1

TESTNET=$1
WEATHER=$2


# TEST 1: Troughput Downlink Server1
TESTID=PERF01
TESTYPE=DL
DATESTR=$(date +%y%m%dT%H%M%S)
echo !!!! Running Test $TESTID to test $TESTYPE for $TESTDUR [s].
iperf3 -c $TESTSERVER1 -p $SERVER1PORT -P 1 -i 0.25 --timestamps -t $TESTDUR --reverse --logfile ${TESTNET}_${TESTID}_${TESTYPE}_${WEATHER}_${DATESTR}.log  --get-server-output

# TEST 2: Troughput Downlink Server2
TESTID=PERF02
TESTYPE=DL
DATESTR=$(date +%y%m%dT%H%M%S)
echo !!!! Running Test $TESTID to test $TESTYPE for $TESTDUR [s].
iperf3 -c $TESTSERVER2 -p $SERVER2PORT -P 1 -i 0.25 --timestamps -t $TESTDUR --reverse --logfile ${TESTNET}_${TESTID}_${TESTYPE}_${WEATHER}_${DATESTR}.log  --get-server-output

# TEST 3: Troughput Uplink Server1
TESTID=PERF03
TESTYPE=UL
DATESTR=$(date +%y%m%dT%H%M%S)
echo !!!! Running Test $TESTID to test $TESTYPE for $TESTDUR [s].
iperf3 -c $TESTSERVER1 -p $SERVER1PORT -P 1 -i 0.25 --timestamps -t $TESTDUR --logfile ${TESTNET}_${TESTID}_${TESTYPE}_${WEATHER}_${DATESTR}.log --get-server-output

# TEST 4: Troughput Uplink Server1
TESTID=PERF04
TESTYPE=UL
DATESTR=$(date +%y%m%dT%H%M%S)
echo !!!! Running Test $TESTID to test $TESTYPE for $TESTDUR [s].
iperf3 -c $TESTSERVER2 -p $SERVER2PORT -P 1 -i 0.25 --timestamps -t $TESTDUR --logfile ${TESTNET}_${TESTID}_${TESTYPE}_${WEATHER}_${DATESTR}.log --get-server-output

# TEST 5: Route and latency server 1
TESTID=PERF05
DATESTR=$(date +%y%m%dT%H%M%S)
echo !!!! Running Test $TESTID on server $SERVERTRC1 for $TESTDUR [s].
mtr -o "LSDRNBAWJMXI" -u -6 --report-wide -s 32 -c $NUNPACKETS -b -C $SERVERTRC1 > ${TESTNET}_${TESTID}_MRT_${WEATHER}_${DATESTR}.csv

# TEST 6: Route and latency server 2
TESTID=PERF06
DATESTR=$(date +%y%m%dT%H%M%S)
echo !!!! Running Test $TESTID on server $SERVERTRC2 for $TESTDUR [s].
mtr -o "LSDRNBAWJMXI" -u -6 --report-wide -s 32 -c $NUNPACKETS -b -C $SERVERTRC2 > ${TESTNET}_${TESTID}_MRT_${WEATHER}_${DATESTR}.csv

# TEST 7: Route and latency server 3
TESTID=PERF07
DATESTR=$(date +%y%m%dT%H%M%S)
echo !!!! Running Test $TESTID on server $SERVERTRC3 for $TESTDUR [s].
mtr -o "LSDRNBAWJMXI" -u -6 --report-wide -s 32 -c $NUNPACKETS -b -C $SERVERTRC3 > ${TESTNET}_${TESTID}_MRT_${WEATHER}_${DATESTR}.csv

# TEST 8: Route and latency server 4
TESTID=PERF08
DATESTR=$(date +%y%m%dT%H%M%S)
echo !!!! Running Test $TESTID on server $SERVERTRC4 for $TESTDUR [s].
mtr -o "LSDRNBAWJMXI" -u -6 --report-wide -s 32 -c $NUNPACKETS -b -C $SERVERTRC4 > ${TESTNET}_${TESTID}_MRT_${WEATHER}_${DATESTR}.csv
