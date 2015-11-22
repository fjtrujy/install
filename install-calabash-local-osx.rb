#!/usr/bin/env ruby
require 'fileutils'
require 'open3'

# Just do the checks and prepare to install, then exit.
def skip_install?
  ARGV.include?("skip-install")
end

# Disable managed ruby checks; good for testing environments
# where rbenv or rvm are installed.
def skip_managed_ruby_check?
  ARGV.include?("skip-managed-ruby-check")
end

EXIT_CODES = {
  rbenv_installed: 10,
  rvm_installed: 11,
  skipped_install: 20,
  previous_installation_detected: 30,
  invalid_input: 40
}

def home_dir
  # Find the home directory can be problematic.
  #
  # This is the preferred method:
  require 'etc'
  preferred = Etc.getpwuid.dir

  # We need this so we can test this script. If
  # it exists, we respect it.
  home = ENV["HOME"]

  home || preferred
end

def tool_installed?(name)
  `hash #{name} 2>/dev/null`
  $?.exitstatus == 0
end

# IIRC, some installs of rbenv or rvm have a dot _file_.
def tool_dot_dir?(name)
  File.exist?(File.join(home_dir, ".#{name}"))
end

def managed_ruby_installed?(name)
  if tool_installed?(name)
    :available
  elsif tool_dot_dir?(name)
    :dot_dir
  else
    false
  end
end

def rbenv_installed?
  managed_ruby_installed?("rbenv")
end

def rvm_installed?
  managed_ruby_installed?("rvm")
end

rbenv = rbenv_installed?

if rbenv && !skip_managed_ruby_check?
  case rbenv
  when :available
    message = "Detected that rbenv is installed."
  when :dot_dir
    message = "Detected a ~/.rbenv directory or file."
  end

  puts %Q{
#{message}  You should not run this script.

For more information about rbenv see:

https://github.com/sstephenson/rbenv

}
  exit(EXIT_CODES[:rbenv_installed])
end

rvm = rvm_installed? && !skip_managed_ruby_check?

if rvm
  case rvm
  when :available
    message = "Detected that rvm is installed."
  when :dot_dir
    message = "Detected a ~/.rvm directory or file."
  end

  puts %Q{
#{message}  You should not run this script.

For more information about rvm see:

https://rvm.io/

}
  exit(EXIT_CODES[:rvm_installed])
end

GEM_INSTALL_DIRS = ["bin", "build_info", "cache", "doc", "gems", "specifications"]

DOT_CALABASH_DIR = File.expand_path(File.join(home_dir, ".calabash"))

def version1_script_was_run?
  return false if !File.exist?(DOT_CALABASH_DIR)

  GEM_INSTALL_DIRS.map do |dir|
    File.exist?(File.join(DOT_CALABASH_DIR, dir))
  end.all?
end

if version1_script_was_run?
  @version1_script_was_run = true
  puts %Q{
It looks like you ran version 1.0 of this script.

Moving files from the old install to:

#{DOT_CALABASH_DIR}/version-1.0-install.bak

You can delete these files later if you want.

$ rm -rf "#{DOT_CALABASH_DIR}/version-1.0-install.bak"

}

  target_dir = File.join(DOT_CALABASH_DIR, "version-1.0-install.bak")
  FileUtils.rm_rf(target_dir)
  FileUtils.mkdir_p(target_dir)
  GEM_INSTALL_DIRS.each do |dir|
    source = File.join(DOT_CALABASH_DIR, dir)
    FileUtils.mv(source, File.join(target_dir, "/"))
  end
else
  @version1_script_was_run = false
end

FileUtils.mkdir_p(DOT_CALABASH_DIR)

if skip_install?
  puts %Q{
Finished preparing:

#{DOT_CALABASH_DIR}

Skipping installation.
}
  exit(EXIT_CODES[:skipped_install])
end

GEM_INSTALL_DIR = File.join(DOT_CALABASH_DIR, "calabash-gems")

def yes_or_no(question, default)
  if default == "y"
    suffix = "(Y/n)"
  else
    suffix = "(y/N)"
  end

  user_input = [(print "#{question} #{suffix} "), STDIN.gets.chomp][1]
  answer = user_input.strip.downcase.chars[0]

  if answer == "" || answer == nil
    if default == "y"
      "y"
    else
      "n"
    end
  else
    if answer == "y" || answer == "n"
      answer
    else
      puts "Invalid input: '#{user_input}'; please answer 'y' or 'n'"
      exit(EXIT_CODES[:invalid_input])
    end
  end
end

if File.directory?(GEM_INSTALL_DIR)
  puts %Q{
Found an existing Calabash gem installation here:

#{GEM_INSTALL_DIR}

If you are trying to update your Calabash iOS or Android version
you should let this script delete this directory.

Deleting this directory will force a clean install of the most recent
versions of the Calabash gems.

}

  answer = yes_or_no("Do you want to delete the existing installation?", "n")

  if answer == 'y'
    puts "Deleting previous installation and proceeding with a clean install."
    FileUtils.rm_rf(GEM_INSTALL_DIR)
  else
    puts "Alright, the previous installation will not be deleted.  Exiting."
    exit(EXIT_CODES[:previous_installation_detected])
  end
end

puts "Creating #{GEM_INSTALL_DIR}."
FileUtils.mkdir_p(GEM_INSTALL_DIR)

TARGET_GEMS = ["calabash-android", "calabash-cucumber", "xamarin-test-cloud"].join(" ")
INSTALL_OPTIONS = ["--no-document", "--no-prerelease"].join(" ")

puts "Installing Calabash... This will take a few minutes"

puts %Q{Running:

GEM_HOME="#{GEM_INSTALL_DIR}" \\
  GEM_PATH="#{GEM_INSTALL_DIR}" \\
  #{INSTALL_OPTIONS} \\
  #{TARGET_GEMS}

}

gem_home_var = "GEM_HOME=\"#{GEM_INSTALL_DIR}\""
gem_path_var = "GEM_PATH=\"#{GEM_INSTALL_DIR}\""

ENV_VARS = "#{gem_home_var} #{gem_path_var}"

install_cmd = "#{ENV_VARS} gem install #{TARGET_GEMS} #{INSTALL_OPTIONS}"

pid = fork { exec(install_cmd) }
puts "Please wait..."
_, status = Process.waitpid2(pid)

unless status.success?
  puts "Error while running command: #{install_cmd}."
  exit(1)
end

puts "Done Installing!"
puts "\nYou can always uninstall by deleting #{GEM_INSTALL_DIR}"


puts "\n\e[#{35}m### Installation done. Please configure environment ###\e[0m"


puts <<EOF

Run these commands to setup your environment in this shell:

export GEM_HOME="${HOME}/.calabash/calabash-gems"
export GEM_PATH="${HOME}/.calabash/calabash-gems"
export PATH="${HOME}/.calabash/calabash-gems/bin:${PATH}"

Or add to them to your ~/.bash_profile or ~/.zshrc and restart the shell."

EOF

exit(0)

