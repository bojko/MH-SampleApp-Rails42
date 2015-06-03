class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token

  before_save     :downcase_email
  before_create   :create_activation_digest

  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i  # Pragmatic, not exhaustive

  validates :email,
    presence: true,
    length: {maximum: 255},
    format: {with: VALID_EMAIL},
    uniqueness: {case_sensitive: false}

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # Returns the hash digest of the given string

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Creates a new remembral token

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # Remember a user in the database for use in persistent sessions

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Forget a user when logged out

  def forget
    update_attribute(:remember_digest, nil)
  end

  # Returns whether the given token matches the digest

  def authenticated?(attribute, token)
    digest = send "#{attribute}_digest"
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password? token
  end

  # Take care of activation

  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Send the activation email

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

  # Downcase the email address
  def downcase_email
    self.email.downcase!
  end

  # Create and assign the activation token and digest
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
