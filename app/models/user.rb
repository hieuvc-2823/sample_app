class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, uniqueness: true, length: {maximum: 50},
  format: {with: VALID_EMAIL_REGEX}
  validates :password, length: {in: 6..20}
  validates :name, exclusion: {in: %w(o), message: "%{value} not a valid name"},
  length: {maximum: 50}
  has_secure_password
  validate :valid_age, if: proc{|u| u.birthday.present?}
  def valid_age
    return if Date.parse(birthday) > 100.years.ago.to_date
    errors.add(:birthday, "invalid birthday")
  end
end
