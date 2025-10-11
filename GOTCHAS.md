# Gotchas

Everything that went wrong.

## democratic-csi

You can store an SSH key in a config secret all you want, but referencing it in the kustomize file as a variable cuases it to squish into a single line and lose its ability to be parsed.

Switch to a password for success.

## TrueNAS + democratic-csi

In the helm values, make sure to set the controller version to use the "next" tag

## USB Z-Wave

Only seems to work on the USB3 ports, not the USB2 ports

Does not show up as `/dev/ttyUSB0` at all; need to use `/dev/serial/by-id/xyz`

Find the path using `watch 'talosctl ls /dev --nodes 10.100.6.48 --recurse | grep -i usb'`
