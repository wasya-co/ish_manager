
namespace :m3_dummy do

  desc 'create a new user'
  task :create_user => :environment do
    puts "enter email:"
    email = STDIN.gets.chomp
    puts "enter password:"
    password = STDIN.gets.chomp

    user = User.new email: email, password: password
    profile = Ish::UserProfile.create( email: email, role_name: 'guy' )
    if user.save && profile.save
      puts "Created the user."
    else
      puts "Cannot create user: #{user.errors.full_messages.join(', ')} "
      puts "or cannot create profile: #{profile.errors.full_messages.join(', ')}."
    end
  end

end
