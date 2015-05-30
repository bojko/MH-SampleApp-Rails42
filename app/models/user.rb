class User < ActiveRecord::Base

  before_save { self.email = email.downcase }

  validates :name, presence: true, length: {maximum: 50}

  VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/   # Pragmatic, not exhaustive

  validates :email,
    presence: true,
    length: {maximum: 255},
    format: {with: VALID_EMAIL},
    uniqueness: true

  has_secure_password
  validates :password, presence: true, length: {minimum: 6}
end
