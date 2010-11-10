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
        user.expects(:authentications).returns(mock(:create! => true))
        @controller.request.env['omniauth.auth'] = { "provider" => "facebook", "uid" => "2345" }
        @controller.stubs(:current_user).returns(user)
        post :create
      end
      should set_the_flash.to("Authentication successful.")
    end

    context "new user which succesfully created" do
      setup do
        user = User.new
        user.expects(:apply_omniauth).returns(true)
        user.expects(:save).returns(true)
        User.expects(:new).returns(user)
        @mock_warden = OpenStruct.new
        @mock_warden.expects(:user).with(:user).returns("user")
        @mock_warden.expects(:set_user).returns(true)
        @mock_warden.expects(:authenticate).with(:scope => :user).returns(nil)
        @controller.request.env['warden'] = @mock_warden
        @controller.request.env['omniauth.auth'] = { "provider" => "facebook", "uid" => "2345" }

        post :create
      end

      should set_the_flash.to("Signed in successfully.")
    end

    context "new user failed to create" do
      setup do
        user = User.new
        user.expects(:apply_omniauth).returns(true)
        user.expects(:save).returns(false)
        User.expects(:new).returns(user)
        @mock_warden = OpenStruct.new
        @mock_warden.expects(:authenticate).with(:scope => :user).returns(nil)
        @controller.request.env['warden'] = @mock_warden
        @controller.request.env['omniauth.auth'] = { "provider" => "facebook", "uid" => "2345" }

        post :create
      end

      should_not set_the_flash
    end
  end
end
