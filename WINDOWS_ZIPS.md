1. Comment out the lines in `install-windows.ps1` which download and unzip the ruby and gem zips.
- Run `install-windows.ps1`, ignoring the error about `calabash-android` not being recognised.  This creates the sandbox folders and sets the PATH environment variable.
- Install the 32bit version of [Ruby 2.1.6-p336](http://rubyinstaller.org/downloads/archives) with the default options.
- Create the folder `%USERPROFILE%\.calabash\sandbox\Rubies\ruby-2.1.6-p336` and copy the contents of `C:\Ruby2.1` into it.
- Install the latest version of [Devkit](http://rubyinstaller.org/downloads/) that is for use with ruby 2.1.6.
- Start a new Command Prompt
- Run `calabash-sandbox`
- `cd` into `c:\DevKit`
- Run `ruby dk.rb init`
- Edit `c:\DevKit\config.yml` replacing `C:/Ruby21` with the folder that Ruby was copied into - something like `C:\Users\<your user>\.calabash\sandbox\Rubies\ruby-2.1.6-p336`.
- Run `ruby dk.rb install`
- Run `gem install bundler`
- Create a file named `Gemfile` in `%USERPROFILE%\.calabash\sandbox` with the contents:

        source 'https://rubygems.org'
        gem 'calabash-android', '>= 0.5.15', '< 1.0'
        gem 'xamarin-test-cloud', '~> 2.0'
- `cd` into `%USERPROFILE%\.calabash\sandbox` and Run `bundle install`
- Zip `%USERPROFILE%\.calabash\sandbox\Rubies\ruby-2.1.6-p336` into `calabash-files\2.1.6-p336-win32.zip`
- Zip `%USERPROFILE%\.calabash\sandbox\Gems` into `calabash-files\CalabashGems-win32.zip`


 