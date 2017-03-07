#!/bin/sh
### BEGIN INIT INFO
# Provides:          pitop-battery-driver
# Required-Start:    $local_fs $network $remote_fs $syslog
# Required-Stop:     $local_fs $network $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Registers the bit-banging i2c driver and the pitop battery
### END INIT INFO

# Do NOT "set -e"

# PATH should only include /usr/* if it runs after the mountnfs.sh script
PATH=/sbin:/usr/sbin:/bin:/usr/bin
DESC="pitop battery driver"
NAME=pitop-battery-driver
SCRIPTNAME=/etc/init.d/$NAME

# Define LSB log_* functions.
# Depend on lsb-base (>= 3.2-14) to ensure that this file is present
# and status_of_proc is working.
. /lib/lsb/init-functions

do_start()
{
  # register I2C
  modprobe i2c-gpio-param busid=1 sda=2 scl=3
  modprobe i2c-dev

  # give it a moment to... initialize?
  sleep 2

  # register Pi-Top battery
  modprobe sbs-battery &&
  echo sbs-battery 0x0b > /sys/class/i2c-adapter/i2c-1/new_device &&
  return 0

  if [ -a /sys/class/i2c-adapter/i2c-1/1-000b ]; then
    return 1
  fi

  return 2
}

#
# Function that stops the daemon/service
#
do_stop()
{
  if [ -a /sys/class/i2c-adapter/i2c-1/1-000b ]; then
    echo 0x0b > /sys/class/i2c-adapter/i2c-1/delete_device &&
      return 0
    return 2
  else
    return 1
  fi
}

#
# Function that sends a SIGHUP to the daemon/service
#
do_reload() {
  do_stop
  do_start
}

case "$1" in
  start)
	[ "$VERBOSE" != no ] && log_daemon_msg "Starting $DESC" "$NAME"
	do_start
	case "$?" in
		0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
		2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
	esac
	;;
  stop)
	[ "$VERBOSE" != no ] && log_daemon_msg "Stopping $DESC" "$NAME"
	do_stop
	case "$?" in
		0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
		2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
	esac
	;;
  status)
	status_of_proc "$DAEMON" "$NAME" && exit 0 || exit $?
	;;
  #reload|force-reload)
	#
	# If do_reload() is not implemented then leave this commented out
	# and leave 'force-reload' as an alias for 'restart'.
	#
	#log_daemon_msg "Reloading $DESC" "$NAME"
	#do_reload
	#log_end_msg $?
	#;;
  restart|force-reload)
	#
	# If the "reload" option is implemented then remove the
	# 'force-reload' alias
	#
	log_daemon_msg "Restarting $DESC" "$NAME"
	do_stop
	case "$?" in
	  0|1)
		do_start
		case "$?" in
			0) log_end_msg 0 ;;
			1) log_end_msg 1 ;; # Old process is still running
			*) log_end_msg 1 ;; # Failed to start
		esac
		;;
	  *)
		# Failed to stop
		log_end_msg 1
		;;
	esac
	;;
  *)
	#echo "Usage: $SCRIPTNAME {start|stop|restart|reload|force-reload}" >&2
	echo "Usage: $SCRIPTNAME {start|stop|status|restart|force-reload}" >&2
	exit 3
	;;
esac

:
