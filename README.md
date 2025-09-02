Ansible Installation and execution help
=======================================
You can call it a `cheatsheet` or "general-support" for my other modules. Most is derived from the [official documentation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) which is propably more than enough for most users.   
This way I can also refer to some things I put/repeat in **all** my modules which isn't so easy to maintain.

# Specifics for Windows
This only applies if you are running `ansible control nodes`in Windows-environments.  
`ansible-vault` has not been good to me on *Windows* laiming *no blocking* or similar, there seems someone has actually made a package that works better:
`pipx install --include-deps ansible-vault-win`  
This propably works using regular old pip too, but I'm using `pipx`at the moement so there you go.