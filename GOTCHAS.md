# Gotchas

Everything that went wrong.

## democratic-csi

You can store an SSH key in a config secret all you want, but referencing it in the kustomize file as a variable cuases it to squish into a single line and lose its ability to be parsed.

Switch to a password for success.
