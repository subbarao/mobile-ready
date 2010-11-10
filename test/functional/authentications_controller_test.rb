require File.expand_path(File.dirname(__FILE__) + '/../test_helper')
require 'ostruct'

class AuthenticationsControllerTest < ActionController::TestCase

  context "AuthenticationController" do
    context "user with authentication record" do
      setup do
        auth = stub(:user => "user")
        @mock_warden = OpenStruct.new
        @mock_warden.expects(:user).with(:user).returns("user")
        @controller.request.env['warden'] = @mock_warden
        @controller.request.env['omniauth.auth'] = { "provider" => "facebook", "uid" => "2345" }
        Authentication.expects(:find_by_provider_and_uid).with("facebook","2345").returns(auth)
        post :create
      end
      should set_the_flash.to("Signed in successfully.")
    end

    context "user without authentication record" do
      setup do
        user = Factory(:user)
        @controller.request.env['omniauth.auth'] = { "provider" => "facebook", "uid" => "2345" }
        @controller.stubs(:current_user).returns(user)
        post :create
      end
      should set_the_flash.to("Authentication successful.")
    end
  end

end
