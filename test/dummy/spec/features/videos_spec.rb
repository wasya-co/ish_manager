require 'spec_helper'

RSpec.describe 'Videos system', type: :feature do

  it 'youtube thumb' do
    email = 'some@email.com'
    user = create(:user, email: email)
    profile = create(:profile, email: email, role_name: 'admin')
    video = create(:video, user_profile: profile)

    login_as(user, scope: :user)

    visit "/manager/videos"

    expect(page).to have_css('.videos--index')
    expect(page).to have_css('.video-embed-half')
  end

end
