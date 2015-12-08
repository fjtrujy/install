1. Comment out the lines in `install-windows.ps1` which download and unzip the ruby and gem zips.
- Run `install-windows.ps1`, ignoring the errors about `calabash-android`, `calabash-ios` and `test-cloud` not being found.  This creates the sandbox folders and sets the PATH environment variable.
- Copy [https://github.com/calabash/install/blob/master/calabash-sandbox.bat](https://github.com/calabash/install/blob/master/calabash-sandbox.bat) into `%USERPROFILE%\.calabash\sandbox\bin`.
- Install the 32bit version of [Ruby 2.1.5-p273](http://rubyinstaller.org/downloads/archives) with the default options.
- Install the latest version of [Devkit](http://rubyinstaller.org/downloads/) that is for use with ruby 2.1.5.
- Create the folder `%USERPROFILE%\.calabash\sandbox\Rubies\ruby-2.1.5-p273` and copy the contents of `C:\Ruby2.1` into it.
- Start a new Command Prompt
- Run `calabash-sandbox`
- `cd` into `c:\DevKit`
- Run `ruby dk.rb init`
- Edit `c:\DevKit\config.yml` replacing `C:/Ruby21` with the folder that Ruby was coppied into - something like `C:\Users\<your user>\.calabash\sandbox\Rubies\ruby-2.1.5-p273\bin`.
- Run `ruby dk.rb install`
- Run `gem install bundle`
- Create a file named `Gemfile` in `%USERPROFILE%\.calabash\sandbox` with the contents:

        source 'https://rubygems.org'
        gem 'calabash-cucumber', '>= 0.16.4', '< 1.0'
        gem 'calabash-android', '>= 0.5.15', '< 1.0'
        gem 'xamarin-test-cloud', '~> 2.0'
- `cd` into `%USERPROFILE%\.calabash\sandbox` and Run `bundle install`
- Zip `%USERPROFILE%\.calabash\sandbox\Rubies\ruby-2.1.5-p273` into `calabash-files\2.1.5-p273-win32.zip`
- Zip `%USERPROFILE%\.calabash\sandbox\Gems` into `calabash-files\CalabashGems-win32.zip`


 