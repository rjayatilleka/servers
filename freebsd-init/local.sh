#!/bin/sh

set -o errexit
set -o nounset

for i in "$@"
do
case $i in
    --host=*)
      host="${i#*=}"
      shift # past argument=value
    ;;
    --bootstrap-user=*)
      bootstrap_user="${i#*=}"
      shift # past argument=value
    ;;
    --primary-user=*)
      primary_user="${i#*=}"
      shift # past argument=value
    ;;
    --primary-name=*)
      primary_name="${i#*=}"
      shift # past argument=value
    ;;
    --pub-key-file=*)
      pub_key_file="${i#*=}"
      shift # past argument=value
    ;;
    *) # unknown option
      printf "Unknown option: %s\n" "$i"
      exit 1
    ;;
esac
done

pub_key_file="${pub_key_file:-$HOME/.ssh/id_rsa.pub}"

printf "%-16s\t%s\n" \
  "Host" "$host" \
  "Bootstrap User" "$bootstrap_user" \
  "Primary User" "$primary_user" \
  "Primary Name" "$primary_name" \
  "Pub key file" "$pub_key_file"
printf "%s\n" "------------------"
exit

printf "WOAH"

bootstrap_target="${bootstrap_user}@${host}"
primary_target="${primary_user}@${host}"

scp bootstrap.sh setup_primary_home.sh "$bootstrap_target:~"
scp "$pub_key_file" "$bootstrap_target:~/authorized_keys"

ssh "$bootstrap_target" "sudo /bin/sh ./bootstrap.sh $primary_user $primary_name"
ssh "$bootstrap_target" "sudo -u $primary_user /bin/sh $bootstrap_user"

# Kill control master 
ssh -O exit "$bootstrap_target"
ssh -O exit "$primary_target"
