#! /bin/sh

#Kai Mayer
#Chike Abuah
#Dept of Computer Science
#Grinnell College
#6/20/2010

#Begin Script

#Copy DKIM private key using secure copy tool


scp setup.cs.grinnell.edu:/setup/squeeze/etc/exim4/sinkov.private.key /etc/exim4/sinkov.private.key

#Set permissions for the private key

chmod 440 /etc/exim4.sinkov.private.key

#Set ownership for the private key

chown root:Debian-exim /etc/exim4.sinkov.private.key

#Rename the old configuration template

mv /etc/exim4/exim4.conf.template /etc/exim/exim4.conf.template-before-dkim

#Find the line number of the line we want to insert code before

LINENUMBER=grep -n "### end main/01_exim4-config_listmacrosdefs" /etc/exim/exim4.conf.template-before-dkim  | cut -c1

LINENUMBER=$(${LINENUMBER}-1)

#Insert lines of code

sed -e "${LINENUMBER}i\
\n# Enable DomainKeys Identified Mail. \nDKIM_CANON = relaxed\nDKIM_DOMAIN = $sender_address_domain\nDKIM_PRIVATE_KEY = /etc/exim4/sinkov.private.key\nDKIM_SELECTOR = sinkov" /etc/exim/exim4.conf.template-before-dkim > /etc/exim4/exim4.conf.template

#Set permissions for new configuration template

chmod 644 /etc/exim4/exim4.conf.template

/etc/init.d/exim4 reload

