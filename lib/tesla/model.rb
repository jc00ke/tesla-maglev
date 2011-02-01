
module Tesla
  module Model
    extend ActiveSupport::Concern

    # Flag any classes that include Model to also be persistable
    included do
      class_eval{ maglev_persistable }
    end

    # methods that will be available to the included class, eg: User.foo
    module ClassMethods
      
    end

    # methods that will be available to instances of a class, eg: User.new.bar
    module InstanceMethods

    end

  end
end
