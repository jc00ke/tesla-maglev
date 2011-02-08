require 'rubygems'
require 'forwardable'

require 'active_model'
require 'active_model/errors'
#require 'active_model/naming'
require 'active_model/validations'

# TODO
# remove HERE, figure out what's up with paths
# when testing this locally & when it's pulled
# into the Rails app.
HERE = File.expand_path(File.dirname(__FILE__))
require "#{HERE}/tesla/validations"
require "#{HERE}/model"
