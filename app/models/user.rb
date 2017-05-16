class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  has_secure_password
  before_save :downcase_email
  before_create :create_activation_digest
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence:   true,
                    length:     { maximum: 255 },
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length:    { minimum: 12 },
                       presence:  true,
                       allow_nil: true # allow username and email to change without updating password, but `has_secure_password` will still ensure people can't signup with nil password at the first step

  has_many :microposts,            dependent: :destroy
  has_many :active_relationships,  class_name:  'Relationship',
                                   foreign_key: 'follower_id',
                                   dependent:   :destroy
  has_many :passive_relationships, class_name:  'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent:   :destroy
  has_many :following,             through: :active_relationships,
                                   source: :followed
  has_many :followers,             through: :passive_relationships,
                                   source: :follower

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

  # Returns true if the given token matches the digest
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Activates an account
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Sends activation email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Downcases the users email
  def downcase_email
    email.downcase!
  end

  # Set up password reset attributes
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # Sends password reset email
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password rest token has expired
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Defines a proto-feed
  def feed
    following_ids = "SELECT followed_id FROM relationships
                      WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id",
                    following_ids: following_ids, user_id: id)
  end

  # Follows a user
  def follow(other_user)
    following << other_user
  end

  # Unfollows a user
  def unfollow(other_user)
    following.delete(other_user)
  end

  # Returns true if a given user is being followed by the current user
  def following?(other_user)
    following.include?(other_user)
  end

  # Class Methods
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

  private

  # Create and assign activation tokens
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
