#!/bin/bash
set +e
set -o noglob

#
# Headers and Logging
#

source ./src/helper.sh

STEP_PREFIX="WERCKER_BUILDNUMBER_GENERATOR"
step_var() {
  echo $(tmp=${STEP_PREFIX}_$1 && echo ${!tmp}) 
}


# Check python is installed
if type_exists 'python'
	then
	echo 'python installed'
elif type_exists 'php'
	then
	echo 'php installed'	
elif type_exists 'jq'
	then
	echo 'jq installed'	
else
  error "Please install python or PHP or jq"
  exit 1
fi

# Check variables
if [ -z "$(step_var 'BASE_URL')" ]; then
  error "Please set the 'base_url' variable"
  exit 1
fi

if [ -z "$(step_var 'API_KEY')" ]; then
  error "Please set the 'api_key' variable"
  exit 1
fi

if [ -z "$(step_var 'APP')" ]; then
  error "Please set the 'app' variable"
  exit 1
fi

if [ -z "$(step_var 'DIRECTORY')" ]; then
  error "Please set the 'directory' variable"
  exit 1
fi

source $STEP_DIR/src/main.sh \
					  -d "$(step_var 'DIRECTORY')" \
					  -U "$(step_var 'BASE_URL')" \
					  -a "$(step_var 'APP')" \
					  -k "$(step_var 'API_KEY')" \
					  -g "wercker" \
					  -s "$WERCKER_STARTED_BY" \
					  -c "$WERCKER_GIT_COMMIT"

			  