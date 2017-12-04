
def puts! a, b=""
  puts "+++ +++ #{b}"
  puts a.inspect
end

task :migrate => [ 'migrate:assign_galleries_to_profile' ]

namespace :migrate do

  desc 'assign galleries to profile'
  task :assign_galleries_to_profile => :environment do
    u = User.find_by :email => 'piousbox@gmail.com'
    Gallery.where( :user_profile => nil ).update_all( :user_profile_id => u.profile.id )
    puts 'Each gallery is associated with a user profile.'
  end

end
  
