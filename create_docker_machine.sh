set -e

IP=some_ip
NAME=some_name
MACHINE_NAME=some_name

ssh -o 'IdentitiesOnly yes' -t root@$IP "adduser $NAME; usermod -aG sudo $NAME; exit"

echo "User created"

ssh-keygen -f ~/.ssh/$NAME -q -N ""
ssh-copy-id -i ~/.ssh/$NAME -o 'IdentitiesOnly yes' $NAME@$IP

echo "SSH key set"

ssh -o 'IdentitiesOnly yes' -t $NAME@$IP "echo \"$NAME  ALL=(ALL) NOPASSWD:ALL\" | sudo tee -a /etc/sudoers > /dev/null; exit"

echo "No password on sudo"

docker-machine create --driver generic --generic-ip-address=$IP --generic-ssh-key ~/.ssh/$NAME --generic-ssh-user=$NAME $MACHINE_NAME
