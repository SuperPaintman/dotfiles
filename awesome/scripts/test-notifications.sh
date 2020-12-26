#!/usr/bin/env bash

SOURCE_ROOT="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

cat "${SOURCE_ROOT}/test-notifications.lua" | awesome-client
