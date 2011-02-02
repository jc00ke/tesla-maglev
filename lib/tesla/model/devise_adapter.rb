require File.join(File.dirname(__FILE__), '..', 'model')

module Devise
  module Orm
    module Tesla
      module Hook
        def devise_modules_hook!
          extend Schema
          yield
          return unless Devise.apply_schema
          devise_modules.each { |m| send(m) if respond_to?(m, true) }
        end
      end
      module Schema
        include Devise::Schema

        def apply_devise_schema(name, type, options={})
          raise "#{name} is here"
          attr_accessor name
        end
      end
    end
  end
end

Tesla::Model::ClassMethods.class_eval do
  include Devise::Models
  include Devise::Orm::Tesla::Hook
end
