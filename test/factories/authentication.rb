Factory.define :authentication do |a|
  a.association :user, :factory => :user
  a.uid { (rand * 10000).to_s }
  a.provider { %w(open_id facebook twitter)[(rand*3).floor.to_i] }
end
