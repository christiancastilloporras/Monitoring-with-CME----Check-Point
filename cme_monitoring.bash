#!/bin/bash

: '
------- No supported in production -------
Enable monitoring blade
Needs to be run in Autoprovision template with "MONITORING" as a custom parameter
------- No supported in production -------
'

. /var/opt/CPshrd-R80.40/tmp/.CPprofile.sh

AUTOPROV_ACTION=$1
GW_NAME=$2
CUSTOM_PARAMETERS=$3

if [[ $AUTOPROV_ACTION == delete ]]
then
		exit 0
fi

if [[ $CUSTOM_PARAMETERS != MONITORING ]];
then
	exit 0
fi

if [[ $CUSTOM_PARAMETERS == MONITORING ]]
then

	echo "Connection to API server"
	SID=$(mgmt_cli -r true login -f json | jq -r '.sid')
	GW_JSON=$(mgmt_cli --session-id $SID show simple-gateway name $GW_NAME -f json)
	GW_UID=$(echo $GW_JSON | jq '.uid')
	
	echo "adding monitoring blade to $GW_NAME"
		
		mgmt_cli --session-id $SID set generic-object uid $GW_UID monitorBlade true
		
	echo "Publishing changes"
		mgmt_cli publish --session-id $SID
		
		exit 0
fi

exit 0
