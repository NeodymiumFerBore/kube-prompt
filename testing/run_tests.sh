#!/bin/bash

this_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
testing="bash ${this_dir}/testing.sh"

unset KUBE_PS1_FORMAT

#################### TESTING ARG ####################

printf '\nShould output %s\n' '%u@%c:%n'
$testing %u@%c:%n

printf '\nShould output toto\n'
$testing toto

printf '\nShould output nothing\n'
$testing ''

printf '\nShould output default\n'
$testing

#################### TESTING ENV ####################

printf '\n# Now using KUBE_PS1_FORMAT\n'

export KUBE_PS1_FORMAT='%u@%c:%n'
printf '\nShould output %s\n' '%u@%c:%n'
$testing

export KUBE_PS1_FORMAT='toto'
printf '\nShould output toto\n'
$testing

export KUBE_PS1_FORMAT=
printf '\nShould output nothing\n'
$testing

unset KUBE_PS1_FORMAT
printf '\nShould output default\n'
$testing

#################### TESTING ENV OVERRIDE VIA ARG ####################

printf '\n# Now overriding KUBE_PS1_FORMAT\n'

export KUBE_PS1_FORMAT=tutu

printf '\nShould output %s\n' '%u@%c:%n'
$testing %u@%c:%n

printf '\nShould output toto\n'
$testing toto

printf '\nShould output nothing\n'
$testing ''
