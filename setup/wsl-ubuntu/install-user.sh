# Must have bashrc

if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
  echo "SSH connection to GitHub established."
else
  echo "SSH connection to GitHub failed."
  exit 1
fi


