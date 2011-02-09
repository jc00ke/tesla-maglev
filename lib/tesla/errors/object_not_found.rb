module Tesla
  module Errors

    # Raised when trying to find an object
    # by a specific object_id which doesn't
    # exist. Multiple ids will be shown if
    # they were passed in.
    class ObjectNotFound < TeslaError
      attr_reader :klass, :identifiers

      def initialize(klass, ids)
        @klass = klass
        @identifiers = ids.respond_to?(:join) ? ids.join(", ") : ids
        super("#{@klass} with id(s) '#{@identifiers}' could not be found")
      end

    end
    
  end
  
end
