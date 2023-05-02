#!/usr/bin/env bash
#  [% VIM_TAGS %]
#
#  Author: Hari Sekhon
#  Date: [% DATE # 2008-10-20 16:20:39 +0100 (Mon, 20 Oct 2008) %]
#
#  [% URL %]
#
#  [% LICENSE %]
#
#  [% MESSAGE %]
#
#  [% LINKEDIN %]
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
TODO: DESCRIPTION
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="arg [<options>]"

help_usage "$@"

min_args 1 "$@"

host="${BLAH_HOST:-${HOST:-localhost}}"
port="${BLAH_PORT:-${PORT:-80}}"

check_env_defined "API_TOKEN"

until [ $# -lt 1 ]; do
    case $1 in
    -H|--host)  host="${2:-}"
                shift || :
                ;;
    -P|--port)  port="${2:-}"
                shift || :
                ;;
    -h|--help)  usage
                ;;
            *)  usage "unknown argument: $1"
                ;;
    esac
    shift || :
done

if [ -z "$host" ]; then
    usage "--host not defined"
elif [ -z "$port" ]; then
    usage "--port not defined"
fi
