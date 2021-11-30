class User < ApplicationRecord
  attr_accessor :remember_token
  before_save{self.email = email.downcase}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, uniqueness: true, length: {maximum: 50},
  format: {with: VALID_EMAIL_REGEX}
  validates :password, length: {in: 6..20}
  validates :name, exclusion: {in: %w(obama trump), message: "%{value} not a valid name"},
  length: {maximum: 50}
  has_secure_password
  validate :valid_age, if: proc{|u| u.birthday.present?}

  def valid_age
    return if Date.parse(birthday) > 100.years.ago.to_date

    errors.add(:birthday, "invalid birthday")
  end

  class << self
    # hash from token
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # compare between remember_token and bcrypt rembember_digest
  def authenticated? remember_token
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end
end
