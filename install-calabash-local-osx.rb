#!/usr/bin/env ruby
require 'fileutils'
require 'open3'

EXIT_CODES = {
  rbenv_installed: 10,
  rvm_installed: 11
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

if rbenv
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

rvm = rvm_installed?

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

gem_dir = File.join(DOT_CALABASH_DIR, "gems")

if ARGV[0] == "skip-install"
  puts %Q{
Finished preparing

  #{DOT_CALABASH_DIR}

Skipping installation.
}
  exit(0)
end

if File.directory?(gem_dir)
  puts "Warning: #{gem_dir} already exists."
  puts "Do you want to delete #{gem_dir}? (y/n)"
  answer = STDIN.gets.chomp
  if answer == 'y'
    puts "OK, I'll delete #{gem_dir} and proceed with install..."
    FileUtils.rm_rf gem_dir
  else
    puts "OK, I'll not touch #{gem_dir}...Exiting."
    exit(2)
  end
end

target_gems = %w(calabash-android calabash-cucumber xamarin-test-cloud).join " "
install_opts = "--no-document --no-prerelease"
env = "GEM_HOME=\"#{gem_dir}\" GEM_PATH=\"#{gem_dir}\""
install_cmd = "#{env} gem install #{target_gems} #{install_opts}"

puts "Creating #{gem_dir}."
FileUtils.mkdir gem_dir

puts "Installing Calabash... This will take a few minutes"
puts "Running:\n #{install_cmd}"

pid = fork { exec(install_cmd) }
puts "Please wait..."
_, status = Process.waitpid2(pid)


unless status.success?
  puts "Error while running command: #{install_cmd}."
  exit(1)
end

puts "Done Installing!"
puts "\nYou can always uninstall by deleting #{gem_dir}"


puts "\n\e[#{35}m### Installation done. Please configure environment ###\e[0m"


puts <<EOF

Run these commands to setup your environment in this shell:

export GEM_HOME="${HOME}/.calabash/gems"
export GEM_PATH="${HOME}/.calabash/gems"
export PATH="${HOME}/.calabash/gems/bin:${PATH}"

Or add to them to your ~/.bash_profile or ~/.zshrc and restart the shell."

EOF

exit(0)

