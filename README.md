Build Vagrant base boxes from scratch
=====================================

This is an attempt to document and automate most of the process for creating
base box images for use with [vagrant](http://www.vagrantup.com/) with the
following developer-oriented goals:

- *Vanilla*: no unnecessary packages are included (such as those required by
  `chef` or `puppet`)
- *Insecure*: an [insecure public SSH
  key](https://github.com/mitchellh/vagrant/tree/master/keys) is injected and
  the root password is set to `vagrant`
- *Public*: a well-known username and password is created (user `vagrant` with
  password `vagrant`)

These goals are a result of [Vagrant's own
conventions](http://docs.vagrantup.com/v2/boxes/base.html).

This has been tested to produce a Debian 7.4.0 Wheezy 64-bit (AMD64) base box.

Usage
-----

Start with a virtual machine that you'd like to use to create a base box.
Configure it however you'd like.

Point the bootstrap script to the host name of the virtual machine you want to
package:

    ./configure_insecure_base_box.sh <hostname> <boxname>

After the host is prepared, it will be shutdown and you'll be prompted to
package it. You'll then have your own `.box` file to share with the world.
