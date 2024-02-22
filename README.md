# kube-prompt

Simple and customizable PS1 utility to show Kubernetes current context information.

Requires: `kubectl` command available in `PATH`

## Installation

```sh
curl -LO https://raw.githubusercontent.com/NeodymiumFerBore/kube-prompt/main/kube-prompt.sh
```

## Usage

Before your PS1 definition, source `kube-prompt.sh`, then use `__kube_ps1`.
Optionally, provide a format string to customize the output.

```sh
source /path/to/kube-prompt.sh

# Default output: (⎈|namespace)
export PS1='\u@\h \W $(__kube_ps1) \$ '

# With custom output: user@cluster:namespace:
export PS1='\u@\h \W $(__kube_ps1 "%u@%c:%n") \$ '

# Show only current context name
export PS1='\u@\h \W $(__kube_ps1 "%C") \$ '

# user@cluster:namespace with fancy colors
export PS1='\u@\h \W $(__kube_ps1 "\e[0;32m%u@%c\e[0m:\e[0;34m%n\e[0m") \$ '
```

## Testing before using

You can use the `testing/testing.sh` script to show examples of `__kube_ps1` usage.

```sh
$ cd testing/
$ export KUBECONFIG="$(pwd)"/kubeconfig

$ bash testing.sh
+ __kube_ps1
(⎈|frontend)

$ bash testing.sh 1
+ __kube_ps1 '[%C]'
[dev-frontend]

$ bash testing.sh 2
+ __kube_ps1 '%u@%c:%n'
developer@development:frontend

$ bash testing.sh 3 # Will render in bold blue
+ __kube_ps1 '\e[1;34m⎈|%n\e[0m'
⎈|frontend
```

To help building your new PS1, you can also provide custom format string:

`bash testing.sh '\e[0;32m%u@%c\e[0m: \e[0;34m%n\e[0m'`

```yaml
my-user@my-cluster: my-namespace
```

## Format

```man
%u - current context user name
%n - current context namespace
%c - current context cluster name
%C - current context name

If %n is used and current context namespace is not set, "default" will be printed.
```
