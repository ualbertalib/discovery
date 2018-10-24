# This class intercepts all email messages sent, clears the to/cc/bcc recipients and simply sends the
# message to the intercept mail address.  This allows us to test the messages that are sent from the
# system. See also `config/initializers/intercept_mail.rb`.
class EmailInterceptor
  def self.delivering_email(message)
    # grab the intercept mail address from the application secrets
    to = Rails.application.secrets.intercept_mail_address

    # create a message to prepend to the top of the email
    html_prepend = I18n.t('mail.intercepted.explanation.html', to: to)
    html_prepend += if message.to.blank?
                      I18n.t('mail.intercepted.to_blank.html')
                    else
                      I18n.t('mail.intercepted.to_cleared.html', recipients: message.to.to_sentence)
                    end

    html_prepend += if message.cc.blank?
                      I18n.t('mail.intercepted.cc_blank.html')
                    else
                      I18n.t('mail.intercepted.cc_cleared.html', recipients: message.cc.to_sentence)
                    end
    html_prepend += if message.bcc.blank?
                      I18n.t('mail.intercepted.bcc_blank.html')
                    else
                      I18n.t('mail.intercepted.bcc_cleared.html', recipients: message.bcc.to_sentence)
                    end
    html_prepend += I18n.t('mail.intercepted.original_message_below.html')
    html_prepend += '<hr/>'

    plain_prepend = I18n.t('mail.intercepted.explanation.plain', to: to)
    plain_prepend += '\n'
    plain_prepend += if message.to.blank?
                       I18n.t('mail.intercepted.to_blank.plain')
                     else
                       I18n.t('mail.intercepted.to_cleared.plain', recipients: message.to.to_sentence)
                     end
    plain_prepend += '\n'
    plain_prepend += if message.cc.blank?
                       I18n.t('mail.intercepted.cc_blank.plain')
                     else
                       I18n.t('mail.intercepted.cc_cleared.plain', recipients: message.cc.to_sentence)
                     end
    plain_prepend += '\n'
    plain_prepend += if message.bcc.blank?
                       I18n.t('mail.intercepted.bcc_blank.plain')
                     else
                       I18n.t('mail.intercepted.bcc_cleared.plain', recipients: message.bcc.to_sentence)
                     end
    plain_prepend += '\n'
    plain_prepend += I18n.t('mail.intercepted.original_message_below.plain')
    plain_prepend += '\n'

    # now clear the to/cc/bcc recipients and only send to the test email group
    message.to = [to]
    message.cc = []
    message.bcc = []

    if message.multipart?
      message.html_part.body.raw_source.prepend(html_prepend)
      message.text_part.body.raw_source.prepend(plain_prepend)
    elsif message.content_type.to_s['text/html']
      message.body.raw_source.prepend(html_prepend)
    else
      message.body.raw_source.prepend(plain_prepend)
    end
  end
end
