
Ansible - Installation and execution help
=========================================

**NOTE:** This repo is very new and `NOT` ready for general consumption

This is effectively a `cheatsheet` or `general-support` for my other modules. Most information is derived from the [official documentation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) which is propably more than enough for most users.  
The main component of the repo is the `install_ansible.sh`-script which I source in a lot of automations.

This way I can also refer to some things I put/repeat in **all** my modules which isn't so easy to maintain.

Documentation
=============

Below follows some notes specific to my usage of Ansible for later reference.


Specifics for Windows
---------------------

This only applies if you are running `ansible control nodes` in Windows-environments (don't ask why anyone would do that).  
`ansible-vault` has not been good to me on *Windows*, I've later discovered that support for Windows never really
existed in the first place. The error is identified by:  
```python
    if not os.get_blocking(fd):
           ^^^^^^^^^^^^^^^^^^^
OSError: [WinError 1] Incorrect function
```

Someone has went to the trouble of making a package that works better:  
`pipx install --include-deps ansible-vault-win`  
This propably works using regular old `pip` too, but I'm using `pipx`at the moment so there you go.
Still struggling with playbooks, but I'll figure it out..
