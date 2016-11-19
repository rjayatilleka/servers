#!/bin/sh

set -o errexit
set -o nounset

while read i; do
  echo $i
  case $i in
      host=*)
        host="${i#*=}"
      ;;
      bootstrap-user=*)
        bootstrap_user="${i#*=}"
      ;;
      primary-user=*)
        primary_user="${i#*=}"
      ;;
      primary-name=*)
        primary_name="${i#*=}"
      ;;
      pub-key-file=*)
        pub_key_file="${i#*=}"
      ;;
      *) # unknown option
        printf "Unknown option: %s\n" "$i"
        exit 1
      ;;
  esac
done < "$1"

printf "%-16s\t%s\n" \
  "Host" "$host" \
  "Bootstrap User" "$bootstrap_user" \
  "Primary User" "$primary_user" \
  "Primary Name" "$primary_name" \
  "Pub key file" "$pub_key_file"
printf "%s\n" "------------------"

###############################################################################
### Args parsed, here's the code

tag="[main]"

bootstrap_target="${bootstrap_user}@${host}"
primary_target="${primary_user}@${host}"

printf "$tag Copying files\n"
scp bootstrap.sh setup_home.sh "$bootstrap_target:~"
scp "$pub_key_file" "$bootstrap_target:~/authorized_keys"

printf "$tag Running bootstrap.sh\n"
ssh "$bootstrap_target" "sudo /bin/sh ./bootstrap.sh $primary_user '$primary_name'"

printf "$tag Running setup_home.sh\n"
ssh "$bootstrap_target" "sudo -u $primary_user /bin/sh /home/$bootstrap_user/setup_home.sh $bootstrap_user"

printf "$tag Running setup_env.sh\n"
ssh "$bootstrap_target" "sudo -u $primary_user /bin/sh" < setup_env.sh

printf "$tag Done.\n"
