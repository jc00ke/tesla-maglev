class User
  include Tesla::Model

  attr_accessor :username, :email
<<<<<<< HEAD
  validates :username,  :presence   => true#,
                        #:uniqueness => true

  validates :email,     :presence   => true#,
=======
  #validates :username,  :presence   => true,
                        #:uniqueness => true

  #validates :email,     :presence   => true,
>>>>>>> 710631c3755e18d32982e8698a6d8c26f4e864bb
                        #:uniqueness => true
end

