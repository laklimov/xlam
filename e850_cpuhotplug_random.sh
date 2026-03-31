#!/bin/bash

# run as root
if [ "$EUID" -ne 0 ]; then
	echo "Error: please run this script as root"
	exit 1
fi

# online cpus back on exit
cleanup() {
	echo -e "\nExiting... restoring all CPUs back to online state..."
	for i in {1..7}; do
		if [ -f /sys/devices/system/cpu/cpu$i/online ]; then
			echo 1 > /sys/devices/system/cpu/cpu$i/online 2>/dev/null
		fi
	done

	echo "cpus should be back online."
	exit 0
}

# trap ctrl-c to exec cleanup()
trap cleanup SIGINT SIGTERM

echo "Starting random hotplug test on CPUs 1..7"
echo "============================================="

while true; do
	# Generate a random CPU number between 1 and 7
	# $RANDOM % 7 generates 0..6
	CPU=$(((RANDOM % 7) + 1))

	STATE=$((RANDOM % 2))

	# if [ "$STATE" -eq 1 ]; then
	#	ACTION="ONLINE "
	# else
	#	ACTION="OFFLINE"
	# fi

	# echo "Triggering: CPU $CPU -> $ACTION ($STATE)"

	echo $STATE > /sys/devices/system/cpu/cpu$CPU/online

	# Nah. No delays.
	# sleep 0.1
done
