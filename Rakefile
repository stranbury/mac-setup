# ====================================
#   Variables
# ====================================

# ----- Original Locations ----- #

original_locations                   = {}
original_locations[:aliases]         = "#{ ENV['HOME'] }/.mac-laptop-setup/aliases"
original_locations[:bash_profile]    = "#{ ENV['HOME'] }/.mac-laptop-setup/bash_profile"
original_locations[:bash_prompt]     = "#{ ENV['HOME'] }/.mac-laptop-setup/bash_prompt"
original_locations[:bashrc]          = "#{ ENV['HOME'] }/.mac-laptop-setup/bash/bashrc"
original_locations[:inputrc]         = "#{ ENV['HOME'] }/.mac-laptop-setup/bash/inputrc"
original_locations[:jshint]          = "#{ ENV['HOME'] }/.mac-laptop-setup/bash/jshint"
original_locations[:editorconfig]    = "#{ ENV['HOME'] }/.mac-laptop-setup/bash/editorconfig"
original_locations[:gitconfig]       = "#{ ENV['HOME'] }/.mac-laptop-setup/git/gitconfig"
original_locations[:gitignore]       = "#{ ENV['HOME'] }/.mac-laptop-setup/git/gitignore"

# ----- New Locations ----- #

new_locations                   = {}
new_locations[:aliases]         = "#{ ENV['HOME'] }/.aliases"
new_locations[:bash_profile]    = "#{ ENV['HOME'] }/.bash_profile"
new_locations[:bash_prompt]     = "#{ ENV['HOME'] }/.bash_prompt"
new_locations[:bashrc]          = "#{ ENV['HOME'] }/.bashrc"
new_locations[:inputrc]         = "#{ ENV['HOME'] }/.inputrc"
new_locations[:jshint]          = "#{ ENV['HOME'] }/.jshint"
new_locations[:editorconfig]    = "#{ ENV['HOME'] }/.editorconfig"
new_locations[:gitconfig]       = "#{ ENV['HOME'] }/.gitconfig"
new_locations[:gitignore]       = "#{ ENV['HOME'] }/.gitignore"

# ----- Installation Order ----- #

current_step = 0

installation_order = [
  'install_symlinks',
  'install_homebrew',
  'install_homebrew_packages',
  'install_npm_packages',
  'install_osx_settings',
  'install_cask',
  'install_cleanup'
]

# ====================================
#   Installation Start
# ====================================

task :install do
  puts '---------------------------------------------'
  puts ' spartdev mac laptop Installation'
  puts " --> Type 'start'"
  puts '---------------------------------------------'

  run installation_order[current_step] if response?('start')
end

# ====================================
#   Install Symlinks
# ====================================

task :install_symlinks, :run do |task, args|
  current_step = current_step + 1

  prompt 'symlinks'

  if response?('y')
    message 'Symlinking files...'

    create_symlinks(original_locations, new_locations)

    run installation_order[current_step] unless args[:run] == 'single'
  end
end

# ====================================
#   Install Homebrew
# ====================================

task :install_homebrew, :run do |task, args|
  current_step = current_step + 1

  prompt 'Homebrew'

  if response?('y')
    message 'Installing Homebrew...'

    system 'ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'

    run installation_order[current_step] unless args[:run] == 'single'
  end
end

# ====================================
#   Install Homebrew Packages
# ====================================

task :install_homebrew_packages, :run do |task, args|
  current_step = current_step + 1

  prompt 'Homebrew Packages'

  if response?('y')
    message 'Installing Homebrew Packages...'

    system 'bash setup/brew'

    run installation_order[current_step] unless args[:run] == 'single'
  end
end

# ====================================
#   Install NPM Packages
# ====================================

task :install_npm_packages, :run do |task, args|
  current_step = current_step + 1

  prompt 'NPM Packages'

  if response?('y')
    message 'Installing NPM Packages...'

    system 'bash setup/npm'

    run installation_order[current_step] unless args[:run] == 'single'
  end
end

# ====================================
#   Install OS X Settings
# ====================================

task :install_osx_settings, :run do |task, args|
  current_step = current_step + 1

  prompt 'OS X Settings'

  if response?('y')
    message 'Installing OS X Settings...'

    system 'bash setup/osx'

    run installation_order[current_step] unless args[:run] == 'single'
  end
end

# ====================================
#   Install Cask
# ====================================

task :install_cask, :run do |task, args|
  current_step = current_step + 1

  prompt 'Cask & Applications'

  if response?('y')
    message 'Installing Cask & Applications...'

    system 'bash setup/cask'

    run installation_order[current_step] unless args[:run] == 'single'
  end
end

# ====================================
#   Install Cleanup
# ====================================

task :install_cleanup do
  system "source #{ ENV['HOME'] }/.bash_profile"
  puts "Done! Run 'open ~/.mac-laptop-setup' to see your new files."
end

# Prints out a message to the console
#
# == Parameters
#
# @param string [String] the string to print out
#
# == Usage
#
#   message 'This is a message to show.'
#
def message(string)
  puts
  puts "--> #{ string }"
end

# Prints out a message prompt for the user
#
# == Parameters
#
# @param section [String] the section to ask about
#
# == Usage
#
#   prompt 'Command Line Tools'
#
def prompt(section)
  puts
  puts '---------------------------------------------'
  puts " Ready to install #{ section }? [y|n]"
  puts '---------------------------------------------'
end

# Determines the user's response
#
# == Parameters
#
# @param value [String] the response that is expected
#
# == Usage
#
#   if response?('yes')
#     # ...
#   end
#
def response?(value)
  STDIN.gets.chomp == value ? true : false
end

# Runs a particular Rake task
#
# == Parameters
#
# @param task [String] the task to run
#
# == Usage
#
#   run 'install_homebrew'
#
def run(task)
  Rake::Task[task].invoke
end

# Determines if a symlink can be made
#
# == Parameters
#
# @param destination_path [String] the destination of the symlink
#
# == Usage
#
#   if can_symlink?(destination_path)
#     # ...
#   end
#
def can_symlink?(destination_path)
  File.exists?(destination_path) ? false : true
end

# Creates all of the specified symlinks
#
# == Parameters
#
# @param original_locations [Hash] set of original locations
# @param new_locations [Hash] set of new locations
#
# == Usage
#
#   create_symlinks(original_locations, new_locations)
#
def create_symlinks(original_locations, new_locations)
  (0..original_locations.count - 1).each do |index|
    old = original_locations[ original_locations.keys[index] ]
    new = new_locations[ new_locations.keys[index] ]

    if can_symlink?(new)
      File.symlink(old, new)
      puts "#{ old } -> #{ new } symlink created."
    else
      puts "#{ new } already exists. Continuing..."
    end
  end
end
