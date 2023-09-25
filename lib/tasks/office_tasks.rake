
namespace :office do

  desc 'scheduled email actions, rolling perform'
  task schs: :environment do
    while true do

      ## Office::ScheduledEmailAction
      Sch.active.where({ :perform_at.lte => Time.now }).each do |sch|

        sch.send_and_roll

        print '.'
      end

      duration = Rails.env.production? ? 120 : 15 # 2 minutes or 15 seconds
      sleep duration
      print '^'

    end
  end

  desc 'office actions exe, rolling perform'
  task oacts: :environment do
    while true do

      ## send and roll
      Office::Action.active.where({ :perform_at.lte => Time.now }).each do |oact|
        oact.update({ perform_at: nil })
        eval( oact.action_exe )
        oact.ties.each do |tie|
          next_oact            = tie.next_office_action
          next_oact.perform_at = eval(tie.next_at_exe)
          next_oact.state      = OAct::STATE_ACTIVE
          next_oact.save!
        end

        print '+'
      end

      duration = Rails.env.production? ? 360 : 15 # 6 minutes or 15 seconds
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

        unsub = Ish::EmailUnsubscribe.where({ lead_id: ctx.lead_id, template_id: ctx.email_template_id }).first
        if unsub
          puts! 'This user is unsubscribed; the context cannot be sent.' if DEBUG
          Office::AdminMessage.create({ message: "Lead `#{ctx.lead.full_name}` [mailto:#{ctx.lead.email}] has already unsubscribed from template `#{Ish::EmailTemplate.find( ctx.email_template_id ).slug}` ." })
          email_action_ids = EAct.where({ email_template_id: ctx.email_template_id }).map(&:id)
          schs = Sch.active.where({
            lead_id: ctx.lead_id,
            :email_action_id.in => email_action_ids,
          })
          schs.update({ state: Office::ScheduledEmailAction::STATE_UNSUBSCRIBED })
          ctx.update({
            unsubscribed_at: Time.now.to_s,
          })
        else
          out = IshManager::OfficeMailer.send_context_email( ctx[:id].to_s )
          Rails.env.production? ? out.deliver_later : out.deliver_now
        end

        print '.'
      end

      duration = Rails.env.production? ? 120 : 15 # 2 minutes or 15 seconds
      sleep duration
      print '^'

    end
  end

end
