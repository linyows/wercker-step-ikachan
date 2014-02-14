if [ ! -n "$WERCKER_IKACHAN_SERVER" ]; then
  error 'Please specify server property'
  exit 1
fi

if [ ! -n "$WERCKER_IKACHAN_PORT" ]; then
  error 'Please specify port property'
  exit 1
fi

if [ ! -n "$WERCKER_IKACHAN_CHANNEL" ]; then
  error 'Please specify channel property'
  exit 1
fi

if [ ! -n "$DEPLOY" ]; then
  export WERCKER_JOB_TARGET=$WERCKER_GIT_BRANCH
  export WERCKER_JOB_URL=$WERCKER_BUILD_URL
  export WERCKER_JOB_TYPE='build'
else
  export WERCKER_JOB_TARGET=$WERCKER_DEPLOYTARGET_NAME
  export WERCKER_JOB_URL=$WERCKER_DEPLOY_URL
  export WERCKER_JOB_TYPE='deploy'
fi

if [ "$WERCKER_RESULT" = "passed" ]; then
  if [ ! -n "$WERCKER_IKACHAN_PASSED_MESSAGE" ]; then
    export WERCKER_IKACHAN_MESSAGE="$WERCKER_IKACHAN_PASSED_MESSAGE"
  fi
else
  if [ ! -n "$WERCKER_IKACHAN_FAILED_MESSAGE" ]; then
    export WERCKER_IKACHAN_MESSAGE="$WERCKER_IKACHAN_FAILED_MESSAGE"
  fi
fi

if [ "$WERCKER_IKACHAN_ON" = "failed" ]; then
  if [ "$WERCKER_RESULT" = "passed" ]; then
    echo "Skipping.."
    return 0
  fi
fi

ruby "$WERCKER_STEP_ROOT/main.rb" \
    "$WERCKER_IKACHAN_SERVER" \
    "$WERCKER_IKACHAN_PORT" \
    "$WERCKER_IKACHAN_CHANNEL" \
    "$WERCKER_IKACHAN_MESSAGE" \
    "$WERCKER_APPLICATION_NAME"
    "$WERCKER_STARTED_BY" \
    "$WERCKER_JOB_TARGET" \
    "$WERCKER_JOB_URL" \
    "$WERCKER_JOB_TYPE" \
    "$WERCKER_RESULT"
