Networking
==========

Network related config.  The task enables ufw firewall, sets default
policy and allows for ssh, and configures the NetworkManager.

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

