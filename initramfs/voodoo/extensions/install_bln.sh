# Backlight Notifications or Short Light Fix liblights install script
# Mod by AB86

name='BLN or SLF liblights install script'
blnsource='/voodoo/extensions/bln/lights.bln.so'
slfsource='/voodoo/extensions/bln/lights.slf.so'
dest="/system/lib/hw/lights.s5pc110.so"
backup="/system/lib/hw/lights.s5pc110.so-backup-"`date '+%Y-%m-%d_%H-%M-%S'`

install_condition_bln()
{
	test -d "/system/lib/hw/" && test -d "/sys/class/misc/backlightnotification"
}

extension_install_bln()
{
	# be nice, make a backup please
	mv $dest $backup
	cp $blnsource $dest
	# make sure it's owned by root
	# set default permissions
	chown 0.0 $dest && chmod 644 $dest && log "BLN liblights now installed" || \
		log "problem during BLN liblights installation"
}

extension_install_slf()
{
	# be nice, make a backup please
	mv $dest $backup
	cp $slfsource $dest
	# make sure it's owned by root
	# set default permissions
	chown 0.0 $dest && chmod 644 $dest && log "SLF liblights now installed" || \
		log "problem during SLF liblights installation"
}

if test "`find /sdcard/Voodoo/ -iname 'enable*slf*'`" != "" ; then
	if ! cmp $slfsource $dest; then
		# we need our liblights
		extension_install_slf
	else
		# ours is the same don't touch it
		log "SLF library already installed"
	fi
else
	if install_condition_bln; then
		if ! cmp $blnsource $dest; then
			# we need our liblights
			extension_install_bln
		else
			# ours is the same don't touch it
			log "BLN library already installed"
		fi
	else
		log "BLN cannot be installed or is not supported"
	fi
fi
