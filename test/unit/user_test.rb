require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class UserTest < ActiveSupport::TestCase

  context "User instance" do
    subject { Factory(:user) }
    should validate_presence_of(:email)
  end

  context "User instance when applying omniauth" do

    context "from gmail/yahoo " do
      should "know how to extract email" do
        user = User.new
        omniauth = {
          'user_info' => {
            'email' => 'john@yahoo.com'
          }
        }

        user.apply_omniauth(omniauth)

        assert_equal 'john@yahoo.com',user.email
      end
    end

    context "from facebook" do
      should "know how to extract email" do
        user = User.new
        omniauth = {
          'provider' => 'facebook',
          'user_info' => {},
          'extra' => {
            'user_hash' => {
              'email' => 'john@yahoo.com'
            }
          }
        }

        user.apply_omniauth(omniauth)

        assert_equal 'john@yahoo.com',user.email
      end
    end
  end
end
