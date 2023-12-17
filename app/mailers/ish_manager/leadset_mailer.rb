require 'open-uri'

class IshManager::LeadsetMailer < IshManager::ApplicationMailer
  default from: 'WasyaCo Consulting <hello@wasya.co>'

  # layout 'mailer'

  def monthly_invoice invoice_id
    @invoice = ::Ish::Invoice.find invoice_id
    @leadset = @invoice.leadset

    path = Rails.root.join 'tmp', @invoice.filename
    download = open( @invoice.asset.object.url(:original) )
    IO.copy_stream( download, path )
    attachments[@invoice.filename] = File.read( path )

    mail( from:    'victor@wasya.co',
          to:      @leadset.email,
          cc:      'poxlovi@gmail.com',
          subject: "WasyaCo invoice for #{@invoice.month_on.strftime('%B')}",
        )
  end

end
