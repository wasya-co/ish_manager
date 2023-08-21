
def puts! a, b=""
  puts "+++ +++ #{b}"
  puts a.inspect
end

task :migrate => [ 'migrate:assign_galleries_to_profile' ]

namespace :migrate do

  desc 'assign galleries to profile'
  task :assign_galleries_to_profile => :environment do
    u = User.find_by :email => 'piousbox@gmail.com'
    Gallery.unscoped.where( :user_profile => nil ).update_all( :user_profile_id => u.profile.id )
    puts 'Each gallery is associated with a user profile.'
  end

  desc 'destination for every marker'
  task :markers_destinations => :environment do
    ms = Marker.where( destination: nil )
    ms.each do |m|
      d = Map.where( slug: m.slug ).first
      if d
        m.destination = d
        m.save
        puts "Marker |#{m.name}| got destination |#{m.slug}|."
      else
        puts "+++ +++ #{m.slug}, No destination for this one."
      end
    end
  end

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

