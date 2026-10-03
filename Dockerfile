# Creates a Docker-image with Ansible and Git
FROM almalinux
WORKDIR .

COPY install_ansible.sh ./
RUN dnf update -y && dnf install -y git
RUN chmod +x ./install_ansible.sh && ./install_ansible.sh
CMD ["bash"]

