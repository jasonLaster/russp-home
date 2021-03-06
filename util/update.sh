#!/bin/sh

RUSSP_UPDATE=~/.russp-home-update


function _current_epoch() {
  echo $(($(date +%s) / 60 / 60 / 24))
}

function _update_russp_update() {
  echo "LAST_EPOCH=$(_current_epoch)" > $RUSSP_UPDATE
}

if [ -f $RUSSP_UPDATE ]
then
  . $RUSSP_UPDATE

  if [[ -z "$LAST_EPOCH" ]]; then
    _update_russp_update && return 0;
  fi

  epoch_diff=$(($(_current_epoch) - $LAST_EPOCH))
  if [ $epoch_diff -gt 1 ]
  then
    echo "Daily update of dot files...\c"
    ~/util/bin/update-dot-files
    echo "\n\n Don't forget to push your uncommitted changes!"

    # update the russp file
    _update_russp_update
  fi
else
  # create the russp file
  _update_russp_update
fi

