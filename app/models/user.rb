class User < ApplicationRecord
  attr_accessor :remember_token
  has_secure_password
  before_save { email.downcase! }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence:   true,
                    length:     { maximum: 255 },
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length:   { minimum: 12 },
                       presence: true

  # Sets up token for remembering a user's session
  def remember
    # create a token
    self.remember_token = User.new_token
    # encrypt it and put it into the DB
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Forgets a rememberd user by purging the remember token digest from the DB
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Returns tru of the given token matches the digest
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  class << self
    # Returns hash digest of the given string
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # Returns a random token
    def new_token
      SecureRandom.urlsafe_base64
    end
  end
end
