# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@qwizard.com'
  layout 'mailer'
end
