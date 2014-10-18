#!/bin/bash

validate_key() {
  local private_key=$1;

  if [ -z "$private_key" ]; then
    fail "Private key not found. Do not prepend the keyname with a dollar sign and do not use _PRIVATE at the end.";
  fi
}

main() {
  local ssh_key_path=$(mktemp);

  local private_key=$(eval echo "\$${WERCKER_ADD_SSH_KEY_KEYNAME}_PRIVATE");

  echo "print all envs:"
  printenv
  echo "private key: $private_key:"

  validate_key "$private_key";

  echo -e "$private_key" > $ssh_key_path

  # Add for current user
  $WERCKER_STEP_ROOT/addKey.sh $HOME $USER $ssh_key_path

  # Also add it for root
  sudo $WERCKER_STEP_ROOT/addKey.sh /root root $ssh_key_path
}

main;
