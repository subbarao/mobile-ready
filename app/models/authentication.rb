class Authentication < ActiveRecord::Base
  belongs_to :user
  validates :provider, :presence => true, :uniqueness => { :scope => :user_id }

  def provider_name
    provider == 'open_id' ? "OpenID" : provider.titleize
  end
end
