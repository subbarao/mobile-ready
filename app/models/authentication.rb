class Authentication < ActiveRecord::Base
  belongs_to :user
  validates :provider, :presence => true, :uniqueness => { :scope => :user_id }
  validates :user_id, :presence => true

  def provider_name
    provider == 'open_id' ? "OpenID" : provider.titleize
  end
end
