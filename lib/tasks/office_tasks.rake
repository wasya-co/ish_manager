
def puts! a, b=''
  puts "+++ +++ #{b}"
  puts a.inspect
end

namespace :office do

  desc 'schheduled email actions, rolling perform'
  task :schs => :environment do
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

        # schedule the next action & update the action
        next_at = eval(sch.act.next_at_exe)
        sch.act.next_email_actions.each do |nxt|
          sch_nxt = Sch.find_or_initialize_by({
            lead_id: sch.lead_id,
            email_action_id: nxt.id,
          })
          sch_nxt.perform_at = next_at
          sch_nxt.state = Sch::STATE_ACTIVE
          sch_nxt.save!
        end

        print '.'

      end

      # sleep 1.minute
      sleep 10.seconds
      print '|'
    end
  end

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
