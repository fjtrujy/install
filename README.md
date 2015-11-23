# Calabash Install Scripts for OS X and Windows

Two scripts for installing the Calabash gems on your computer.

## Installing on OS X

On OS X Maverics and above, Ruby is already installed in version 2.0 or above.
On these systems installing Calabash without having to call sudo can be done
by running this command:

```
ruby <(curl -fsSL https://raw.githubusercontent.com/calabash/install/master/install-calabash-local-osx.rb)
```

### Configuration

After installing you should add the following lines to your login
profile (usually `~/.bash_profile` or `~/.zshrc`).

```
export GEM_HOME=~/.calabash/calabash-gems
export GEM_PATH=~/.calabash/calabash-gems
export PATH="${HOME}/.calabash/calabash-gems/bin:${PATH}"
```

Then restart your Terminal or open a new shell.

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

