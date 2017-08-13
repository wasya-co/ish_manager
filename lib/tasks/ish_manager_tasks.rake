
namespace :ish do

  desc "every user needs a user_profile"
  task :generate_user_profiles => :environment do
    User.all.map do |u|
      unless u.profile
        p = ::IshModels::UserProfile.new :email => u.email, :user => u, :role_name => :guy
        u.profile = p
        u.save && p.save && print('.')
      end
    end
    puts 'OK'
  end

end
