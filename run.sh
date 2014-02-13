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

if [ ! -n "$WERCKER_IKACHAN_FAILED_MESSAGE" ]; then
  if [ ! -n "$DEPLOY" ]; then
    export WERCKER_IKACHAN_FAILED_MESSAGE="Wercker ($WERCKER_APPLICATION_NAME): build of $WERCKER_GIT_BRANCH by $WERCKER_STARTED_BY failed. $WERCKER_BUILD_URL"
  else
    export WERCKER_IKACHAN_FAILED_MESSAGE="Wercker ($WERCKER_APPLICATION_NAME): deploy to $WERCKER_DEPLOYTARGET_NAME by $WERCKER_STARTED_BY failed. $WERCKER_DEPLOY_URL"
  fi
fi

if [ ! -n "$WERCKER_IKACHAN_PASSED_MESSAGE" ]; then
  if [ ! -n "$DEPLOY" ]; then
    export WERCKER_IKACHAN_PASSED_MESSAGE="Wercker ($WERCKER_APPLICATION_NAME): build of $WERCKER_GIT_BRANCH by $WERCKER_STARTED_BY passed."
  else
    export WERCKER_IKACHAN_PASSED_MESSAGE="Wercker ($WERCKER_APPLICATION_NAME): deploy to $WERCKER_DEPLOYTARGET_NAME by $WERCKER_STARTED_BY passed."
  fi
fi

if [ "$WERCKER_RESULT" = "passed" ]; then
  export WERCKER_IKACHAN_MESSAGE="$WERCKER_IKACHAN_PASSED_MESSAGE"
else
  export WERCKER_IKACHAN_MESSAGE="$WERCKER_IKACHAN_FAILED_MESSAGE"
fi

if [ "$WERCKER_IKACHAN_ON" = "failed" ]; then
  if [ "$WERCKER_RESULT" = "passed" ]; then
    echo "Skipping.."
    return 0
  fi
fi

ruby "$WERCKER_STEP_ROOT/main.rb" "$WERCKER_IKACHAN_SERVER" "$WERCKER_IKACHAN_PORT" "$WERCKER_IKACHAN_CHANNEL" "$WERCKER_IKACHAN_MESSAGE"
