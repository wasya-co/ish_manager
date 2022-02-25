
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

end

