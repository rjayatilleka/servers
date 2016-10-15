set -o errexit
set -o nounset

user="$1"
host="$2"
ssh_target="${user}@${host}"

ssh $ssh_target 'sudo /bin/sh' < remote.sh
ssh -O exit $ssh_target
