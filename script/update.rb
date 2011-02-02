require "open-uri"

rvmrc = File.open('.rvmrc').gets
installed = /(\d+)/.match(rvmrc)[1].to_i

version = `curl -s https://github.com/MagLev/maglev/raw/master/version.txt | head -n 1`.chomp.strip

latest = /([\d]+?)-\d+\)$/.match(version)[1].to_i

if (latest > installed)
  puts "*" * 75
  puts "There's a later version: #{latest}."
  puts "Would you like to automatically upgrade? [Y|n]"
  upgrade = gets.chomp
  cmds = []
  cmds << "maglev stop"
  cmds << "rvm upgrade maglev-#{latest} maglev-#{installed}"
  cmds << "sed -i 's/#{installed}/#{latest}/' .rvmrc"
  cmds << "gem install --no-rdoc --no-ri rake bundler"
  cmds << "bundle"
  run = cmds.join(" && ")
  if ['', 'Y'].include?(upgrade)
    system run
  else
    puts "You can manually run this later:"
    puts run
  end
  puts "*" * 75
end
