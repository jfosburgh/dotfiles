git config --global user.email "jwfosburgh@gmail.com"
git config --global user.name "James Fosburgh"

ssh-keygen -t ed25519 -C "jwfosburgh@gmail.com"

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
