
module Tesla
  module Model
    extend ActiveSupport::Concern

    # Flag any classes that include Model to also be persistable
    included do
      class_eval{ maglev_persistable }
    end

    # methods that will be available to the included class, eg: User.foo
    module ClassMethods
      include Enumerable
      extend Forwardable

      # The Identity Set that keeps all the persisted instances
      def store
        @store ||= begin
                     raise "This is Maglev only" unless defined?(Maglev)
                     # In the future, it might be nice to use something
                     # other than an IdentitySet. Set? Bag?
                     Maglev::PERSISTENT_ROOT[self] ||= IdentitySet.new
                   end
      end

      # Give access to SOME of @store's instance methods.
      # May want to expand this list at some point.
      # Most of the remaining useful ones are shared with Array, so they can be used
      # after calling #to_a first.
      def_delegators :store, :classify, :clear, :delete, :delete?, :delete_if, :each, :empty?, :size, :to_a

      # There's no default sorting, as IdentitySet doesn't have it.
      # Maybe add in later?
      alias all to_a

      # If the arg is a module, check manually. Otherwise, we're probably talking
      # about #include? on the store.
      def include?(arg)
        arg.is_a?(Module) ? !!included_modules.detect{ |m| m === arg } : store.include?(arg)
      end

      # Change this after Peter adds IdentitySet#clear
      # https://gist.github.com/806923
      def delete_all
        all.each{ |o| delete(o) }
      end
      
    end

    # methods that will be available to instances of a class, eg: User.new.bar
    module InstanceMethods
      
      # Store the instance in the store
      def persist
        !!self.class.store.add?(self)
      end

      # Remove the instance from the store
      def desist
        self.class.delete self
      end

      # Already persisted?
      def persistent?
        self.class.include? self
      end

      # Yet to be persisted?
      def transient?
        !persistent?
      end

    end
  end
end
