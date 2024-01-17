#Effectuer une première connection SSH pour enregistrer fingerprint des nodes sinon Ansible râle

su - user-ansible
#se placer dans l'environnement virtuel python ansible
source ansible/bin/activate
# -m : module
# vérifie si connection ok
ansible -i inventaire.ini -m ping http1 --user root --ask-pass
# vérifie si python installé sur node
ansible -i inventaire.ini -m raw -a "apt install -y python3" --user root --ask-pass

#générer mdp chiffré
ansible localhost -i inventaire.ini -m debug -a "msg={{'passforce'|password_hash('sha512','secretsalt')}}"

#créer user-ansible sur tous les nodes
ansible -i inventaire.ini -m user -a 'name=user-ansible password=$6$secretsalt$X5YDmUgDphPxnMkByvHbNaiP4T5Uk0WjEZ9TukWKQnXmXN81jG3DcGZnNJiSz9ltgPhplH92HOR/RqgmyS.zN1' --user root --ask-pass all

#ajouter user-ansible au groupe sudo sur les tous les nodes
ansible -i inventaire.ini -m user -a 'name=user-ansible groups=sudo append=yes' --user root --ask-pass all

ansible-playbook -i inventaire.ini --user user-ansible --become --ask-become-pass install-apache.yml
