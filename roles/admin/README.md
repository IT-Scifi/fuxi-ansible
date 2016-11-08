Role Name
=========

admin role is for general administration stuff, like running the apt
updates etc.  Currently only apt update is implemented.


Role Variables
--------------

fuxi_update_schedule: cron timing for fuxi-update.sh script
admin_cron_user: The user for cron jobs.
admin_logfile: The log file for admin stuff.


Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - admin

License
-------

GPLv3+

Author Information
------------------

Pekko Metsä <pekko.metsa@helsinki.fi>
