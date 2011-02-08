module Tesla
  module Validations
    class UniquenessValidator < ActiveModel::EachValidator
      # TODO Re-mother-mother-factor
      # Yes, this is bad. But it's a start.
      # Why is it bad? For one, #find_by_* is caught by method_missing
      # and will in turn #detect across all of our persisted models. Can anyone
      # say O(n)? This could get much smarter with indexes. We'll get there.
      def validate_each(model, attribute, _)
        found = model.class.send("find_by_#{attribute}", model.send(attribute))
        model.errors[attribute] << 'must be unique' if found && found.object_id != model.object_id
      end
    end
  end
end
