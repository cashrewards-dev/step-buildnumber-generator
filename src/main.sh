#!/bin/bash
set +e
set -o noglob

source $STEP_DIR/src/helper.sh

while getopts ":U:k:g:u:a:s:b:c:d:" opt; do
  case $opt in
    U) _BASE_URL="${OPTARG%/}"
    ;;
    k) _API_KEY="$OPTARG"
    ;;
    g) _USER_AGENT="$OPTARG"
    ;;    
    u) _USERNAME="$OPTARG"
    ;;
    a) _APP="$OPTARG"
    ;;
    s) _STARTED_BY="$OPTARG"
    ;;
    c) _GIT_COMMIT_HASH="$OPTARG"
    ;;
    d) _DIRECTORY="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;  
  esac
done

echo 'URL='$_BASE_URL/$_APP

export _BUILD_INFO=$(curl -H "x-api-key:${_API_KEY}" \
    -d "{\"user_agent\": \"${_USER_AGENT}\", \"started_by\": \"${_STARTED_BY}\", \"commit_hash\": \"${_GIT_COMMIT_HASH}\"}" \
    -X POST ${_BASE_URL}/${_APP}) 

echo "$_BUILD_INFO" > "$_DIRECTORY/.build_info"
cat $_DIRECTORY/.build_info

# Parse response and get build number
if type_exists 'python'
  then
  echo $_BUILD_INFO | python -c "import sys, json; print json.load(sys.stdin)['buildnumber']" > "$_DIRECTORY/.build_number"  
elif type_exists 'php'
  then
  echo $_BUILD_INFO | php -r '$a =json_decode(file_get_contents("php://stdin"), true); echo $a["buildnumber"];' > "$_DIRECTORY/.build_number"
elif type_exists 'jq'
  then
  echo $_BUILD_INFO | jq -r '.buildnumber' > "$_DIRECTORY/.build_number"
else
  error "Please install python or PHP"
fi

export _BUILDNUMBER="$(cat $_DIRECTORY/.build_number)"
echo _BUILDNUMBER="$_BUILDNUMBER"





# GENERATED_BUILD_NR=$($WERCKER_STEP_ROOT/src/fetch.py 
#       \ -U $(step_var 'BASE_URL')
#       \ -k $(step_var 'API_KEY')      
#       \ -u $(step_var 'USERNAME')
#       \ -a $(step_var 'APP') 
#       \ -g $WERCKER_STARTED_BY      
#       \ -b $WERCKER_GIT_BRANCH 
#       \ -c $WERCKER_GIT_COMMIT)


# if [[ "$GENERATED_BUILD_NR" = "" ]]; then
#   echo ""
#   echo "Failed to get build number" 1>&2

#   return 1 2>/dev/null || exit 1
# else
#   echo "\$GENERATED_BUILD_NR: $GENERATED_BUILD_NR"
# fi
