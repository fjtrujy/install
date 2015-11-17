#!/usr/bin/env ruby
require 'fileutils'
require 'open3'

dot_dir = File.expand_path("~/.calabash")

# Ensure ~/.calabash exists.
FileUtils.mkdir_p(dot_dir)

gem_dir = File.join(dot_dir, "gems")

if File.directory?(gem_dir)
  puts "Warning: #{gem_dir} already exists."
  puts "Do you want to delete #{gem_dir}? (y/n)"
  answer = STDIN.gets.chomp
  if answer == 'y'
    puts "OK, I'll delete #{gem_dir} and proceed with install..."
    FileUtils.rm_rf gem_dir
  else
    puts "OK, I'll not touch #{gem_dir}... Aborting."
    exit(1)
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

puts ""
puts "Run these commands to setup your env in this shell (or add to ~/.bash_profile or ~/.zshrc and restart the shell)"

puts <<EOF

export GEM_HOME="${HOME}/.calabash/gems"
export GEM_PATH="${HOME}/.calabash/gems"
export PATH="${PATH}:${HOME}/.calabash/gems/bin"

EOF
exit(true)

