class User < ActiveRecord::Base

  has_many :authentications

  attr_accessible :email

  devise :database_authenticatable, :registerable,  :trackable, :validatable

  def password_required?; false; end

  def apply_omniauth(omniauth)
    self.email = extract_email(omniauth) if email.blank?
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end

  private

  def extract_email(omniauth)
    (omniauth['provider'] == 'facebook' ? omniauth['extra']['user_hash'] : omniauth['user_info'])['email']
  end
end
