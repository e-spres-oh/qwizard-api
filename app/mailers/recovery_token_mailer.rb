# frozen_string_literal: true

class RecoveryTokenMailer < ApplicationMailer
  def recovery_token
    @user = params[:user]
    mail(to: @user.email, subject: 'Token to recover your password')
  end
end
