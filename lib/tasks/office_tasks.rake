
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

  desc 'office actions exe, rolling perform'
  task oacts: :environment do
    while true do

      ## send and roll
      Office::Action.active.where({ :perform_at.lte => Time.now }).each do |oact|

        oact.update({ state: OAct::STATE_INACTIVE })
        eval( oact.action_exe )
        oact.ties.each do |tie|
          next_oact            = tie.next_office_action
          next_oact.perform_at = eval(tie.next_at_exe)
          next_oact.state      = OAct::STATE_ACTIVE
          next_oact.save!
        end

        print '+'
      end

      duration = Rails.env.production? ? 300 : 10 # 5 minutes or 10 seconds
      sleep duration
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
