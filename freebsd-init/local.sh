ssh $USERHOST 'sudo su' < remote.sh \
  && scp .bash_profile $USERHOST:~/ \
  && scp .bashrc $USERHOST:~/ \
  && ssh -O exit $USERHOST
