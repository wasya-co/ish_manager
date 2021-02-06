require 'spec_helper'

RSpec.describe 'Videos system', type: :feature do

  it 'youtube thumb' do
    profile = IshModels::UserProfile.create role_name: 'admin'
    user = User.create profile: profile
    video = Video.create youtube_id: 'a', user_profile: profile
    login_as(user, scope: :user)

    visit "/ish_manager/videos"

    expect(page).to have_css('.videos-index')
    expect(page).to have_css('.thumb-youtube')
  end

end
