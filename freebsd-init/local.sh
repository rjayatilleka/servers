set -o errexit
set -o nounset

host="$1"
bootstrap_user="$2"
primary_user="$3"
pub_key_file="$4"

bootstrap_target="${bootstrap_user}@${host}"
primary_target="${primary_user}@${host}"

ssh "$bootstrap_target" 'sudo /bin/sh' < bootstrap.sh
ssh "$bootstrap_target" 'sudo -u ramith sh -c "cat > /home/ramith/.ssh/authorized_keys"' < "$pub_key_file"


# Kill control master 
ssh -O exit "$bootstrap_target"
ssh -O exit "$primary_target"
