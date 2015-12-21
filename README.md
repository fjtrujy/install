## Calabash Sandbox

To get up and running as fast as possible to use Calabash, we recommend you
use our Ruby Sandbox. The sandbox is a pre-configured ruby environment that
has everything you need to start exploring Calabash and running tests right away.
The sandbox is configured with the same version of Ruby running on Xamarin's
Test Cloud, so you don't need to worry about ruby compatibilities.

### Installation

Requires OSX Yosemite, El Capitan, or Windows 10.

##### OSX
```shell
$ curl -sSL https://raw.githubusercontent.com/calabash/install/master/install-osx.sh | bash
```

##### Windows

In an administrator Powershell:

```set-executionpolicy unrestricted
```

then
```(New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/calabash/install/master/install-windows.ps1") | iex
```

Post-installation, execute the following in an administrator Powershell:
```set-executionpolicy restricted
```

When installation completes, you should see something like the following:

```shell
Done! Installed:
calabash-ios:       0.16.4
calabash-android:   0.5.15
xamarin-test-cloud: 1.1.2
Execute 'calabash-sandbox' to get started!
```

You can execute `calabash-sandbox update` at any time to fetch the latest gems.

### Usage

When you execute `calabash-sandbox`, your Terminal window will open the
sandbox environment. To leave the sandbox and return the terminal to its
previous state, simply type `exit`.

While in the sandbox, you will have access to all of the gems you need to
start writing tests and submitting to Test Cloud. To get started, you could
run

```shell
$ calabash-ios gen #OSX only
```

or

```shell
$ calabash-android gen
```

For more information on Calabash, please see the [Calabash documentation](http://developer.xamarin.com/guides/testcloud/calabash/).

### Configuring/Customizing the environment

By default, the sandbox will ignore any existing ruby setup you have on your
machine, including installed gems. The sandbox shell is launched with a `PATH`,
`GEM_PATH`, and `GEM_HOME` that reference the pre-configured sandbox environment
(which is installed to `$HOME/.calabash/sandbox`).

#### Installing new gems

If you install new gems while running in the sandbox, they will be installed
in the sandbox's `GEM_HOME` and thus not be available outside of the sandbox.

#### Restoring the sandbox

If you have altered your sandbox environment in a way you don't like and want
to restore it to the original state, just run these commands:

##### OSX:
```shell
$ rm -r ${HOME}/.calabash/sandbox
$ curl -sSL https://raw.githubusercontent.com/calabash/install/master/install-osx.sh | bash
```

##### Windows:
In a powershell,
```rm -r -fo "${env:USERPROFILE}\.calabash\sandbox"
```

In an administrator Powershell:

```set-executionpolicy unrestricted
```

then
```(New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/calabash/install/master/install-windows.ps1") | iex
```

Post-installation, execute the following in an administrator Powershell:
```set-executionpolicy restricted
```


## Troubleshooting

### "/usr/local/bin is not writeable"

This is a common error on a fresh install of OSX.

The script attempts to install the sandbox executable to `/usr/local/bin` so that
it can be easily invoked from the command line. However, if you don't have
write permissions in that dir, the install script will not be able to move
the script there. You can still run it locally by executing

```shell
$ ./calabash-sandbox
```

from the same directory as you ran the install script.

If you'd like to install it globally, either have an administrator move the
`calabash-sandbox` executable to somewhere in your `PATH` or modify your
`.bash_profile`, `.profile`, `.zsh` etc. to find `calabash-sandbox` in your
`PATH`.  You should not run the install script with `sudo`.

### I ran the install script with `sudo`


```shell
$ sudo rm -r ${HOME}/.calabash/sandbox
$ sudo rm -f /usr/local/bin/calabash-sandbox
$ sudo rm -f ./calabash-sandbox
```

Run the install script again, this time _without sudo_.
