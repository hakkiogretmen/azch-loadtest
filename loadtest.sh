#!/bin/bash

echo "***************************************************************************************"
echo "*---------------------------------BEGIN LOAD TEST-------------------------------------*"
echo "***************************************************************************************"

if [ -z "$1" ]
then
  echo "APPLICATION_URL was not passed as a parameter, assuming it is passed as environment variable"
else
  echo "APPLICATION_URL was passed as a parameter"
  export APPLICATION_URL=$1
fi

#export CONTENT_TYPE="Content-Type: application/json"
#export PAYLOAD='{"EmailAddress": "email@domain.com", "Product": "prod-1", "Total": 100}'
export ENDPOINT=$APPLICATION_URL

echo "GET $ENDPOINT"


echo "Phase 1: Warming up - 30 seconds, 100 users."
./hey -z 30s -c 100 "$ENDPOINT"

echo "Waiting 5 seconds for the cluster to stabilize"
sleep 5

echo "\nPhase 2: Load test - 30 seconds, 400 users."
./hey -z 30s -c 400 "$ENDPOINT"

echo "Waiting 5 seconds for the cluster to stabilize"
sleep 5

echo "\nPhase 3: Load test - 30 seconds, 1600 users."
./hey -z 30s -c 1600 "$ENDPOINT"

echo "Waiting 5 seconds for the cluster to stabilize"
sleep 5

echo "\nPhase 4: Load test - 30 seconds, 3200 users."
./hey -z 30s -c 3200 "$ENDPOINT"

echo "Waiting 15 seconds for the cluster to stabilize"
sleep 5

echo "\nPhase 5: Load test - 30 seconds, 6400 users."
./hey -z 30s -c 6400 "$ENDPOINT"

echo "***************************************************************************************"
echo "*----------------------------------END LOAD TEST--------------------------------------*"
echo "***************************************************************************************"