#!/bin/bash

echo "***************************************************************************************"
echo "*---------------------------------BEGIN LOAD TEST-------------------------------------*"
echo "***************************************************************************************"

if [ -z "$3" ]
then
  echo "Some parameters were not passed as a parameter, please refer to help document"
  #exit -1
else
  echo "APPLICATION_URL, TEST_DURATION and CONCURRENT_USER  were passed as a parameter"
  export APPLICATION_URL=$1
  export TEST_DURATION=$2
  export CONCURRENT_USER=$3
fi

export ENDPOINT=$APPLICATION_URL

echo "Application URL: $ENDPOINT"
echo "Test Duration: $TEST_DURATION"
echo "Concurrent User Count: $CONCURRENT_USER"


echo "Phase 1: Warming up - 30 seconds, 100 users."
./hey -z 30s -c 100 "$ENDPOINT"

echo "Waiting 1 seconds for the cluster to stabilize"
sleep 1

echo "\nPhase 2: Load test - 30 seconds, 400 users."
./hey -z 30s -c 400 "$ENDPOINT"

echo "Waiting 1 seconds for the cluster to stabilize"
sleep 1

echo "\nPhase 3: Load test - 30 seconds, 1600 users."
./hey -z 30s -c 1600 "$ENDPOINT"

echo "Waiting 1 seconds for the cluster to stabilize"
sleep 1

echo "\nLoad Test Phase - $TEST_DURATION minutes, $CONCURRENT_USER users."
./hey -z "${TEST_DURATION}m" -c $CONCURRENT_USER "$ENDPOINT"

echo "***************************************************************************************"
echo "*----------------------------------END LOAD TEST--------------------------------------*"
echo "***************************************************************************************"