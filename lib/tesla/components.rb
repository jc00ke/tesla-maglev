module Tesla
  module Components
    # See https://github.com/mongoid/mongoid/blob/master/lib/mongoid/components.rb
    # for motivation

    include ActiveModel::Naming
<<<<<<< HEAD
    #include ActiveModel::Validations
    #include ActiveModel::Errors
    #include Tesla::Validations
=======
    include Tesla::Validations
>>>>>>> 710631c3755e18d32982e8698a6d8c26f4e864bb
  end
end
