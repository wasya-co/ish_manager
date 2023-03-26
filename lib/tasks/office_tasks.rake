
def puts! a, b=''
  puts "+++ +++ #{b}"
  puts a.inspect
end

namespace :office do

  desc 'schheduled email actions, rolling perform'
  task schs: :environment do
    while true do

      Sch.active.where({ :perform_at.lte => Time.now }).each do |sch|
        sch.update_attributes({ state: Sch::STATE_INACTIVE })

        # send now
        ctx = Ctx.new({
          email_template_id: sch.act.tmpl.id,
          lead_id: sch.lead.id,
          send_at: Time.now,
        })
        ctx.save!

        # schedule next actions & update the action
        sch.act.ties.each do |tie|
          next_act = tie.next_email_action
          next_at  = eval(tie.next_at_exe)
          next_sch = Sch.find_or_initialize_by({
            lead_id: sch.lead_id,
            email_action_id: next_act.id,
          })
          next_sch.perform_at = next_at
          next_sch.state      = Sch::STATE_ACTIVE
          next_sch.save!
        end

        print '+'

      end

      # sleep 1.minute
      sleep 10.seconds
      print '.'
    end
  end

  desc "send emails"
  task email_worker: :environment do
    while true do

      ctxs = ::Ish::EmailContext.scheduled.unsent
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
