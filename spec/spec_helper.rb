require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :test)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle` to install missing gems"
  exit e.status_code
end
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

MODELS = File.join(File.dirname(__FILE__), 'models')
$LOAD_PATH.unshift(MODELS)
require 'tesla'

Dir[ File.join(MODELS, "*.rb") ].sort.each { |file| require File.basename(file) }

require 'minitest/autorun'
