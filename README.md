# Calabash Install Scripts for OS X and Windows

Two scripts for installing the Calabash gems on your computer.

## Installing on OS X

To simplify the installation of the Calabash gems and to minimize compatibility issues with the system Ruby that is provided by OS X Mavericks and above, we provide a tool called the _Calabash Sandbox_ .  You can read all about it in the [SANDBOX.README.md](SANDBOX.README.md).


**Note:** You are strongly discouraged from [installing gems with `sudo`](https://github.com/calabash/calabash-ios/wiki/Best-Practice%3A--Never-install-gems-with-sudo).

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

To start Calabash Sandbox, execute `calabash-sandbox` in a Terminal window. To leave the Sandbox and return the terminal to its previous state, type `exit`:

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
