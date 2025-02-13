#!/system/bin/sh
if [ "$BOOTMODE" != true ]; then
	ui_print "-----------------------------------------------------------"
	ui_print "! Please install in Magisk Manager or KernelSU Manager or APatch Manager"
	ui_print "! Install from recovery is NOT supported"
	abort	 "-----------------------------------------------------------"
fi

crondDataDir="/data/adb/crond"
systemBinDir="${MODPATH}/system/xbin"
crontabBinPath="${systemBinDir}/crontab"

if [ ! -d "${crondDataDir}" ]; then
	ui_print "- Creating crond data path"
	mkdir -p "${crondDataDir}"
fi
if [ ! -f "${crondDataDir}/root" ]; then
	ui_print "- Creating crond data"
	touch "${crondDataDir}/root"
fi

ui_print "- Installing crontab command"
if [ ! -d "${systemBinDir}" ]; then
	mkdir -p "${systemBinDir}"
fi
{
	echo "#!/system/bin/sh"
	if [ "$KSU" = true ]; then
		echo -n "/data/adb/ksu/bin/busybox crontab -c ${crondDataDir} \$@"
	elif [ "$APATCH" = true ]; then
		echo -n "/data/adb/ap/bin/busybox crontab -c ${crondDataDir} \$@"
	else
		echo -n "/data/adb/magisk/busybox crontab -c ${crondDataDir} \$@"
	fi
} > ${crontabBinPath}

ui_print "- Setting permissions"
set_perm ${crontabBinPath} 0 0 0755
set_perm "${MODPATH}/service.sh" 0 0 0755
set_perm "${MODPATH}/uninstall.sh" 0 0 0755
