Factory.define :user do |u|
  u.email { Faker::Internet.email }
end
