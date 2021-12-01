class User < ApplicationRecord
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

  private
  def valid_age
    return if Date.parse(birthday) > Settings.age.years.ago.to_date

    errors.add(:birthday, I18n.t("errors.birthday"))
  end
end
