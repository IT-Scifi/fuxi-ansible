Networking
==========

Network related config, besides firewall (there is separate role for
firewall configs).

Requirements
------------

NetworkManager should be installed.


Role Variables
--------------

nm_config_file specifies the config file.  The default works in Debian
based distros.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - networking

License
-------

GPLv3+

