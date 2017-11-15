#!/bin/bash
#
# setup_codesign.sh
#
# Matcha 1.0, Created by gradyzhuo, enoch_lee.
# Copyright © 2017, Matcha Inc. All rights reserved.
#

will_exec "setup_codesign"

configure_signing_identity

PROVISIONING_PROFILE="profile"
#===== Provision Profile =====

declare option="$EXPORT_OPTION"

if [[ $AUTOMATICALLY_MANAGE_SIGNING == 0 ]]; then
    option="all"
fi

if [[ $NEED_DOWNLOAD_PROVISION_PROFILE == 0 ]]; then
  PROVISIONING_PROFILE_FILE="$PROVISIONING_PROFILE_CONFIGURATION_FOLDER/$PROVISIONING_PROFILE"
  phase_print "Downloading provision profile"
  profile download -fetch "$PROVISIONING_PROFILE_NAME" -option "$option" -id "$APPLE_ID" -passwd "$APPLE_ID_PASSWORD" -app_id "$APP_ID" -team "$TEAM_NAME" -output "$PROVISIONING_PROFILE_FILE"
fi

profile install -profile "$PROVISIONING_PROFILE_FILE"

PROVISIONING_PROFILE_NAME=$(profile showName -profile "$PROVISIONING_PROFILE_FILE")
print -c green "downloaded provision profile: $PROVISIONING_PROFILE_NAME"

if [[ $AUTOMATICALLY_MANAGE_SIGNING != 0 && "$PROVISIONING_PROFILE_UUID" == "" ]]; then
  phase_print "Fetching UUID"
  PROVISIONING_PROFILE_UUID=$(profile showUUID -profile "$PROVISIONING_PROFILE_FILE")
  print -c green "using provision profile: $PROVISIONING_PROFILE_NAME($PROVISIONING_PROFILE_UUID)"
fi

if [[ $NEED_DOWNLOAD_PROVISION_PROFILE == 0 ]]; then
  profile clean -profile "$PROVISIONING_PROFILE_FILE"
fi

did_exec "setup_codesign"
