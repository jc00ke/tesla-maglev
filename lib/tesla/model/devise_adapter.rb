require File.join(File.dirname(__FILE__), '..', 'model.rb')

module Tesla
  module Model
    module DeviseAdapter
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
          begin
            attr_accessor name
          rescue Exception => e
            puts "Hmm: #{e.message}"
          end
        end
      end
    end
  end
end

Tesla::Model::ClassMethods.class_eval do
  include Devise::Models
  include Tesla::Model::DeviseAdapter::Hook
end
