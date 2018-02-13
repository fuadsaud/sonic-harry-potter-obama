require 'sendgrid-ruby'

class SendMail
  include SendGrid

  def call(content)
    from = Email.new(email: 'fuadfsaud@gmail.com')
    subject = 'Clothing Report'
    to = Email.new(email: 'fuadfsaud@gmail.com')
    content = Content.new(type: 'text/html', value: content)
    mail = Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
  end
end

