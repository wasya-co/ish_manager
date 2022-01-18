
FactoryBot.define do
  # alphabetized : )

  factory :admin do
    email { 'piousbox@gmail.com' }
    password { '1234567890' }
    after :build do |u|
      p = Ish::UserProfile.create email: 'piousbox@gmail.com', name: 'sudoer', user: u
    end
  end

  factory :city do
    name { 'City' }
    cityname { 'city' }
  end

  factory :gallery do
    name { 'xxTestxx' }
    slug { 'xxSlugxx' }
    is_trash { false }
    after :build do |g|
      g.site ||= Site.new( :domain => 'xxDomainxx', :lang => 'xxLangxx' )
      g.slug ||= name
    end
  end

  factory :image_asset, class: Ish::ImageAsset do
    image { File.new(File.join(Rails.root, 'data', 'image.jpg')) }
  end

  factory :map, class: Gameui::Map do
    name { 'name' }
    slug { 'slug' }
    after :build do |map|
      map.image = FactoryGirl.create :image_asset
    end
  end

  factory :marker, class: Gameui::Marker do
    name { 'name' }
    slug { 'slug' }
    after :build do |map|
      map.image = FactoryGirl.create :image_asset
      map.item_type = ::Gameui::Marker::ITEM_TYPES[0]
    end
  end

  factory :newsitem do
  end

  factory :photo do
  end

  factory :purchase, class: Gameui::PremiumPurchase do
  end

  factory :report do
    name { 'Report Name' }
  end

  factory :site do
  end

  factory :tag do
    name { 'tag-name' }
  end

  factory :user do
    email { 'test@gmail.com' }
    password { '12345678' }
  end

  factory :user_profile, :class => Ish::UserProfile do
    email { 'user@email.com' }
    name { 'some-name' }
    after :build do |p|
      u = User.find_or_create_by :email => p.email
      p.user = u
    end
  end

  factory :video do
    youtube_id { 'some-youtube-id' }
  end


end
