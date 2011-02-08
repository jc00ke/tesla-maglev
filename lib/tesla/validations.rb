HERE = File.expand_path(File.dirname(__FILE__))
require "#{HERE}/validations/uniqueness"

module Tesla
  module Validations
    #include ActiveModel::Validations
  end
end
