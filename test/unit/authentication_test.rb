require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class AuthenticationTest < ActiveSupport::TestCase

  context "Authentication instance" do
    setup { Factory(:authentication) }
    should validate_presence_of(:provider)
    should validate_uniqueness_of(:provider).scoped_to(:user_id)
  end

  context "Authentication instance" do
    should "titleize the provider name unless provider is open_id" do
      authentication = Authentication.new(:provider => "gmail")
      assert_equal "Gmail", authentication.provider_name
    end
    should "return 'OpenID' if provider is open_id" do
      authentication = Authentication.new(:provider => "open_id")
      assert_equal "OpenID", authentication.provider_name
    end
  end
end
