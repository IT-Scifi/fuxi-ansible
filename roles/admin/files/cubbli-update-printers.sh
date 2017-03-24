#!/bin/bash

# This scripts attempts to keep a sane default printer list on
# Cubbli Linux hosts.
# JJ 22.2.2016

DEFAULT_PPD=/usr/share/ppd/cubbli/cubbli-default.ppd
lists="/var/lib/cubbli/hyadprinters"

# JJ: could not figure how to do this when packaging files
chmod go-rwx /usr/lib/cups/backend/krbsmb 

# Fetch printer list
mkdir -p /var/cache/cubbli-printers && 
chmod a+rx /var/cache/cubbli-printers && 
export KRB5CCNAME=FILE:/var/cache/cubbli-printers/krb5cc.$$
kinit -k && {
  ldapsearch -o ldif-wrap=no -b OU=rps,OU=canon,OU=tulostus,OU=mvPalvelut,DC=ad,DC=helsinki,DC=fi objectClass=printQueue location 2> /dev/null |
    grep -i -B 2 location > /var/cache/cubbli-printers/printers.list.new
  if [ -s /var/cache/cubbli-printers/printers.list.new ]; then
    mv /var/cache/cubbli-printers/printers.list.new /var/cache/cubbli-printers/printers.list
    logger -t "$0" "Fetched new printer list"
  fi
  kdestroy
}

								
# Check out this list
if false && hostname --fqdn | egrep -q '.cs.helsinki.fi$'; then
  /usr/sbin/lpadmin -p cs-a239a -P /usr/share/ppd/cubbli/cel-iradvc5250-ps-en-jj.ppd -L 'Gustaf Hällströminkatu 2B Exactum, 2.kerros, A239a' -D "Unigrafia's printer MKQA801178" -v krbsmb://ATKK/HOPEAKUUSI1.ad.helsinki.fi/MKQA801178 -o printer-is-shared=false -E
  /usr/sbin/lpadmin -p cs-d240b -P /usr/share/ppd/cubbli/cel-iradvc5250-ps-en-jj.ppd -L 'Gustaf Hällströminkatu 2B Exactum, 2.kerros, D240b' -D "Unigrafia's printer MKQA804399" -v krbsmb://ATKK/HOPEAKUUSI1.ad.helsinki.fi/MKQA804399 -o printer-is-shared=false -E
  /usr/sbin/lpadmin -p cs-d221 -P /usr/share/ppd/cubbli/cel-iradvc5250-ps-en-jj.ppd -L 'Gustaf Hällströminkatu 2B Exactum, 2.kerros, D221' -D "Unigrafia's printer MXDA015257" -v krbsmb://ATKK/VALKOKUUSI1.ad.helsinki.fi/MXDA015257 -o printer-is-shared=false -E
  /usr/sbin/lpadmin -p cs-a239b -P /usr/share/ppd/cubbli/cel-iradvc5250-ps-en-jj.ppd -L 'Gustaf Hällströminkatu 2B Exactum, 2.kerros, A239b' -D "Unigrafia's printer MKQA804039" -v krbsmb://ATKK/HOPEAKUUSI1.ad.helsinki.fi/MKQA804039 -o printer-is-shared=false -E
  /usr/sbin/lpadmin -p cs-c227 -P /usr/share/ppd/cubbli/cel-iradvc5250-ps-en-jj.ppd -L 'Gustaf Hällströminkatu 2B Exactum, 2.kerros, C227' -D "Unigrafia's printer MXDA016407" -v krbsmb://ATKK/VALKOKUUSI1.ad.helsinki.fi/MXDA016407 -o printer-is-shared=false -E
  /usr/sbin/lpadmin -p cs-d243 -P /usr/share/ppd/cubbli/cel-iradvc5250-ps-en-jj.ppd -L 'Gustaf Hällströminkatu 2B Exactum, 2.kerros, D243' -D "Unigrafia's printer MKQA801335" -v krbsmb://ATKK/HOPEAKUUSI1.ad.helsinki.fi/MKQA801335 -o printer-is-shared=false -E
  /usr/sbin/lpadmin -p cs-b223 -P /usr/share/ppd/cubbli/cel-iradvc5250-ps-en-jj.ppd -L 'Gustaf Hällströminkatu 2B Exactum, 2.kerros, B223' -D "Unigrafia's printer MXDA015256" -v krbsmb://ATKK/VALKOKUUSI1.ad.helsinki.fi/MXDA015256 -o printer-is-shared=false -E
  /usr/sbin/lpadmin -p cs-d238 -P /usr/share/ppd/cubbli/cel-iradvc5250-ps-en-jj.ppd -L 'Gustaf Hällströminkatu 2B Exactum, 2.kerros, D238' -D "Unigrafia's printer MKQA003765" -v krbsmb://ATKK/HOPEAKUUSI1.ad.helsinki.fi/MKQA003765 -o printer-is-shared=false -E
  /usr/sbin/lpadmin -p cs-a219 -P /usr/share/ppd/cubbli/cel-iradvc5250-ps-en-jj.ppd -L 'Gustaf Hällströminkatu 2B Exactum, 2.kerros, A219' -D "Unigrafia's printer MKQA804362" -v krbsmb://ATKK/VALKOKUUSI1.ad.helsinki.fi/MKQA804362 -o printer-is-shared=false -E
  /usr/sbin/lpadmin -p cs-a242 -P /usr/share/ppd/cubbli/cel-iradvc5250-ps-en-jj.ppd -L 'Gustaf Hällströminkatu 2B Exactum, 2.kerros, A242' -D "Unigrafia's printer MXDA015261" -v krbsmb://ATKK/HOPEAKUUSI1.ad.helsinki.fi/MXDA015261 -o printer-is-shared=false -E
  /usr/sbin/lpadmin -p cs-c230a -P /usr/share/ppd/cubbli/cel-iradvc5250-ps-en-jj.ppd -L 'Gustaf Hällströminkatu 2B Exactum, 2.kerros, C230a' -D "Unigrafia's printer MKQA804576" -v krbsmb://ATKK/HOPEAKUUSI1.ad.helsinki.fi/MKQA804576 -o printer-is-shared=false -E
  /usr/sbin/lpadmin -p cs-c230b -P /usr/share/ppd/cubbli/cel-iradvc5250-ps-en-jj.ppd -L 'Gustaf Hällströminkatu 2B Exactum, 2.kerros, C230b' -D "Unigrafia's printer MKQA804578" -v krbsmb://ATKK/VALKOKUUSI1.ad.helsinki.fi/MKQA804578 -o printer-is-shared=false -E
  /usr/sbin/lpadmin -p cs-d239 -P /usr/share/ppd/cubbli/cel-iradvc5250-ps-en-jj.ppd -L 'Gustaf Hällströminkatu 2B Exactum, 2.kerros, D239' -D "Unigrafia's printer MKQA801671" -v krbsmb://ATKK/HOPEAKUUSI1.ad.helsinki.fi/MKQA801671 -o printer-is-shared=false -E
  /usr/sbin/lpadmin -p cs-a230 -P /usr/share/ppd/cubbli/cel-iradvc5250-ps-en-jj.ppd -L 'Gustaf Hällströminkatu 2B Exactum, 2.kerros, A230' -D "Unigrafia's printer MKQA804050" -v krbsmb://ATKK/HOPEAKUUSI1.ad.helsinki.fi/MKQA804050 -o printer-is-shared=false -E
  /usr/sbin/lpadmin -p cs-b221 -P /usr/share/ppd/cubbli/cel-iradvc5250-ps-en-jj.ppd -L 'Gustaf Hällströminkatu 2B Exactum, 2.kerros, B221 Sali' -D "Unigrafia's printer MXDA014722" -v krbsmb://ATKK/VALKOKUUSI1.ad.helsinki.fi/MXDA014722 -o printer-is-shared=false -E  
  /usr/sbin/lpadmin -p cs-a317 -P /usr/share/ppd/cubbli/cel-iradvc5250-ps-en-jj.ppd -L 'Gustaf Hällströminkatu 2B Exactum, 3.kerros, A317' -D "Unigrafia's printer MXDA016411" -v krbsmb://ATKK/VALKOKUUSI1.ad.helsinki.fi/MXDA016411 -o printer-is-shared=false -E
fi

# Destroy and recreate smartcard-ps class
lpadmin -x smartcard-ps 2> /dev/null
# Always add kerberised smartcard-ps queues
for server in valkokuusi1 hopeakuusi1; do
  lpadmin -x sc-ps-$server 2> /dev/null
  lpadmin -p sc-ps-$server \
    -v krbsmb://ATKK/$server.ad.helsinki.fi/smartcard-ps \
    -D "Unigrafia's smartcard printer queue in $server" \
    -L "Any smartcard printer" \
    -P /usr/share/ppd/cubbli/cel-iradvc5250-ps-en-jj.ppd \
    -o printer-is-shared=false -E
    lpadmin -p sc-ps-$server -c smartcard-ps
done
# Set smartcard-ps metadata
lpadmin -p smartcard-ps \
  -D "Unigrafia's smartcard printer queue" \
  -L "Any smartcard printer" \
  -P /usr/share/ppd/cubbli/cel-iradvc5250-ps-en-jj.ppd \
  -o printer-is-shared=false -E

# Clear out "password required" status
for printer in $(lpstat -v|grep 'krbsmb://'|sed 's/^device for \([^:]*\):.*/\1/'); do
  lpadmin -p "$printer" -o auth-info-required=none
done

# Add wpr queue
lpadmin -p wpr -v ipp://wpr.helsinki.fi/printers/wpr \
 -D "University's www printer queue https://wpr.helsinki.fi/" \
 -L "https://wpr.helsinki.fi/" -E

# Always make smartcard-ps default printer
lpadmin -d smartcard-ps

# Fix the rest later
exit 0

# Now fetch AD printer from ldap using kerberos authentication
export KRB5CCNAME=FILE:$(mktemp krb5cc_machine_ldap_XXXXXXXXXXXXX)
# Get the machine account ticket name and use it.
princ=$(klist -k | tail -1 |(read num princ && echo $princ))
if ! kinit -k $princ; then
  echo "Could not get a machine ticket."
  exit 1
fi
#/usr/bin/adlpadd names "KUM-60401*" "KUM-60501-*" > $lists.auto
#/usr/bin/adlpadd names $(egrep -i "^[a-z*].*" /etc/cubbli/hyad-printers) > $lists-auto
cat /dev/null > $lists-auto
cat "${lists}"* | sort -u | egrep -i "^[a-z0-9_-]+$" > /var/lib/cubbli/printers
echo "Adding $(wc -l < /var/lib/cubbli/printers) AD printers from /var/lib/cubbli/printers"
/usr/bin/adlpadd add $(cat /var/lib/cubbli/printers)
kdestroy

# Remove printers from old arial4 and arial5 servers
lpstat -v |fgrep -i krbsmb://arial | sed 's/^device for \([^:]*\): .*$/\1/'|
egrep -v "^smartcard-"|
while read printer; do
  if egrep -q "^${printer}$" /var/lib/cubbli/printers; then
#    echo "$printer OK"
   :
  else
    lpadmin -x "$printer"
  fi
done

