# Calabash Install Scripts for OS X and Windows

Two scripts for installing the Calabash gems on your computer.

## Installing on OS X

To simplify the installation of Calabash on OS X and to minimize any compatibility issues with the older Ruby 2.0 provided by OS X, we created a tool called the _Calabash Sandbox_. This tool establishes a sandbox environment within a Terminal session with the necessary Calabash gems and Ruby 2.1.5-p273. You can read all about the Calabash Sandbox in the [SANDBOX.README.md](SANDBOX.README.md).

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

To start Calabash Sandbox, execute `calabash-sandbox` in a Terminal window. To leave the Sandbox and return the Terminal to its previous state, type `exit`:

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
