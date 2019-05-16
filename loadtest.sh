#!/bin/bash

echo "***************************************************************************************"
echo "*---------------------------------BEGIN LOAD TEST-------------------------------------*"
echo "***************************************************************************************"

if [ -z "$2" ]
then
  echo "Neither SERVICE_IP nor sleep time was passed as a parameter, assuming it is passed as environment variable"
else
  echo "SERVICE_IP was passed as a parameter"
  export SERVICE_IP=$1
  export SLEEP_TIME=$2
fi

export CONTENT_TYPE="Content-Type: application/json"
export PAYLOAD='{"EmailAddress": "email@domain.com", "Product": "prod-1", "Total": 100}'
export ENDPOINT=http://$SERVICE_IP

echo "POST $ENDPOINT"
echo $CONTENT_TYPE
echo $PAYLOAD

echo "Phase 1: Warming up - 30 seconds, 100 users."
./hey -z 30s -c 100 -d "$PAYLOAD" -H "$CONTENT_TYPE" -m POST "$ENDPOINT"

echo "Waiting 15 seconds for the cluster to stabilize"
sleep $SLEEP_TIME

echo "\nPhase 2: Load test - 30 seconds, 400 users."
./hey -z 30s -c 400 -d "$PAYLOAD" -H "$CONTENT_TYPE" -m POST "$ENDPOINT"

echo "Waiting 15 seconds for the cluster to stabilize"
sleep $SLEEP_TIME

echo "\nPhase 3: Load test - 30 seconds, 1600 users."
./hey -z 30s -c 1600 -d "$PAYLOAD" -H "$CONTENT_TYPE" -m POST "$ENDPOINT"

echo "Waiting 15 seconds for the cluster to stabilize"
sleep $SLEEP_TIME

echo "\nPhase 4: Load test - 30 seconds, 3200 users."
./hey -z 30s -c 3200 -d "$PAYLOAD" -H "$CONTENT_TYPE" -m POST "$ENDPOINT"

echo "Waiting 15 seconds for the cluster to stabilize"
sleep $SLEEP_TIME

echo "\nPhase 5: Load test - 30 seconds, 6400 users."
./hey -z 30s -c 6400 -d "$PAYLOAD" -H "$CONTENT_TYPE" -m POST "$ENDPOINT"

echo "***************************************************************************************"
echo "*----------------------------------END LOAD TEST--------------------------------------*"
echo "***************************************************************************************"
