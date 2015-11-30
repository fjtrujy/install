# Calabash Sandbox (OSX Only)

To get up and running as fast as possible to use calabash, we recommend you
use our Ruby Sandbox. The sandbox is a pre-configured ruby environment that
has everything you need to start exploring calabash and running tests right away.
It is also configured with the same version of Ruby running in Test Cloud, so
you don't need to worry about ruby compatibilities.

## Installation

To install the sandbox, run:

```shell
curl -sSL https://raw.githubusercontent.com/calabash/install/feature/sandbox/install-osx.sh | bash
```

When installation completes, you should see something like the following:

```shell
Done! Installed:
calabash-ios:       0.16.4
calabash-android:   0.5.15
xamarin-test-cloud: 1.1.2
Execute 'calabash-sandbox' to get started!
```

## Usage
When you execute `calabash-sandbox`, your current terminal window will open the
sandbox environment. To leave the sandbox and return the terminal to its
previous state, simply type `exit`.

While in the sandbox, you will have access to all of the gems you need to
start writing tests and submitting to Test Cloud. To get started, you could
run

```shell
calabash-ios gen
```

or
```shell
calabash-android gen
```

For more information, please see the [calabash documentation](http://developer.xamarin.com/guides/testcloud/calabash/).

## Configuring/Customizing the environment
By default, the sandbox will ignore any existing ruby setup you have on your
machine, including installed gems. The sandbox shell is launched with a `PATH`,
`GEM_PATH`, and `GEM_HOME` that reference the pre-configured sandbox environment
(which is installed to `$HOME/.calabash/sandbox`).

### Installing new gems
If you install new gems while running in the sandbox, they will be installed
in the sandbox's `GEM_HOME` and thus not be available outside of the sandbox.

### Restoring the sandbox
If you have altered your sandbox environment in a way you don't like and want
to restore it to the original state, just run these commands:

```shell
rm -rf $HOME/.calabash/sandbox
curl -sSL https://raw.githubusercontent.com/calabash/install/feature/sandbox/install-osx.sh | bash
```

This will restore it to a fresh installation.

## Alternate Environments

If you would prefer to set up your own environment and feel comfortable managing
your own version(s) of Ruby, we'd recommend using a ruby manager such as [rvm](https://rvm.io/)
or [rbenv](https://github.com/rbenv/rbenv) as well as [bundler](http://bundler.io/). We'd also recommend that you use the same
version of ruby running in Test Cloud (2.1.5-p273 at the time of writing).

A basic Gemfile might look like this:
```ruby
source 'https://rubygems.org'
gem 'calabash-cucumber', '>= 0.16.4', '< 1.0'
gem 'calabash-android', '>= 0.5.15', '< 1.0'
gem 'xamarin-test-cloud', '~> 1.0'
```
