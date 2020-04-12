
FactoryGirl.define do

  factory :city do
    name 'City'
    cityname 'city'
  end

  factory :gallery do
    name 'xxTestxx'
    is_trash false
    after :build do |g|
      g.site ||= Site.new( :domain => 'xxDomainxx', :lang => 'xxLangxx' )
    end
  end

  factory :newsitem do
  end

  factory :photo do
  end

  factory :report do
    name 'Report Name'
  end

  factory :site do
  end

  factory :tag do
    name 'tag-name'
  end

  factory :user do
    email 'test@gmail.com'
    password '12345678'
  end

  factory :admin, :class => IshModels::User do
    email 'piousbox@gmail.com'
    password '1234567890'
    after :build do |u|
      p = IshModels::UserProfile.create email: 'piousbox@gmail.com', name: 'sudoer', user: u
    end
  end

  factory :user_profile, :class => IshModels::UserProfile do
    email 'user@email.com'
    name 'some-name'
    after :build do |p|
      u = User.find_or_create_by :email => p.email
      p.user = u
    end
  end

end
