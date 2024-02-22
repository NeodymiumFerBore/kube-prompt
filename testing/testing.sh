#!/bin/bash

this_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
. "$this_dir"/../kube-prompt.sh

echo -n '+ __kube_ps1' >&2
case "$1" in
  1) echo " '[%C]'" >&2;              __kube_ps1 '[%C]' ;;
  2) echo " '%u@%c:%n'" >&2;          __kube_ps1 '%u@%c:%n' ;;
  3) echo " '\e[1;34m⎈|%n\e[0m'" >&2; __kube_ps1 '\e[1;34m⎈|%n\e[0m' ;;
  *) [ -n "$1" ] && (echo " '$1'" >&2; __kube_ps1 "$1") || (echo >&2; __kube_ps1) ;;
esac
echo
