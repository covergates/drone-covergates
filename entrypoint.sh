#/bin/sh -l
set -e

if [ ! -z "$PLUGIN_API_URL" -a "$PLUGIN_API_URL" != " " ]; then
  export API_URL=$PLUGIN_API_URL
fi
export REPORT_ID=$PLUGIN_REPORT_ID
covergates upload --type $PLUGIN_TYPE $PLUGIN_REPORT

if [[ -n "$PLUGIN_COMMENT" ]] && [[ -n  -n "$DRONE_PULL_REQUEST"]]; then
  covergates comment
fi
