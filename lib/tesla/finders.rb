module Tesla
  module Finders

    def find(*args)
      raise ArgumentError if args[0].nil?
      type = args.delete_at(0) if args[0].is_a?(Symbol)
      id = args.delete_at(0) if args[0].is_a?(Integer)
      conditions = args.delete_at(1) || {}
      found = case type
              when :first
                detect do |o|
                  conditions.all? do |attr, value|
                    o.send(attr) == value
                  end
                end
              else
                detect{ |o| o.object_id == id }
              end
      raise Tesla::Errors::ObjectNotFound.new(self, id) unless found
      found
    end

  end
end
