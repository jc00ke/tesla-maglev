require 'rubygems'
require 'forwardable'
require 'active_support/concern'
require 'active_model'
require 'active_model/errors'
require 'active_model/validator'
require 'active_model/validations'

require 'tesla/model'

module Tesla
  # Flag the module as being persistable
  module_eval{ maglev_persistable }
end
