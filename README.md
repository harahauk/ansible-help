
Ansible - Installation and execution help
=========================================

**NOTE:** This repo is very new and `NOT` ready for general consumption 

You can call it a `cheatsheet` or `general-support` for my other modules. Most information is derived from the [official documentation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) which is propably more than enough for most users.  
I guess what I am trying to say is that this repo is `propably` not relevant for you if you are not using any of my ansible-modules.  

This way I can also refer to some things I put/repeat in **all** my modules which isn't so easy to maintain.

Specifics for Windows
---------------------

This only applies if you are running `ansible control nodes` in Windows-environments (don't ask why anyone would do that).  
`ansible-vault` has not been good to me on *Windows* claiming something like this:  

```python
    if not os.get_blocking(fd):
           ^^^^^^^^^^^^^^^^^^^
OSError: [WinError 1] Incorrect function
```

There seems someone has actually made a package that works better:
`pipx install --include-deps ansible-vault-win`  
This propably works using regular old `pip` too, but I'm using `pipx`at the moment so there you go.
Still struggling with playbooks, but I'll figure it out..
