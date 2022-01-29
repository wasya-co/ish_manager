
## @TODO: this is copy-pasted *in part* from ish_models, should be in one place really.
## should convert location of factories across gems

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
      map.image = create :image_asset
    end
  end

  factory :marker, class: Gameui::Marker do
    name { 'name' }
    slug { 'slug' }
    after :build do |map|
      map.image = create :image_asset
      map.item_type = ::Gameui::Marker::ITEM_TYPES[0]
    end
  end

  factory :newsitem do
  end

  factory :option_watch, class: Warbler::OptionWatch do
    contractType { 'PUT' }
    date { '2021-01-01' }
    price { 55 }
    strike { 100 }
    ticker { 'SPY' }
    after :build do |doc|
      doc.profile = create(:user_profile)
    end
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

  factory :stock_watch, class: Warbler::StockWatch do
    price { 55 }
    ticker { 'SPY' }
    after :build do |doc|
      doc.profile = create(:user_profile)
    end
  end

  factory :tag do
    name { 'tag-name' }
  end

  factory :user do
    sequence :email do |n|
      "some-#{n}@email.com"
    end
    password { '1234567890' }
  end

  factory :user_profile, :class => Ish::UserProfile do
    sequence :email do |n|
      "test-#{n}@email.com"
    end
    name { 'some-name' }
    after :build do |doc|
      doc.user = create(:user)
    end
  end

  factory :video do
    name { 'some-name' }
    youtube_id { 'some-youtube-id' }
  end


end
