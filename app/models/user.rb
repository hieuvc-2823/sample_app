class User < ApplicationRecord
  attr_accessor :remember_token
  before_save{self.email = email.downcase}
  validates :email, uniqueness: true,
   length: {maximum: Settings.length.len_50},
   format: {with: Settings.regex}
  validates :password, length:
   {in: Range.new(Settings.length.len_6, Settings.length.len_50)}
  validates :name, exclusion: {in: %w(Obama), message: I18n.t("errors.email")},
   length: {maximum: Settings.length.len_20}
  validate :valid_age, if: ->{birthday.present?}

  has_secure_password

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
    update_column(:remember_digest, User.digest(remember_token))
  end

  # compare between remember_token and bcrypt rembember_digest
  def authenticated? remember_token
    return false unless remember_digest

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_column(:remember_digest, nil)
  end

  private

  def valid_age
    return if Date.parse(birthday) > Settings.age.years.ago.to_date

    errors.add(:birthday, I18n.t("errors.birthday"))
  end
end
