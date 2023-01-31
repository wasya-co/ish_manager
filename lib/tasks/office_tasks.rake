
def puts! a, b=''
  puts "+++ +++ #{b}"
  puts a.inspect
end

namespace :office do

  desc "send emails"
  task :email_worker => :environment do
    while true do

      ctxs = ::Ish::EmailContext.current.unsent
      puts! ctxs.count, 'ctxs'
      ctxs.map do |ctx|
        IshManager::OfficeMailer.send_context_email( ctx[:id].to_s ).deliver_later
        print '.'
      end

      # sleep 1.minute
      sleep 10.seconds
      print '^'

    end
  end

end
