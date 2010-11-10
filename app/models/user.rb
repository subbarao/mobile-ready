class User < ActiveRecord::Base
  has_many :authentications

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :rememberable, :trackable, :validatable
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email

  def apply_omniauth(omniauth)
    self.email = omniauth['user_info']['email'] if email.blank?
    if email.blank? && omniauth['provider'] == 'facebook'
      self.email = omniauth['extra']['user_hash']['email']
    end
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end

  def password_required?
    false
  end
end
