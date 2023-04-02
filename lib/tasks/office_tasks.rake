
namespace :office do

  desc 'scheduled email actions, rolling perform'
  task schs: :environment do
    while true do

      Sch.active.where({ :perform_at.lte => Time.now }).each do |sch|

        sch.send_and_roll

        print '+'
      end

      # sleep 1.minute
      sleep 10.seconds
      print '.'
    end
  end

  ## 2023-04-02 _vp_ Continue.
  desc "send emails"
  task ctxs: :environment do
    while true do

      ctxs = ::Ish::EmailContext.scheduled.notsent
      ctxs.map do |ctx|
        out = IshManager::OfficeMailer.send_context_email( ctx[:id].to_s )
        Rails.env.production? ? out.deliver_later : out.deliver_now
        print '^'
      end

      sleep 60 # seconds
      print '.'
    end
  end

end
