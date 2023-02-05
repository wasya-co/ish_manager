
def puts! a, b=''
  puts "+++ +++ #{b}"
  puts a.inspect
end

namespace :ish_manager do

  desc "every user needs a user_profile"
  task :generate_user_profiles => :environment do
    User.all.map do |u|
      unless u.profile
        p = ::Ish::UserProfile.new :email => u.email, :user => u, :role_name => :guy
        u.profile = p
        u.save && p.save && print('.')
      end
    end
    puts 'OK'
  end

  desc 'assign my creator_profile to Gameui::Marker where missing'
  task :gameui_markers_creator_profile => :environment do
    ms = Gameui::Marker.where( creator_profile_id: nil )
    profile = User.find_by( email: 'piousbox@gmail.com' ).profile
    ms.update_all( creator_profile_id: profile.id )
  end


end
