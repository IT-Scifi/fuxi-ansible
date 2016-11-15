Role Name
=========

admin role is for general administration stuff, like running the apt
updates etc.  Currently only apt update is implemented.  Cron thingies
should be under /etc/cron.{hourly,daily,weekly,monthly} and not under
/etc/cron.d, because anacron is used in laptops.


Role Variables
--------------

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
