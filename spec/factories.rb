
FactoryGirl.define do

  factory :site do
  end

  factory :gallery do
    name 'xxTestxx'
    after :build do |g|
      g.site ||= Site.new :domain => 'xxDomainxx', :lang => 'xxLangxx'
    end
  end

  factory :photo do
  end

end
