#!/usr/bin/env ruby
require 'fileutils'
require 'open3'

target_dir = File.expand_path("~/.calabash")

if File.directory?(target_dir)
  puts "Warning: #{target_dir} already exists."
  puts "Do you want to delete #{target_dir}? (y/n)"
  answer = STDIN.gets.chomp
  if answer == 'y'
    puts "OK, I'll delete #{target_dir} and proceed with install..."
    FileUtils.rm_rf target_dir
  else
    puts "OK, I'll not touch #{target_dir}... Aborting."
    exit(false)
  end
end

old_env = ENV.to_hash
ENV['GEM_HOME'] = target_dir
ENV['GEM_PATH'] = target_dir
ENV['PATH'] = "#{File.join(target_dir,'bin')}:#{ENV['PATH']}"

target_gems = %w(calabash-android calabash-cucumber xamarin-test-cloud).join " "
install_opts = "--no-ri --no-rdoc"
env = "GEM_HOME=~/.calabash"
install_cmd = "#{env} gem install #{target_gems} #{install_opts}"

puts "Creating #{target_dir}."
FileUtils.mkdir target_dir

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
puts "\nYou can always uninstall by deleting #{target_dir}"


puts "\n\e[#{35}m### Installation done. Please configure environment ###\e[0m"

puts ""
puts "Run these commands to setup your env in this shell (or add to ~/.bash_profile or ~/.zshrc and restart the shell)"

puts <<EOF

export GEM_HOME=~/.calabash
export GEM_PATH=~/.calabash
export PATH="$PATH:$HOME/.calabash/bin"

EOF
exit(true)
