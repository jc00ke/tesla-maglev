require 'active_model'

module Tesla
  module Model

    extend ActiveSupport::Concern

    # Flag any classes that include Model to also be persistable
    included do
      class_eval{ maglev_persistable }
      extend ActiveModel::Naming
      include ActiveModel::Validations
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

      # Change this to alias clear after Peter adds IdentitySet#clear
      # https://gist.github.com/806923
      def delete_all
        all.each{ |o| delete(o) }
      end

      def new(options={})
        super(options).tap { |o| options.each { |k,v| o.send("#{k}=", v) if o.respond_to?("#{k}=") } }
      end 

      def create(options={})
        new(options).tap { |o| o.save }
      end

      def find(param)
        detect{ |o| o.to_param == param }
      end

      def method_missing(name, *args, &block)
        return detect { |e| e.send($1) == args.first } if name.to_s =~ /^find_by_(.+)$/
        super
      end
    end

    # methods that will be available to instances of a class, eg: User.new.bar
    module InstanceMethods

      def tap
        yield(self)
        self
      end
      
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

      def destroy
        @destroyed = true
        desist
      end

      # ActiveModel compliance

      alias persisted? persistent?
      alias new_record? transient?
      alias save persist

      def to_model
        self
      end

      def to_key
        persistent? ? [object_id] : nil
      end

      def to_param
        raise NotImplementedError, "Please implement in included class"
      end

    end
  end
end
