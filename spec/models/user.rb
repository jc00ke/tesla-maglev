class User
  include Tesla::Model

  attr_accessor :username, :email
  #validates :username,  :presence   => true,
                        #:uniqueness => true

  #validates :email,     :presence   => true,
                        #:uniqueness => true
end

