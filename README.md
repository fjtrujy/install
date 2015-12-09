# Calabash Install Scripts for OS X and Windows

Two scripts for installing the Calabash gems on your computer.

## Installing on OS X

On OS X Maverics and above, Ruby is already installed in version 2.0 or above.  The bad news is that using the system Ruby requires `sudo`.  We recommend [that you never install gems with sudo](https://github.com/calabash/calabash-ios/wiki/Best-Practice%3A--Never-install-gems-with-sudo).  We've created a tool called the `calabash-sandbox`.  You can read all about it in the [SANDBOX.README.md](SANDBOX.README.md).

```shell
$ curl -sSL https://raw.githubusercontent.com/calabash/install/master/install-osx.sh | bash
```

When installation completes, you should see something like the following:

```shell
Done! Installed:
calabash-ios:       0.16.4
calabash-android:   0.5.15
xamarin-test-cloud: 1.1.2
Execute 'calabash-sandbox' to get started!
```

When you execute `calabash-sandbox`, your Terminal window will open the
sandbox environment. To leave the sandbox and return the terminal to its
previous state, simply type `exit`.

```shell
$ calabash-sandbox
This terminal is now ready to use with Calabash.
To exit, type 'exit'.

$ calabash-ios version
$ calabash-android version
$ exit

This terminal is back to normal.
$
```


## Installing on Windows

You must first have [Ruby installed](http://rubyinstaller.org/) along with the
RubyInstaller DevKit installed. Once you have this done, download the Powershell
script `install-calabash-local-windows.ps1` and run it using Powershell.

You must also have the Android SDK installed and the `ANDROID_HOME` environment
variable set.

## Post Install

You must also have the Android SDK installed and the `ANDROID_HOME` environment
variable set.

### Using bundler

You can download the sample Gemfile with this command:

```
curl -fsSL https://raw.githubusercontent.com/calabash/install/master/Gemfile -o Gemfile
```

