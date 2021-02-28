# frozen_string_literal: true

class PasswordRecoveryMailer < ApplicationMailer
  def recovery_token
    @user = params[:user]
    mail(to: @user.email, subject: 'Password recovery token')
  end

  def recover_password
    @user = params[:user]
    mail(to: @user.email, subject: 'Recover your password')
  end
end
