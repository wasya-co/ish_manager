
FactoryGirl.define do

  factory :city do
    name 'City'
    cityname 'city'
    name_ru 'city'
    name_pt 'city'
    name_en 'city'
  end

  factory :gallery do
    name 'xxTestxx'
    after :build do |g|
      g.site ||= Site.new( :domain => 'xxDomainxx', :lang => 'xxLangxx' )
    end
  end

  factory :photo do
  end

  factory :site do
  end

  factory :user do
    email 'test@gmail.com'
    password '12345678'
  end

  factory :user_profile, :class => IshModels::UserProfile do
    email 'user@email.com'
    after :build do |p|
      u = User.find_or_create_by :email => p.email
      p.user = u
    end
  end

end
