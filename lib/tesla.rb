require 'rubygems'
require 'forwardable'
require 'active_support/concern'

require 'tesla/model'

module Tesla
  # Flag the module as being persistable
  module_eval{ maglev_persistable }
end
