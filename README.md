
```console
$ nix develop

$ make -C $KERNEL_BUILD_DIR/lib/modules/*/build M=$(pwd)/src modules

# Activate the patch
$ sudo insmod src/hello.ko

# Patch is applied now.

# Remove the patch.
$ echo 0 | sudo tee /sys/kernel/livepatch/hello/enabled
$ sudo rmmod hello
```
