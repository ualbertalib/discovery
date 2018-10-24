require 'discovery/email_interceptor'

if Rails.application.secrets.intercept_mail.present? &&
   Rails.application.secrets.intercept_mail_address.present?
  ActionMailer::Base.register_interceptor(EmailInterceptor)
end
