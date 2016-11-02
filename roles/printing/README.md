Printing
========

Role for adding University AD print queues to CUPS.

Role Variables
--------------

Default variables are
ad_print_file: path of the SmartCard PPD file
ad_touch_file: path of the bookkeeping file.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - priting

License
-------

GPLv3+ (except the files/smartcard-ps.ppd which is proprietary)

