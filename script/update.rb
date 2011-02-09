require "open-uri"

rvmrc = File.open('.rvmrc').gets
installed = /(\d+)/.match(rvmrc)[1].to_i

version = `curl -s https://github.com/MagLev/maglev/raw/master/version.txt | head -n 1`.chomp.strip

latest = /([\d]+?)-\d+\)$/.match(version)[1].to_i

if (latest > installed)
  puts "*" * 75
  puts "There's a later version: #{latest}."
  puts "You can manually run this later:"
  cmds = []
  cmds << "maglev stop"
  cmds << "rvm upgrade maglev-#{latest} maglev-#{installed}"
  cmds << "sed -i 's/#{installed}/#{latest}/' .rvmrc"
  cmds << "gem install --no-rdoc --no-ri rake bundler"
  cmds << "bundle"
  puts cmds.join(" && ")
  puts "*" * 75
end
