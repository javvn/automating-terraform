#!/bin/bash

readonly TF_TOKEN_PATH="$HOME/.terraformrc";
readonly PAYLOAD="scripts/payload.json"
readonly RUN_COMMAND=$1
readonly TF_TOKEN_FILE="scripts/.tfe_token"

function containsElement () {
  local e match="$1"

  shift

  for e;  do [[ "$e" == "$match" ]] && return 0; done

  return 1
}

function check_run_command() {
    local commands=("create" "remove")

    if ! containsElement "$RUN_COMMAND" "${commands[@]}" ; then
        echo "Please select run command(create/remove): ex) ./tfe-token-run.sh create"
        exit 1
    fi
}

function get_token() {
  local token;

  token="$(grep 'token' "$TF_TOKEN_PATH" | cut -f 2 -d '"')"

  [[ -z "$token" ]] && echo "Not found token" && exit 1

  echo "$token"
}

function get_account_id() {
  local account_id;

  account_id="$(curl -s --header "Authorization: Bearer $1" --header "Content-Type: application/vnd.api+json" --request GET "https://app.terraform.io/api/v2/account/details" | jq .data.id -r)"

  [[ "$account_id" == "null" ]] && echo "Not found account id" && exit 1

  echo "$account_id"
}

function check_tfe_token() {
  local token account_id result data token_name;

  token=$(get_token)
  account_id=$(get_account_id "$token")
  token_name=$(jq -r '.data.attributes.description' < $PAYLOAD)

  result=$(curl \
               -s \
               --header "Authorization: Bearer $token" \
               --header "Content-Type: application/vnd.api+json" \
               --request GET \
               "https://app.terraform.io/api/v2/users/$account_id/authentication-tokens")

  data=$(jq --arg TOKEN_NAME "$token_name" '.data[] | select(.attributes.description == $TOKEN_NAME)' <<< "$result" )

  [[ -n "$data" ]] && return 0;

  return 1
}

function get_tfe_token_id_by_name() {
  local token account_id token_name results token_id;

  token=$(get_token)
  account_id=$(get_account_id "$token")
  token_name=$(jq -r '.data.attributes.description' < $PAYLOAD)

  if ! check_tfe_token ; then
      echo "Not existed token." && exit 1;
    else
      results=$(curl \
                     -s \
                     --header "Authorization: Bearer $token" \
                     --header "Content-Type: application/vnd.api+json" \
                     --request GET \
                     "https://app.terraform.io/api/v2/users/$account_id/authentication-tokens")

      token_id=$(jq -r --arg TOKEN_NAME "$token_name" '.data[] | select(.attributes.description == $TOKEN_NAME) | .id' <<< "$results" )

      echo "$token_id"
  fi
}

function create_tfe_token() {
  local token account_id;

  token=$(get_token)
  account_id=$(get_account_id "$token")

  if ! check_tfe_token ; then
      (curl \
        -s \
        --header "Authorization: Bearer $token" \
        --header "Content-Type: application/vnd.api+json" \
        --request "POST" \
        --data "$(cat $PAYLOAD)" \
        "https://app.terraform.io/api/v2/users/$account_id/authentication-tokens" | jq -r .data.attributes.token) > $TF_TOKEN_FILE && echo "Created token !"
    else
      echo "Can't be create token. because existed token with same name"
  fi
}

function remove_tfe_token() {
  local token account_id;

  token=$(get_token)
  token_id=$(get_tfe_token_id_by_name)

  curl \
    --header "Authorization: Bearer $token" \
    --header "Content-Type: application/vnd.api+json" \
    --request DELETE \
    "https://app.terraform.io/api/v2/authentication-tokens/$token_id" && rm $TF_TOKEN_FILE && echo "The User Token was successfully destroyed !"
}

function execute_command() {
    if [ "$RUN_COMMAND" == "create" ]; then
        create_tfe_token
    elif [ "$RUN_COMMAND" == "remove" ]; then
        remove_tfe_token
    fi
}

check_run_command
execute_command