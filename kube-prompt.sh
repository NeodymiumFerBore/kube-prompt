# bash kubectl ps1 support
#
# NAME
#     __kube_ps1 - a kubectl utility for shell prompts
#
# SYNOPSIS
#     __kube_ps1 [FORMAT]
#
# DESCRIPTION
#     Print information from current context (using `kubectl config view --minify`),
#     with no trailing line feed.
#     Takes an optional format string as argument.
#     FORMAT can also be set with the environment variable KUBE_PS1_FORMAT.
#
# DEFAULTS
#     If no FORMAT is given, print (⎈|%n) (current context namespace with '⎈|' prefix, in parentheses).
#     If no current_context is defined in KUBECONFIG, print "context not set"
#
# ARGUMENTS
#     FORMAT     An optional format string (see FORMAT). Default: (⎈|%n).
#                Takes precedence over environment variable KUBE_PS1_FORMAT.
#
# FORMAT
#     %u - current context user name
#     %n - current context namespace
#     %c - current context cluster name
#     %C - current context name
#
#     If %n is used and current context namespace is not set, "default" will be printed.
#
# EXAMPLES
#   __kube_ps1
#   Output: (⎈|my-namespace)
#
#   __kube_ps1 '[%C]'
#   Output: [my-super-current-context]
#
#   __kube_ps1 '%u@%c:%n'
#   Output: me@my-cluster:my-namespace
#
#   __kube_ps1 '\e[1;34m⎈|%n\e[0m'
#   Output in bold blue: ⎈|my-namespace

function __kube_ps1() {
  local format="${KUBE_PS1_FORMAT-(⎈|%n)}" # Expand default if unset, but respect empty string
  local format="${1-$format}"
  local context user cluster namespace

  # If a format string was supplied without any value to substitute, just print it and return
  if ! grep -Eq '%[uncC]' <<<"$format"; then
    printf -- "$format"
    return
  fi

  # It is important that "namespace" is queried last, as it may be empty
  # --minify shows only config relevant to current context: avoids running conditional query
  read -r context user cluster namespace <<<"$(kubectl \
    config view --minify -o jsonpath="{.contexts..['name','user','cluster','namespace']}" 2>/dev/null)"

  # If there is no current context, print "context not set" and return
  if [ -z "$context" ]; then
    printf -- "context not set"
    return
  fi

  format="$(sed \
    -e "s/%u/${user}/g" \
    -e "s/%n/${namespace:-default}/g" \
    -e "s/%c/${cluster}/g" \
    -e "s/%C/${context}/g" \
    <<<"$format")"
  printf -- "$format"
}
